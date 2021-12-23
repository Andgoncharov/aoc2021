file = File.open('input.txt')
lines = file.readlines.map(&:chomp)

result = 0
stack = Array.new(120, '')
lines.each do |l|
  cur = 0
  (0...l.size).each do |i|
    if ['(', '[', '{', '<'].include?(l[i])
      stack[cur] = l[i]
      cur += 1
    else
      if cur > 0
        if l[i] == ')'
          if stack[cur - 1] == '('
            stack[cur - 1] = ''
            cur -= 1
          else
            result += 3 and break
          end
        elsif l[i] == ']'
          if stack[cur - 1] == '['
            stack[cur - 1] = ''
            cur -= 1
          else
            result += 57 and break
          end
        elsif l[i] == '}'
          if stack[cur - 1] == '{'
            stack[cur - 1] = ''
            cur -= 1
          else
            result += 1197 and break
          end
        elsif l[i] == '>'
          if stack[cur - 1] == '<'
            stack[cur - 1] = ''
            cur -= 1
          else
            result += 25137 and break
          end
        end
      else
        break
      end
    end
  end
  (0...cur).each {|i| stack[i] = ''}
end

puts result
