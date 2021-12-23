fishes = File.read('input_test.txt').split(',').map!(&:to_i)
(0...256).each do |k|
  cur_size = fishes.size
  (0...cur_size).each do |i|
    if fishes[i] == 0
      fishes.push(8)
      fishes[i] = 6
    else
      fishes[i] -= 1
    end
  end
  puts "Day #{k + 1}: #{fishes.size}"
end
puts fishes.size

