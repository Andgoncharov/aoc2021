file = File.read('input.txt').split
res = 0
windows = [file[0].to_i + file[1].to_i + file[2].to_i, file[1].to_i + file[2].to_i, file[2].to_i]
prev_window = 0
cur_window = 1

(3...file.size).each do |i|
  cur = file[i].to_i
  prev_idx = i % 3;
  prev = windows[prev_idx]
  windows[prev_idx] = 0;
  (0..2).each {|j| windows[j] += cur}
  
  cur_idx = (i + 1) % 3
  if windows[cur_idx] - prev > 0
    res += 1
  end

end
puts res
