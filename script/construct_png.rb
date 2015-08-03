require 'chunky_png'
require_relative './static_foreground'

SKIP_LEVELS = [
  21
]

block_width = 16

tiles_image = ChunkyPNG::Image.from_file("pfgame.data/images/blocks/large_blocks.png")

tiles = []
[0,1,2,3].each do |x|
  [0,1,2,3].each do |y|
    tile = tiles_image.crop((0 + x) * block_width, (8 + y) * block_width, 16, 16)
    tiles << tile
    #give lower (0,0) a higher probability
    if ([x, y] == [0, 0])
      20.times do
        tiles << tile
      end
    end
  end
end
spikes_up = ChunkyPNG::Image.from_file("pfgame.data/images/spikes.png")
spikes_right = spikes_up.rotate_clockwise
spikes_down = spikes_right.rotate_clockwise
spikes_left = spikes_up.rotate_counter_clockwise

levels = if ARGV[0]
  [Integer(ARGV[0])]
else
  Dir.glob(File.join("pfgame.data", "levels", "level*", "layout.txt")).map do |path|
    Integer(path.match(/level(\d+)\/layout\.txt$/)[1])
  end.reject{|level| SKIP_LEVELS.include?(level)}.sort
end


levels.each do |level_number|
  puts "Contructing static foreground png for level #{level_number}"
  foreground = StaticForeground.from_file("pfgame.data/levels/level#{level_number}/layout.txt")
  output_image = ChunkyPNG::Image.new(block_width * foreground.width, block_width * foreground.height)


  foreground.rows.each_with_index do |row, row_idx|
    row.each_with_index do |element, col_idx|
      next if element.nil?
      offset_x = col_idx * block_width
      offset_y = row_idx * block_width
      if element.block?
        output_image.replace!(tiles.sample, offset_x, offset_y)
      elsif element.hazard_up?
        output_image.replace!(spikes_up, offset_x, offset_y)
      elsif element.hazard_right?
        output_image.replace!(spikes_right, offset_x, offset_y)
      elsif element.hazard_down?
        output_image.replace!(spikes_down, offset_x, offset_y)
      elsif element.hazard_left?
        output_image.replace!(spikes_left, offset_x, offset_y)
      end
    end
  end

  output_path = "pfgame.data/images/levels/level#{level_number}.png"
  output_image.save(output_path)
end


