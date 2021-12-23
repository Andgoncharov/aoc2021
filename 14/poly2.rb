file = File.open('input.txt')

file_data = file.readlines.map(&:chomp)
proto = file_data[0]

rules = {}
(2...file_data.size).each do |i|
  parts = file_data[i].split(' -> ')
  rules[parts[0]] = parts[1]
end


pair_counts = Hash.new(0)
char_counts = Hash.new(0)
char_counts[proto[0]] = 1
(0...(proto.size - 1)).each do |i|
  pair_counts[proto[i] + proto[i + 1]] += 1
  char_counts[proto[i + 1]] += 1
end

(1..40).each do |step|
  cur_pair_counts = Hash.new(0)
  pair_counts.each {|p, c| cur_pair_counts[p] = c if c > 0}
  cur_pair_counts.each do |p, cnt|
    unless rules[p].nil?
      pair_counts[p] -= cnt
      pair_counts[p[0] + rules[p]] += cnt
      pair_counts[rules[p] + p[1]] += cnt
      char_counts[rules[p]] += cnt
    end
  end
end

puts pair_counts.inspect

min = 2**50
max = 0
char_counts.each do |c, cnt|
  min = cnt if cnt < min
  max = cnt if cnt > max
end

puts min
puts max
puts max - min
