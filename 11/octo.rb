file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)

$N = 10
$flashCount = 0

$omap = []
file_data.each do |l|
  $omap << l.split('').map!(&:to_i)
end

pp $omap

def rise i, j
  $omap[i][j] += 1
  flash(i, j) if $omap[i][j] == 10
end


def flash i, j
  if i > 0
    rise(i - 1, j)
    rise(i - 1, j - 1) if j > 0
    rise(i - 1, j + 1) if j < $N - 1
  end
  rise(i, j - 1) if j > 0
  rise(i, j + 1) if j < $N - 1

  if i < $N - 1
    rise(i + 1, j)
    rise(i + 1, j - 1) if j > 0
    rise(i + 1, j + 1) if j < $N - 1
  end
  $flashCount += 1
end

100.times do
  (0..9).each do |i|
    (0..9).each do |j|
      $omap[i][j] += 1
      if $omap[i][j] == 10
        flash i, j
      end
    end
  end
  
  (0..9).each do |i|
    (0..9).each do |j|
      $omap[i][j] = 0 if $omap[i][j] > 9
    end
  end
end

puts $flashCount
