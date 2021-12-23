file_data = File.open('input.txt').readlines.map(&:chomp)

rmap = []
path = []
max = 2**32
file_data.each do |l|
  s = l.split('').map!(&:to_i)
  rmap << s
  path << Array.new(s.size, max)
end
path[0][0] = 0

n = rmap.size
m = rmap[0].size

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

  # puts steps.inspect
  cur_idx += 1
end

puts path.inspect
puts path[n-1][m-1]