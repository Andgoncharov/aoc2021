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

def foldX x
  result = 0
  right = $maxx - x
  diff = right - x
  if diff <= 0
    board = $maxx - diff
    (0...x).each do |i|
      (0..$maxy).each do |j|
        result += (board - i <= $maxx) ? $man[i][j] | $man[board - i][j] : $man[i][j]
      end
    end
  else
    board = -diff
    (0...x).each do |i|
      (0..$maxy).each do |j|
        result += (board + i >= 0) ? $man[board + i][j] | $man[$maxx - i][j] : $man[$maxx - i][j]
      end
    end
  end
  puts result
end

def foldY y
  result = 0
  bottom = $maxy - y
  diff = bottom - y
  if diff <= 0
    board = $maxy - diff
    (0..$maxx).each do |i|
      (0...y).each do |j|
        result += (board - j <= $maxy) ? $man[i][j] | $man[i][board - j] : $man[i][j]
      end
    end
  else
    board = -diff
    (0..$maxx).each do |i|
      (0...y).each do |j|
        result += (board + j >= 0) ? $man[i][board + j] | $man[i][$maxy - j] : $man[i][$maxy - j]
      end
    end
  end
  puts result
end

$man = Array.new($maxx + 1) {Array.new($maxy + 1, 0)}
num_points = 0
file_data.each do |line|
  break if line.empty?
  point = line.split(',').map!(&:to_i)
  $man[point[0]][point[1]] = 1
  num_points += 1
end

instructions.each do |instr|
  instr[0] == 'x' ? foldX(instr[1].to_i) : foldY(instr[1].to_i)
end

puts num_points
puts $maxx
puts $maxy