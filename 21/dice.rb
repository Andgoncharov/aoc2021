players = File.open('input.txt').readlines.map(&:chomp).map{|p| p.split(': ')[1].to_i}

scores = [0, 0]
rolls = 0
cur_num = 1
while true
  cur_num += 1
  players[0] = (players[0] + cur_num * 3 - 1) % 10 + 1
  scores[0] += players[0]
  cur_num += 2
  break if scores[0] >= 1000

  cur_num += 1
  players[1] = (players[1] + cur_num * 3 - 1) % 10 + 1
  scores[1] += players[1]
  cur_num += 2
  break if scores[1] >= 1000
end


puts scores.min*(cur_num - 1)
