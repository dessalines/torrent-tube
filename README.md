# Torrent-Tube

Torrent-Tube is a set of tools to help decentralize YouTube videos, by moving them to torrents, which can be shared by many people. It includes:

- A [Torrent-Tube search site](https://dessalines.github.io/torrent-tube) which searches the [Torrents-csv](https://torrents-csv.com) search engine to see if the given YouTube video already exists, and is being seeded.
  - It does this by extracting the YouTube [VIDEO_ID] from a link, which you can also do manually if you like (IE, the text after `watch?v=...`).
- A script to check for previously made torrents, and if there are none, then download, and create torrent files from YouTube videos, with a uniform naming style and format, taken from [TheFrenchGhosty's YouTube-DL-Scripts](https://github.com/TheFrenchGhosty/TheFrenchGhostys-Ultimate-YouTube-DL-Scripts-Collection).
- You will need to upload these torrent files yourself to a service (details below), and seed them.

[Torrent-Tube Search](https://dessalines.github.io/torrent-tube/)

In the future, it may be possible to create a browser plugin that checks a video link that you're currently watching for existing torrents.

## Create torrent script

### Requirements

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [mktorrent](https://github.com/pobrn/mktorrent)
- [jq](https://jqlang.org/)
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
