require 'set'

file = File.open('input.txt').readlines.map(&:chomp)
instructions = file.map do |line|
  parts = line.split(',')
  [parts[0].start_with?('on') ? 1 : 0, parts[0].split('=')[1].split('..').map!(&:to_i), parts[1].split('=')[1].split('..').map!(&:to_i), parts[2].split('=')[1].split('..').map!(&:to_i)]
end

instructions.reject! do |inst|
  bad = false
  (1..3).each do |k|
    inst[k][0] = -50 if inst[k][0] < -50
    inst[k][1] = 50 if inst[k][1] > 50
    bad = true and break if inst[k][1] < -50 || inst[k][0] > 50
  end
  bad
end


cube = Set.new
instructions.each do |inst|
  ranges = (1..3).map{|i| Range.new inst[i][0], inst[i][1]}
  ranges[0].each do |i|
    ranges[1].each do |j|
      ranges[2].each do |k|
        if inst[0] == 1
          cube.add "#{i}:#{j}:#{k}"
        else
          cube.delete "#{i}:#{j}:#{k}"
        end
      end
    end
  end
end

puts cube.size
