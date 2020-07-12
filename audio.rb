videos = Dir.glob('videos-with-info/*.mp4').sort

videos.each_with_index do |file, i|
  `ffmpeg -i #{file} -q:a 0 -t 20 -map a audio/audio-#{i}.mp3`
end
