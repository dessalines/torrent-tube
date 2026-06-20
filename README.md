# Torrent-Tube

Torrent-Tube is a group of tools to help decentralize YouTube videos, by moving them to torrents, which can be shared by many people. It includes:

- A [Torrent-Tube search site](https://dessalines.github.io/torrent-tube) which forwards YouTube links to the [Torrents-csv](https://torrents-csv.com) search engine, to see if the given YouTube video already exists, and is being seeded.
- A script to download, and create torrent files from YouTube videos, with a uniform naming style.
- You will need to upload these torrent files yourself to a service (details below).

[Torrent-Tube Search](https://dessalines.github.io/torrent-tube/)

## Create torrent script

### Requirements

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [mktorrent](https://github.com/pobrn/mktorrent)
- wget

### Instructions

Copy a YouTube video URL.

```sh
# Clone this repo
git clone https://github.com/dessalines/torrent-tube

# Run the script
./create_torrent.sh [YOUTUBE_URL]
```

The video will download, and is saved in the `videos` folder. The torrent file is saved in the `torrents` folder.

Add the torrent to your torrent app, such as [qbittorrent](https://www.qbittorrent.org/).

Upload the torrent file to a torrent index site, such as thepiratebay, 1337x, or follow [these instructions to add it to torrents-csv](https://codeberg.org/heretic/torrents-csv-data).

```

```
