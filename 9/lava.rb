file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)

cmap = []
file_data.each do |l|
  cmap << l.split('').map!(&:to_i)
end

h = cmap.size
w = cmap[0].size

result = 0
(0...h).each do |i|
  (0...w).each do |j|
    is_regular = (i > 0 && cmap[i - 1][j] <= cmap[i][j]) ||
                 (j > 0 && cmap[i][j - 1] <= cmap[i][j]) ||
                 (i < (h - 1) && cmap[i + 1][j] <= cmap[i][j]) ||
                 (j < (w - 1) && cmap[i][j + 1] <= cmap[i][j])
    result += (cmap[i][j] + 1) unless is_regular
  end
end

puts result
puts cmap.inspect