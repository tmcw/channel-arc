require 'json'

# the number of videos on one axis
$video_width = 960
$video_height = 540

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
  ":y=#{(i - 1) * $video_height}"
end

# -an: no audio

files = Dir.glob('output/slice-*.mp4').sort_by { |file|
  file.match(/(\d+)/)[1].to_i
}

inputs = files.map { |file| "-i #{file}" }.join(' ')

slice_size = files.size

sources = (1..slice_size).map { |i|
  "[#{i - 1}:v] setpts=PTS-STARTPTS, scale=#{$video_width}x#{$video_height}:force_original_aspect_ratio=2 [#{video_name(i)}];"
}
positions = (1..slice_size).map { |i|
  "[#{tmp_name(i)}][#{video_name(i)}] overlay=shortest=0#{coord(i)} #{next_tmp_name(i, slice_size)}"
}

$canvas_width = $video_width
$canvas_height = $video_height * slice_size

`ffmpeg #{inputs} -y -an -hide_banner -loglevel warning -filter_complex "
  color=s=#{$canvas_width}x#{$canvas_height}:c=black [base];
  #{sources.join("\n")}
  #{positions.join("\n")}
  " -c:v libx264 -t 10 output-total.mp4`
