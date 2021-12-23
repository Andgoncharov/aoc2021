irequire 'set'
sect = File.read('input.txt').split("\n\n")

scanners = []
sect.each do |s|
  scanners << s.split("\n")[1..-1].map!{|ss| ss.split(',').map!(&:to_i)}
end

acc = Set.new(scanners[0])
slist = scanners[1..-1]

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

$shifts = []
def find_common s1, s2
  for a in s1
    for b in s2
      shift = b.zip(a).map!{|bb, aa| bb - aa}
      norm = s2.map{ |s| s.zip(shift).map!{|ss, sh| ss - sh} }
      if (s1 & norm).size > 11
        $shifts.push shift
        return norm
      end
    end
  end
  nil
end

def dist a, b
  (0..2).inject(0) {|h, i| h += (a[i] - b[i]).abs}
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

max_dist = 0
(0...($shifts.length - 1)).each do |i|
  ((i + 1)...$shifts.length).each do |j|
    d = dist $shifts[i], $shifts[j]
    max_dist = d if d > max_dist
  end
end

puts max_dist