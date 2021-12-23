file = File.open('input.txt')

file_data = file.readlines.map(&:chomp)
proto = file_data[0]

rules = {}
(2...file_data.size).each do |i|
  parts = file_data[i].split(' -> ')
  rules[parts[0]] = parts[1] + parts[0][1]
end

el_counts = Hash.new(0)
next_proto = [proto[0]]
(1..10).each do |step|
  (0...(proto.size - 1)).each do |i|
    pair = proto[i] + proto[i + 1]
    if rules[pair].nil?
      next_proto.push proto[i + 1]
    else
      next_proto.push rules[pair]
    end
  end
  proto = next_proto.join('')
  next_proto = [proto[0]]
  puts step
end

min = 2**32
max = 0
(0...proto.size).each do |i|
  el_counts[proto[i]] += 1
end
el_counts.each do |el, cnt|
  min = cnt if cnt < min
  max = cnt if cnt > max
end

puts min
puts max
puts max - min
