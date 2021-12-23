file = File.open('input.txt')

file_data = file.readlines.map(&:chomp)

lines = []
minx = miny = 2**32
maxx = maxy = 0
file_data.each do |l|
  points = l.split '->'
  p1 = points[0].split(',').map!{|c| c.to_i}
  p2 = points[1].split(',').map!{|c| c.to_i}
  
  if p1[0] == p2[0] || p1[1] == p2[1]
    c_minx = p1[0] < p2[0] ? p1[0] : p2[0]
    c_maxx = p1[0] > p2[0] ? p1[0] : p2[0]
    c_miny = p1[1] < p2[1] ? p1[1] : p2[1]
    c_maxy = p1[1] > p2[1] ? p1[1] : p2[1]

    minx = c_minx if c_minx < minx
    maxx = c_maxx if c_maxx > maxx

    miny = c_miny if c_miny < miny
    maxy = c_maxy if c_maxy > maxy
    lines.push [c_minx, c_maxx, c_miny, c_maxy] 
  end
end
pp minx, miny, maxx, maxy

flat = Array.new(maxx + 1)
(minx..maxx).each do |i|
  flat[i] = Array.new(maxy + 1, 0)
end

result = 0
lines.each do |l|
  (l[0]..l[1]).each do |i|
    (l[2]..l[3]).each do |j|
      if flat[i][j] == 1
        result += 1
      end
      flat[i][j] += 1
    end
  end
end
puts result
