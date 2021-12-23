crabs = File.read('input.txt').split(',').map!(&:to_i).sort
$pos_counts = Hash.new(0)
crabs.each do |c|
  $pos_counts[c] += 1
end

def calcPosition pos
  total = 0
  $pos_counts.each do |p, c|
    total += c * (pos - p).abs
  end
  total
end

result = 2**32
(0...crabs.size).each do |i|
  res = calcPosition(i)
  result = res if res < result
end
puts result

