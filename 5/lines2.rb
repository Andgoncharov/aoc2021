file = File.open('input.txt')

file_data = file.readlines.map(&:chomp)

lines = []
minx = miny = 2**32
maxx = maxy = 0
file_data.each do |l|
  points = l.split '->'
  p1 = points[0].split(',').map!{|c| c.to_i}
  p2 = points[1].split(',').map!{|c| c.to_i}
  
  c_minx = p1[0] < p2[0] ? p1[0] : p2[0]
  c_maxx = p1[0] > p2[0] ? p1[0] : p2[0]
  c_miny = p1[1] < p2[1] ? p1[1] : p2[1]
  c_maxy = p1[1] > p2[1] ? p1[1] : p2[1]

  minx = c_minx if c_minx < minx
  maxx = c_maxx if c_maxx > maxx

  miny = c_miny if c_miny < miny
  maxy = c_maxy if c_maxy > maxy
  lines.push [p1[0], p1[1], p2[0], p2[1]] 
end
pp minx, miny, maxx, maxy

flat = Array.new(maxx + 1)
(minx..maxx).each do |i|
  flat[i] = Array.new(maxy + 1, 0)
end

result = 0
lines.each do |l|
  xinc = 0
  xsteps = l[2] - l[0]
  if xsteps > 0
    xinc = 1
  elsif xsteps < 0
    xinc = -1
    xsteps *= -1
  end
  yinc = 0
  ysteps = l[3] - l[1]
  if ysteps > 0
    yinc = 1
  elsif ysteps < 0
    yinc = -1
    ysteps *= -1
  end

  steps = xsteps > ysteps ? xsteps : ysteps
  x = l[0]
  y = l[1]
  (0..steps).each do |i|
    if flat[x][y] == 1
      result += 1
    end
    flat[x][y] += 1
    x += xinc
    y += yinc
  end
end
puts result
