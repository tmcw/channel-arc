audios = Dir.glob('audio/*.mp3').sort

audios.each_slice(50).each_with_index do |file, i|
  `sox #{file.join(' ')} audio-medium/out-#{i}.mp3 -m`
end
