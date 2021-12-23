players = File.open('input.txt').readlines.map(&:chomp).map{|p| p.split(': ')[1].to_i}

scores = [0, 0]

$outcomes = []
(1..3).each do |i|
  (1..3).each do |j|
    (1..3).each do |k|
      $outcomes << (i + j + k)
    end
  end
end

$cache = {}

def game player1, player2, score1, score2
  key = "#{player1}:#{player2}:#{score1}:#{score2}"
  unless $cache[key].nil?
    return $cache[key]
  end

  wins = [0, 0]
  for out in $outcomes
    p1 = (player1 + out - 1) % 10 + 1
    s1 = score1 + p1
    if s1 >= 21
      wins[0] += 1
    else
      s2, s1 = game player2, p1, score2, s1
      wins[0] += s1
      wins[1] += s2
    end
  end
  $cache[key] = wins
  return wins
end

result = game players[0], players[1], 0, 0
puts result.inspect