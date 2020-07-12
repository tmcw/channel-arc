audios = Dir.glob('audio-medium/*.mp3').sort

`sox #{audios.join(' ')} audio-all.mp3 -m`
