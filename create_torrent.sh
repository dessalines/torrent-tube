#!/bin/bash
set -e

# Check to see if the torrent exists

# Extract the youtube video id
youtube_video_id=$(yt-dlp --skip-download --get-id "$1")

# Fetch results from torrents-csv
torrents_csv_res=$(curl "https://torrents-csv.com/service/search?q=$youtube_video_id")

check=$(echo $torrents_csv_res | jq '.torrents | length > 0')
if [[ $check == "true" ]]; then
  echo "A torrent already exists:"
  echo $torrents_csv_res | jq
  exit 0
else
  echo "No results found, downloading video and creating torrent..."
fi

mkdir -p videos torrents

# Download the youtube video using yt-dlp.
#
# Adapted from TheFrenchGhostys *Watch on PC* script:
# https://github.com/TheFrenchGhosty/TheFrenchGhostys-Ultimate-YouTube-DL-Scripts-Collection
cd videos
yt-dlp --format "(bestvideo[vcodec^=av01][height>=4320][fps>30]/bestvideo[vcodec^=vp09.02][height>=4320][fps>30]/bestvideo[vcodec^=vp09.00][height>=4320][fps>30]/bestvideo[vcodec^=vp9][height>=4320][fps>30]/bestvideo[vcodec^=avc1][height>=4320][fps>30]/bestvideo[height>=4320][fps>30]/bestvideo[vcodec^=av01][height>=4320]/bestvideo[vcodec^=vp09.02][height>=4320]/bestvideo[vcodec^=vp09.00][height>=4320]/bestvideo[vcodec^=vp9][height>=4320]/bestvideo[vcodec^=avc1][height>=4320]/bestvideo[height>=4320]/bestvideo[vcodec^=av01][height>=2880][fps>30]/bestvideo[vcodec^=vp09.02][height>=2880][fps>30]/bestvideo[vcodec^=vp09.00][height>=2880][fps>30]/bestvideo[vcodec^=vp9][height>=2880][fps>30]/bestvideo[vcodec^=avc1][height>=2880][fps>30]/bestvideo[height>=2880][fps>30]/bestvideo[vcodec^=av01][height>=2880]/bestvideo[vcodec^=vp09.02][height>=2880]/bestvideo[vcodec^=vp09.00][height>=2880]/bestvideo[vcodec^=vp9][height>=2880]/bestvideo[vcodec^=avc1][height>=2880]/bestvideo[height>=2880]/bestvideo[vcodec^=av01][height>=2160][fps>30]/bestvideo[vcodec^=vp09.02][height>=2160][fps>30]/bestvideo[vcodec^=vp09.00][height>=2160][fps>30]/bestvideo[vcodec^=vp9][height>=2160][fps>30]/bestvideo[vcodec^=avc1][height>=2160][fps>30]/bestvideo[height>=2160][fps>30]/bestvideo[vcodec^=av01][height>=2160]/bestvideo[vcodec^=vp09.02][height>=2160]/bestvideo[vcodec^=vp09.00][height>=2160]/bestvideo[vcodec^=vp9][height>=2160]/bestvideo[vcodec^=avc1][height>=2160]/bestvideo[height>=2160]/bestvideo[vcodec^=av01][height>=1440][fps>30]/bestvideo[vcodec^=vp09.02][height>=1440][fps>30]/bestvideo[vcodec^=vp09.00][height>=1440][fps>30]/bestvideo[vcodec^=vp9][height>=1440][fps>30]/bestvideo[vcodec^=avc1][height>=1440][fps>30]/bestvideo[height>=1440][fps>30]/bestvideo[vcodec^=av01][height>=1440]/bestvideo[vcodec^=vp09.02][height>=1440]/bestvideo[vcodec^=vp09.00][height>=1440]/bestvideo[vcodec^=vp9][height>=1440]/bestvideo[vcodec^=avc1][height>=1440]/bestvideo[height>=1440]/bestvideo[vcodec^=av01][height>=1080][fps>30]/bestvideo[vcodec^=vp09.02][height>=1080][fps>30]/bestvideo[vcodec^=vp09.00][height>=1080][fps>30]/bestvideo[vcodec^=vp9][height>=1080][fps>30]/bestvideo[vcodec^=avc1][height>=1080][fps>30]/bestvideo[height>=1080][fps>30]/bestvideo[vcodec^=av01][height>=1080]/bestvideo[vcodec^=vp09.02][height>=1080]/bestvideo[vcodec^=vp09.00][height>=1080]/bestvideo[vcodec^=vp9][height>=1080]/bestvideo[vcodec^=avc1][height>=1080]/bestvideo[height>=1080]/bestvideo[vcodec^=av01][height>=720][fps>30]/bestvideo[vcodec^=vp09.02][height>=720][fps>30]/bestvideo[vcodec^=vp09.00][height>=720][fps>30]/bestvideo[vcodec^=vp9][height>=720][fps>30]/bestvideo[vcodec^=avc1][height>=720][fps>30]/bestvideo[height>=720][fps>30]/bestvideo[vcodec^=av01][height>=720]/bestvideo[vcodec^=vp09.02][height>=720]/bestvideo[vcodec^=vp09.00][height>=720]/bestvideo[vcodec^=vp9][height>=720]/bestvideo[vcodec^=avc1][height>=720]/bestvideo[height>=720]/bestvideo[vcodec^=av01][height>=480][fps>30]/bestvideo[vcodec^=vp09.02][height>=480][fps>30]/bestvideo[vcodec^=vp09.00][height>=480][fps>30]/bestvideo[vcodec^=vp9][height>=480][fps>30]/bestvideo[vcodec^=avc1][height>=480][fps>30]/bestvideo[height>=480][fps>30]/bestvideo[vcodec^=av01][height>=480]/bestvideo[vcodec^=vp09.02][height>=480]/bestvideo[vcodec^=vp09.00][height>=480]/bestvideo[vcodec^=vp9][height>=480]/bestvideo[vcodec^=avc1][height>=480]/bestvideo[height>=480]/bestvideo[vcodec^=av01][height>=360][fps>30]/bestvideo[vcodec^=vp09.02][height>=360][fps>30]/bestvideo[vcodec^=vp09.00][height>=360][fps>30]/bestvideo[vcodec^=vp9][height>=360][fps>30]/bestvideo[vcodec^=avc1][height>=360][fps>30]/bestvideo[height>=360][fps>30]/bestvideo[vcodec^=av01][height>=360]/bestvideo[vcodec^=vp09.02][height>=360]/bestvideo[vcodec^=vp09.00][height>=360]/bestvideo[vcodec^=vp9][height>=360]/bestvideo[vcodec^=avc1][height>=360]/bestvideo[height>=360]/bestvideo[vcodec^=avc1][height>=240][fps>30]/bestvideo[vcodec^=av01][height>=240][fps>30]/bestvideo[vcodec^=vp09.02][height>=240][fps>30]/bestvideo[vcodec^=vp09.00][height>=240][fps>30]/bestvideo[vcodec^=vp9][height>=240][fps>30]/bestvideo[height>=240][fps>30]/bestvideo[vcodec^=avc1][height>=240]/bestvideo[vcodec^=av01][height>=240]/bestvideo[vcodec^=vp09.02][height>=240]/bestvideo[vcodec^=vp09.00][height>=240]/bestvideo[vcodec^=vp9][height>=240]/bestvideo[height>=240]/bestvideo[vcodec^=avc1][height>=144][fps>30]/bestvideo[vcodec^=av01][height>=144][fps>30]/bestvideo[vcodec^=vp09.02][height>=144][fps>30]/bestvideo[vcodec^=vp09.00][height>=144][fps>30]/bestvideo[vcodec^=vp9][height>=144][fps>30]/bestvideo[height>=144][fps>30]/bestvideo[vcodec^=avc1][height>=144]/bestvideo[vcodec^=av01][height>=144]/bestvideo[vcodec^=vp09.02][height>=144]/bestvideo[vcodec^=vp09.00][height>=144]/bestvideo[vcodec^=vp9][height>=144]/bestvideo[height>=144]/bestvideo)+(bestaudio[acodec^=opus]/bestaudio)/best" --verbose --force-ipv4 --sleep-requests 1 --sleep-interval 5 --max-sleep-interval 30 --ignore-errors --no-continue --no-overwrites --download-archive archive.log --add-metadata --parse-metadata "%(title)s:%(meta_title)s" --parse-metadata "%(uploader)s:%(meta_artist)s" --write-description --write-info-json --write-annotations --write-thumbnail --embed-thumbnail --all-subs --embed-subs --check-formats --concurrent-fragments 3 --match-filter "!is_live & !live" --output "[YouTube] [%(id)s] %(uploader)s - %(upload_date)s - %(title)s/%(title)s - %(uploader)s - %(upload_date)s [%(id)s].%(ext)s" --merge-output-format "mkv" --datebefore "$(date --date="30 days ago" +%Y%m%d)" --throttled-rate 100K $1 2>&1 | tee output.log

# Grab the most recent folder
output_folder=$(find . -type d -name "*[YouTube]*" | sort -nr | head -1)

# Fetch updated trackerslist from ngosang
trackers=$(wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt | sed '/^$/d' | tr '\n' , | rev | cut -c2- | rev)

# Create the torrent
cd ../torrents
mktorrent -a "$trackers" "../videos/$output_folder"
