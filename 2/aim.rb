file = File.read('input.txt').split("\n")
x = 0
y = 0
aim = 0
file.each do |c|
  parts = c.split(' ')
  instr = parts[0]
  value = parts[1].to_i

  case instr
    when 'forward'
      x += value
      y += aim * value
    when 'down' then aim += value
    when 'up' then aim -= value
  end
end

puts x * y
