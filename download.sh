#!/bin/bash
youtube-dl "https://www.youtube.com/c/mkbhd/videos" \
  -o 'videos-with-info/%(upload_date)s-%(id)s.%(ext)s' -i --format=worst  --write-info-json \ # minimize space
