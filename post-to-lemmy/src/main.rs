use anyhow::{Context, Result, anyhow};
use clap::{Arg, ArgMatches, Command};
use lava_torrent::torrent::v1::Torrent;
use lemmy_client::{
  ClientOptions,
  LemmyClient,
  lemmy_api_common::{community::GetCommunity, person::Login, post::CreatePost},
};
use serde_json::Value;
use std::{fs, path::Path};

#[tokio::main]
async fn main() -> Result<()> {
  let matches = Command::new("Post torrent to lemmy")
    .version("0.0.1")
    .author("Dessalines")
    .about("Posts a given YouTube torrent to lemmy")
    .arg(
      Arg::new("METADATA_FILE")
        .short('m')
        .long("metadata_file")
        .value_name("FILE")
        .required(true)
        .help("The location of the metadata JSON file from YouTube. Required for the thumbnail and description."),
    )
    .arg(
      Arg::new("TORRENT_FILE")
        .short('t')
        .long("torrent_file")
        .value_name("FILE")
        .required(true)
        .help("The location of the torrent file. Required to build the magnet link."),
    )
    .arg(
      Arg::new("LEMMY_SERVER")
        .short('s')
        .long("lemmy_server")
        .value_name("STRING")
        .default_value("lemmy.ml")
        .help("The url for the lemmy server. Ex. lemmy.ml"),
    )
    .arg(
      Arg::new("LEMMY_COMMUNITY")
        .short('c')
        .long("lemmy_community")
        .value_name("STRING")
        .default_value("torrenttube")
        .help("The name of the lemmy community to post to."),
    )
    .arg(
      Arg::new("LEMMY_USERNAME")
        .short('u')
        .long("lemmy_username")
        .value_name("STRING")
        .required(true)
        .help("Your lemmy username."),
    )
    .arg(
      Arg::new("LEMMY_PASSWORD")
        .short('p')
        .long("lemmy_password")
        .value_name("STRING")
        .required(true)
        .help("Your lemmy password."),
    )
    .get_matches();

  let torrent_path = arg_to_path(&matches, "TORRENT_FILE")?;
  let metadata_path = arg_to_path(&matches, "METADATA_FILE")?;
  let domain = matches
    .get_one::<String>("LEMMY_SERVER")
    .context("missing arg")?;
  let community = matches
    .get_one::<String>("LEMMY_COMMUNITY")
    .context("missing arg")?
    .to_owned();

  let user = matches
    .get_one::<String>("LEMMY_USERNAME")
    .context("missing arg")?;
  let password = matches
    .get_one::<String>("LEMMY_PASSWORD")
    .context("missing arg")?;

  // Extract the magnet link
  let torrent = Torrent::read_from_file(torrent_path)?;
  let name = &torrent.name;
  let magnet_link = &torrent.magnet_link()?;

  // Extract the thumbnail and description
  let metadata = fs::read_to_string(metadata_path)?;
  let metadata_json: Value = serde_json::from_str(&metadata)?;

  let thumbnail = metadata_json
    .get("thumbnail")
    .and_then(Value::as_str)
    .map(str::to_owned);

  let description = metadata_json
    .get("description")
    .and_then(Value::as_str)
    .map(str::to_owned);

  // Login to lemmy
  let mut client = LemmyClient::new(ClientOptions {
    domain: domain.to_string(),
    secure: true,
  });
  let login = client
    .login(Login {
      username_or_email: user.to_owned().into(),
      password: password.to_owned().into(),
      totp_2fa_token: None,
    })
    .await
    .map_err(|e| anyhow!("Couldn't log in: {e}"))?;
  let jwt = login.jwt.context("missing auth")?.into_inner();
  client
    .headers_mut()
    .insert("Authorization".to_string(), format!("Bearer {jwt}"));

  // Fetch the community id
  let community_id = client
    .get_community(GetCommunity {
      name: Some(community),
      id: None,
    })
    .await
    .map_err(|e| anyhow!("Couldn't get community: {e}"))?
    .community_view
    .community
    .id;

  // Create the post
  let create_post = client
    .create_post(CreatePost {
      name: name.to_owned(),
      community_id,
      url: Some(magnet_link.to_owned()),
      body: description,
      alt_text: None,
      honeypot: None,
      nsfw: None,
      language_id: None,
      custom_thumbnail: thumbnail,
    })
    .await
    .map_err(|e| anyhow!("Couldn't create post: {e}"))?;

  let post_url = format!("https://{domain}/post/{}", create_post.post_view.post.id);
  println!("Lemmy post: {post_url}");

  Ok(())
}

fn arg_to_path<'a>(matches: &'a ArgMatches, arg: &'a str) -> Result<&'a Path> {
  Ok(Path::new(
    matches.get_one::<String>(arg).context("no arg given")?,
  ))
}
