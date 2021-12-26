$cmap = File.open('input.txt').readlines.map(&:chomp).map{|l| l.split('').map{|c| c == '>' ? 1 : (c == 'v' ? 2 : 0)}}
$m = $cmap.size
$n = $cmap[0].size

def printMap
  num2c = {
    0 => '.',
    1 => '>',
    2 => 'v'
  }
  (0...$m).each do |i|
    puts $cmap[i].map{|c| num2c[c]}.join
  end
  puts ''
end

steps = 0
start_val = Array.new($m, 0)
end_val = Array.new($m, 0)
while true
  (0...$m).each do |i|
    start_val[i] = 0
    (0...$n).each do |j|
      start_val[i] = start_val[i] * 3 + $cmap[i][j]
    end
  end

  (0...$m).each do |i|
    skip = false
    skip_start = false
    (0...$n).each do |j|
      break if (j == $n - 1) && skip_start
      if skip
        skip = false
        next
      end
      if $cmap[i][j] == 1
        dest = j + 1
        dest = 0 if dest >= $n
        if $cmap[i][dest] == 0
          $cmap[i][j] = 0
          $cmap[i][dest] = 1
          skip = true
          skip_start = true if j == 0
        end
      end
    end
  end

  (0...$n).each do |j|
    skip = false
    skip_start = false
    (0...$m).each do |i|
      break if (i == $m - 1) && skip_start
      if skip
        skip = false
        next
      end
      if $cmap[i][j] == 2
        dest = i + 1
        dest = 0 if dest >= $m
        if $cmap[dest][j] == 0
          skip = true
          skip_start = true if i == 0
          $cmap[i][j] = 0
          $cmap[dest][j] = 2
        end
      end
    end
  end

  (0...$m).each do |i|
    end_val[i] = 0
    (0...$n).each do |j|
      end_val[i] = end_val[i] * 3 + $cmap[i][j]
    end
  end

  steps += 1
  if start_val == end_val
    puts steps
    return
  end
end