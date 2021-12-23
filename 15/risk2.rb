file_data = File.open('input.txt').readlines.map(&:chomp)

rmap = []
path = []
max = 2**32
file_data.each do |l|
  s = l.split('').map!(&:to_i)
  s1 = s.map{|x| x + 1 < 10 ? x + 1 : 1}
  (1..4).each do |i|
    s.concat s1
    s1.map!{|x| x + 1 < 10 ? x + 1 : 1}
  end
  rmap << s
  path << Array.new(5 * s.size, max)
end

n = rmap.size
m = rmap[0].size

(1..4).each do |i|
  (0...n).each do |j|
    rmap << Array.new(m, 0)
    (0...m).each do |k|
      rmap[i*n + j][k] = rmap[j][k] + i < 10 ? rmap[j][k] + i : rmap[j][k] + i - 9
    end

    path << Array.new(m, 2**32)
  end
end

n *= 5
path[0][0] = 0
steps = [[0,0]]
cur_idx = 0
while cur_idx < steps.size do
  x = steps[cur_idx][0]
  y = steps[cur_idx][1]
  
  if x > 0
    r = path[x][y] + rmap[x - 1][y]
    if r < path[x - 1][y]
      path[x - 1][y] = r
      steps << [x - 1, y]
    end
  end
  if x < n - 1
    r = path[x][y] + rmap[x + 1][y] 
    if r < path[x + 1][y]
      path[x + 1][y] = r
      steps << [x+1, y]
    end
  end
  if y > 0
    r = path[x][y] + rmap[x][y - 1] 
    if r < path[x][y - 1]
      path[x][y - 1] = r
      steps << [x, y-1]
    end
  end
  if y < m - 1
    r = path[x][y] + rmap[x][y + 1]
    if r < path[x][y + 1]
      path[x][y + 1] = r
      steps << [x, y+1]
    end
  end
  cur_idx += 1
end

puts path[n-1][m-1]