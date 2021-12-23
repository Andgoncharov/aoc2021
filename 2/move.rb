file = File.read('input.txt').split("\n")
x = 0
y = 0
file.each do |c|
  parts = c.split(' ')
  instr = parts[0]
  value = parts[1].to_i

  case instr
    when 'forward' then x += value
    when 'down' then y += value
    when 'up' then y -= value
  end
end

puts x * y
