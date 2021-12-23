file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)

phase = 0
$maxx = $maxy = 0
instructions = []
file_data.each do |line|
  phase = 1 and next if line.empty?

  if 0 == phase
    point = line.split(',').map!(&:to_i)
    $maxx = point[0] if point[0] > $maxx
    $maxy = point[1] if point[1] > $maxy
  else
    eqPos = line.index('=')
    instructions << [line[(eqPos - 1)...eqPos], line[(eqPos + 1)..-1]]
  end
end

def foldX arr, x
  xsize = arr.size
  ysize = arr[0].size
  right = xsize - x - 1
  diff = right - x

  result = Array.new([x, right].max){Array.new(ysize, 0)}
  if diff <= 0
    board = xsize - diff - 1
    (0...x).each do |i|
      (0...ysize).each do |j|
        result[i][j] = (board - i < xsize) ? arr[i][j] | arr[board - i][j] : arr[i][j]
      end
    end
  else
    board = -diff
    (0...x).each do |i|
      (0...ysize).each do |j|
        result[i][j] = (board + i >= 0) ? arr[board + i][j] | arr[xsize - i - 1][j] : arr[xsize - i - 1][j]
      end
    end
  end
  printFold result
  result
end

def foldY arr, y
  xsize = arr.size
  ysize = arr[0].size
  bottom = ysize - y - 1
  diff = bottom - y

  result = Array.new(xsize){Array.new([y, bottom].max, 0)}
  if diff <= 0
    board = ysize - diff - 1
    (0...xsize).each do |i|
      (0...y).each do |j|
        result[i][j] = (board - j < ysize) ? arr[i][j] | arr[i][board - j] : arr[i][j]
      end
    end
  else
    board = -diff
    (0...xsize).each do |i|
      (0...y).each do |j|
        result[i][j] = (board + j >= 0) ? arr[i][board + j] | arr[i][ysize - j - 1] : arr[i][ysize - j - 1]
      end
    end
  end
  printFold result
  result
end

def printFold arr
  (0...arr[0].size).each do |j|
    (0...arr.size).each do |i|
      if arr[i][j] == 1
        print '#'
      else
        print '.'
      end
    end
    print "\n"
  end
end

$man = Array.new($maxx + 1) {Array.new($maxy + 1, 0)}
num_points = 0
file_data.each do |line|
  break if line.empty?
  point = line.split(',').map!(&:to_i)
  $man[point[0]][point[1]] = 1
  num_points += 1
end

arr = $man
instructions.each do |instr|
  arr = instr[0] == 'x' ? foldX(arr, instr[1].to_i) : foldY(arr, instr[1].to_i)
end

puts num_points
puts $maxx
puts $maxy

printFold arr