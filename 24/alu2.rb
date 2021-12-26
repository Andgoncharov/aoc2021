file = File.open('input.txt').readlines.map(&:chomp)

inst = ["x = 0; y = 0; z = 0"]
blocks = []
i = -1
file.each do |ass|
  com = ass.split ' '
  case com[0]
  when 'inp'
    i += 1
    blocks[i] = []
    inst << "w = a[#{i}].to_i"
  when 'mul'
    inst << "#{com[1]} *= #{com[2]}"
  when 'add'
    if com[1] == 'x'
      blocks[i][1] = com[2].to_i if com[2] != 'z'
    elsif com[1] == 'y'
      if com[2] == 'w'
        blocks[i][2] = 0
      elsif blocks[i][2] == 0
        blocks[i][2] = com[2].to_i
      end
    end
    inst << "#{com[1]} += #{com[2]}"
  when 'div'
    blocks[i][0] = com[2].to_i if com[1] == 'z'
    inst << "#{com[1]} /= #{com[2]}"
  when 'mod'
    inst << "#{com[1]} %= #{com[2]}"
  when 'eql'
    inst << "#{com[1]} = #{com[1]} == #{com[2]} ? 1 : 0"
  end
end
inst << "z"

$code = inst.join("\n")
def exec a
  eval $code
end

number = [0] * 14
op_stack = [ [0, blocks[0][2]] ]

(1..13).each_with_index do |idx|
  cur_p = op_stack[-1]
  puts cur_p.inspect
  op_stack.pop if blocks[idx][0] == 26

  # a_(i-1) + c_(i-1) + b_i = a_i
  comp = blocks[idx][1] + cur_p[1]
  if -9 < comp && comp < 9
    if comp >= 0
      number[cur_p[0]] = 1
      number[idx] = 1 + comp
    else
      number[idx] = 1
      number[cur_p[0]] = 1 - comp
    end
  else
    op_stack.push [idx, blocks[idx][2]]
  end
end

res = number.join
if exec(res) == 0
  puts res
else
  puts 'Ooops, that is wrong', res, exec(res)
end

# min = 14911675311114
