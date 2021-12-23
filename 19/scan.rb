require 'set'
sect = File.read('input.txt').split("\n\n")

scanners = []
sect.each do |s|
  scanners << s.split("\n")[1..-1].map!{|ss| ss.split(',').map!(&:to_i)}
end

acc = Set.new(scanners[0])
slist = scanners[1..-1]


# rotations
# x
# 1     0       0
# 0 cos(a) -sin(a)
# 0 sin(a)  cos(a)
# x  y z - 0
# x -z  y - 90
# x -y -z - 180


# y
#  cos(a) 0 sin(a)
#     0   1     0
# -sin(a) 0 cos(a)
#  z y -x - 90


#z
# cos(a) -sin(a) 0
# sin(a)  cos(a) 0
#     0       0  1
# -y  x z - 90

def find_rotations points
  pts = points.map{|p| p.dup}
  result = []
  (1..6).each do |i|
    (1..4).each do |j|
      result.append pts
      pts = pts.map{|x, y, z| [z, y, -x]}
    end
    if i < 4
      pts = pts.map{|x, y, z| [-y, x, z]}
    elsif i == 4
      pts = pts.map{|x, y, z| [x, z, -y] }
    elsif i == 5
      pts = pts.map{|x, y, z| [x, -y, -z]}
    end
  end
  # puts result.inspect
  result
end

def find_common s1, s2
  for a in s1
    for b in s2
      shift = (0..2).map{|i| b[i] - a[i]}
      norm = s2.map{ |s| (0..2).map{|i| s[i] - shift[i]} }
      if (s1 & norm).size > 11
        return norm
      end
    end
  end
  nil
end

while slist.length > 0
  cur_points = slist.shift

  rotations = find_rotations cur_points
  for rot in rotations
    norm = find_common(acc, rot)
    break if !norm.nil?
  end

  if !norm.nil?
    acc = acc.merge(norm)
  else
    slist.push(cur_points)
  end
  puts slist.size
end

puts acc.size