file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)

$cmap = []
file_data.each do |l|
  $cmap << l.split('').map!(&:to_i)
end

$h = $cmap.size
$w = $cmap[0].size

def calcBasinSquare i, j
  sum = 0
  if $cmap[i][j] < 9
    $cmap[i][j] = 9
    sum += 1
    sum += calcBasinSquare(i - 1, j) if i > 0
    sum += calcBasinSquare(i, j - 1) if j > 0
    sum += calcBasinSquare(i + 1, j) if i < ($h - 1)
    sum += calcBasinSquare(i, j + 1) if j < ($w - 1)
  end
  sum
end

max_basins = [0, 0, 0]
result = 0
(0...$h).each do |i|
  (0...$w).each do |j|
    is_regular = (i > 0 && $cmap[i - 1][j] <= $cmap[i][j]) ||
                 (j > 0 && $cmap[i][j - 1] <= $cmap[i][j]) ||
                 (i < ($h - 1) && $cmap[i + 1][j] <= $cmap[i][j]) ||
                 (j < ($w - 1) && $cmap[i][j + 1] <= $cmap[i][j])
    unless is_regular
      sq = calcBasinSquare(i, j)
      if sq > max_basins[0]
        max_basins[0] = sq
        max_basins.sort!
      end
    end
  end
end

puts max_basins.inject(1) {|res, b| res * b}