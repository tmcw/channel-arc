require 'json'

# the number of videos on one axis
$dimension = 10
$canvas_width = 960
$canvas_height = 540
$video_width = $canvas_width / $dimension
$video_height = $canvas_height / $dimension
$video_count = $dimension ** 2

def tmp_name(i)
  i == 1 ? "base" : "tmp#{i}"
end

def next_tmp_name(i, slice_size)
  n = i + 1
  (slice_size == i) ? '' : "[#{tmp_name(n)}];"
end

def video_name(i)
  "video#{i}"
end

def coord(i)
  base = i - 1
  row = (base / $dimension) * $video_height
  column = (base % $dimension) * $video_width
  [row && ":y=#{row}", column && ":x=#{column}"].compact.join('')
end

# -an: no audio

videos = Dir.glob('videos-with-info/*.mp4').sort

videos.each_slice(100).each_with_index do |files, index|
  puts "Generating slice #{index}…"

  slice_size = files.size

  File.open("output/slice-#{index}.json", 'w') { |file|
    file.write(files.map { |file|
      json_path = file.gsub('.mp4', '.info.json')
      JSON.parse(File.read(json_path)).slice("title", "description", "webpage_url")
    }.to_json)
  }


  inputs = files.map { |file| "-i #{file}" }.join(' ')
  sources = (1..slice_size).map { |i|
    "[#{i - 1}:v] setpts=PTS-STARTPTS, scale=#{$video_width}x#{$video_height}:force_original_aspect_ratio=2 [#{video_name(i)}];"
  }
  positions = (1..slice_size).map { |i|
    "[#{tmp_name(i)}][#{video_name(i)}] overlay=shortest=0#{coord(i)} #{next_tmp_name(i, slice_size)}"
  }
  `ffmpeg #{inputs} -y -an -hide_banner -loglevel warning -filter_complex "
    color=s=#{$canvas_width}x#{$canvas_height}:c=black [base];
    #{sources.join("\n")}
    #{positions.join("\n")}
    " -c:v libx264 -t 20 output/slice-#{index}.mp4`
end
