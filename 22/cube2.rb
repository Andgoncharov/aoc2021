require 'set'

file = File.open('input.txt').readlines.map(&:chomp)
instructions = file.map do |line|
  parts = line.split(',')
  [parts[0].start_with?('on') ? 1 : 0, parts[0].split('=')[1].split('..').map!(&:to_i), parts[1].split('=')[1].split('..').map!(&:to_i), parts[2].split('=')[1].split('..').map!(&:to_i)]
end

axes = [Set.new, Set.new, Set.new]
instructions.each do |inst|
  (1..3).each do |i|
    axes[i - 1].add( inst[i][0] ).add( inst[i][1] + 1 )
  end
end
axes.map!{|a| a.sort}
axis2idx = [{}, {}, {}]
(0..2).each do |i|
  axes[i].each_with_index do |v, idx|
    axis2idx[i][v] = idx
  end
end

ivals = Array.new(axes[0].size - 1) { Array.new(axes[1].size - 1) { Array.new(axes[2].size - 1, 0) } }
instructions.each do |inst|
  ival_indexes = []
  puts inst.inspect
  (0..2).each do |i|
    ival_indexes[i] = Range.new(axis2idx[i][ inst[i + 1][0] ], axis2idx[i][ inst[i + 1][1] + 1 ] - 1)
  end
  ival_indexes[0].each do |i|
    ival_indexes[1].each do |j|
      ival_indexes[2].each do |k|
        ivals[i][j][k] = inst[0]
      end
    end
  end
end

result = 0
(0..(axes[0].size - 2)).each do |i|
  r0 = axes[0][i + 1] - axes[0][i]
  (0..(axes[1].size - 2)).each do |j|
    r1 = axes[1][j + 1] - axes[1][j]
    (0..(axes[2].size - 2)).each do |k|
      if ivals[i][j][k] > 0
        result += r0 * r1 * (axes[2][k + 1] - axes[2][k])
      end
    end
  end
  puts i
end

puts result
