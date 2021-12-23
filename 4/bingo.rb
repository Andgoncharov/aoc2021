require 'pp'
require 'set'

file = File.open('input.txt')

file_data = file.readlines.map(&:chomp)

nums = file_data[0].split(',').map!{|n| n.to_i}
cur_set = Set.new()

boards = []
b = Array.new(6) { Array.new(6, 0) }
rowi = 0
(2...file_data.size).each do |i|
  if file_data[i].empty?
    rowi = 0
    boards << b
    b = Array.new(6) { Array.new(6, 0) }
  else
    row = file_data[i].split.map!{|n| n.to_i}
    (0...row.size).each do |j|
      b[rowi][j] = row[j]
    end
    rowi += 1
  end
end
boards << b

puts nums.inspect

def calculateScore (board, marks, num)
  sum = 0
  (0...5).each do |i|
    (0...5).each do |j|
      if !marks.include?(board[i][j])
        sum += board[i][j]
        puts "Not included #{board[i][j]}"
      end
    end
  end
  puts sum * num
end

nums.each do |n|
  cur_set << n
  boards.each do |b|
    (0...5).each do |i|
      (0...5).each do |j|
        if b[i][j] == n
          b[i][5] += 1
          b[5][j] += 1
          if b[i][5] == 5 || b[5][j] == 5
            calculateScore(b, cur_set, n)
            return
          end
        end
      end
    end
  end
end
