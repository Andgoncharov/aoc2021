file = File.read('input.txt').split
res = 0

counts = Array.new(12, 0)
file.each do |n|
  n.chars.each_with_index do |b, idx|
    counts[idx] += 1 if b.to_i == 1
  end
end

gamma = 0
epsilon = 0

thresh = file.size / 2
counts.each do |c|
  if c > thresh
    gamma = gamma * 2 + 1
    epsilon *= 2
  else
    epsilon = epsilon * 2 + 1
    gamma *= 2
  end
end

puts gamma * epsilon
puts counts.inspect
