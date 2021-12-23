file = File.open('input.txt')
lines = file.readlines.map(&:chomp)

sym2score = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
}

stack = Array.new(20, '')
scores = []
lines.each do |l|
  err = 0
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
            err = 3 and break
          end
        elsif l[i] == ']'
          if stack[cur - 1] == '['
            stack[cur - 1] = ''
            cur -= 1
          else
            err = 57 and break
          end
        elsif l[i] == '}'
          if stack[cur - 1] == '{'
            stack[cur - 1] = ''
            cur -= 1
          else
            err = 1197 and break
          end
        elsif l[i] == '>'
          if stack[cur - 1] == '<'
            stack[cur - 1] = ''
            cur -= 1
          else
            err = 25137 and break
          end
        end
      else
        puts 'CUR is zero'
        break
      end
    end
  end
  if err == 0
    score = 0
    (cur - 1).downto(0).each do |i|
     score = score * 5 + sym2score[stack[i]]
    end
    scores << score
  end
  (0...cur).each{ |i| stack[i] = ''}
end

scores.sort!
puts scores[scores.size / 2]
