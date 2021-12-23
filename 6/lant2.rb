fishes = File.read('input.txt').split(',').map!(&:to_i)
total = fishes.size
counts = Array.new(10, 0)
fishes.each do |f|
  counts[f] += 1
end
(0...256).each do |k|
  counts[9] = counts[0]
  (1..8).each do |i|
    counts[i-1] = counts[i]
  end
  counts[6] += counts[9]
  counts[8] = counts[9]
  total += counts[9]
  puts "Day #{k + 1}: #{total}"
end
puts total
