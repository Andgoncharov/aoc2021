inputs = File.read('input.txt').split("\n")

digits = []
inputs.each do |input|
  bar_pos = input.index('|')
  out = input[(bar_pos+1)..-1]
  out_digits = out.split(' ').map!(&:strip)
  digits.push(*out_digits)
end

result = 0
digits.each do |d|
  result += 1 if d.size == 2 || d.size == 3 || d.size == 4 || d.size == 7
end
puts result
