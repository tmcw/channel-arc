In lieu of a blog post or something more formal, here's just what it does and how it works.

- input: a YouTube channel
- output: a mosaic of all videos in that channel, in date order, for the first 10 seconds

Steps are:

Download the lowest-quality version of every video using youtube-dl. See `download.sh`.
This doesn't need much explanation.

Mosaic 100 of those videos together in each batch. Doing _all_ the videos doesn't work because
ffmpeg has some limits for open files, which on my computer are around 120, apparently. See
`mosaic.rb` for the logic here. I used Ruby because that's what I'm writing most of the time
right now, but this would be easily ported to any language: it's just making a command
to send to ffmpeg.

Then, mosaic all those videos together, in megamosaic. Very similar to mosaic.rb, but it's
just one column of videos.

---

Notes:

- This doesn't seem to work on phones. Maybe because the video is huge in terms of pixels,
  or it's rather large in terms of filesize (17MB). Maybe there's some ffmpeg option that'd
  make it work, or I should split up the videos and sync them - though that's kind of a rough
  solution, because HTML5 video syncing is very hard to get perfect.
- It's hosted on GitHub Pages because they soft-meter bandwith so far. I hope they don't shut it
  off. They might, and then I'll switch to S3 → CloudFront or Cloudflare to try and host it
  on something 'real' for the lowest possible cost.
- It's be fairly simple to do something like 'hovering over each video and linking to it'.
  I sketched this out but didn't find a solution I liked. TBD.
