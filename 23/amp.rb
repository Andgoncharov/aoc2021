require 'pp'
require 'set'
file = File.open('input.txt').readlines.map(&:chomp).map!{|l| l.split('')}

hall = [0] * 11
rooms = [[],[],[],[]]
(1..4).each do |j|
  (2..3).each do |i|
    rooms[j - 1] << file[i][2 * j + 1]
  end
end

$order = 'ABCD'
$doors = Set.new([2, 4, 6, 8])
$places = [0, 1, 3, 5, 7, 9, 10]
$amp2room = {'A' => 2, 'B' => 4, 'C' => 6, 'D' => 8}
$energy = {'A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000}

def room_ready? room, i
  room.each do |a|
    return false if a != $order[i]
  end
  return true
end

def game score, hall, rooms
  outcomes = []
  (0..3).each do |i|
    next if rooms[i].empty?
    next if room_ready?(rooms[i], i)
    amp = rooms[i][0]
    en = $energy[amp] * (3 - rooms[i].size)
    pos = (i + 1) * 2

    dests = []
    ((pos + 1)..10).each do |p|
      break if hall[p] != 0
      dests << p unless $doors.include?(p)
    end
    (pos - 1).downto(0).each do |p|
      break if hall[p] != 0
      dests << p unless $doors.include?(p)
    end

    dests.each do |d|
      out = []
      out[0] = score + en + (d - pos).abs * $energy[amp]
      out[1] = hall.dup
      out[1][d] = amp
      out[2] = rooms.map{|r| r.dup}
      out[2][i].shift
      outcomes << out
    end
  end

  $places.each do |p|
    amp = hall[p]
    next if amp == 0
    dest = $amp2room[amp]
    r_idx = dest / 2 - 1
    next unless room_ready?(rooms[r_idx], r_idx)
    way = true
    if dest > p
      ((p + 1)..dest).each do |d|
        way = false and break if hall[d] != 0
      end
    else
      (p - 1).downto(dest).each do |d|
        way = false and break if hall[d] != 0
      end
    end
    if way
      out = []
      out[0] = score + ((dest - p).abs + (2 - rooms[r_idx].size)) * $energy[amp]
      out[1] = hall.dup
      out[1][p] = 0
      out[2] = rooms.map{|r| r.dup}
      out[2][r_idx] << amp
      outcomes << out
    end
  end

  outcomes
end

def add_to q, outcome
  w = calc_weight outcome[0], outcome[1], outcome[2]
  outcome << w
  idx = q.bsearch_index{|v| v[3] >= w}
  # puts outcome.inspect
  if idx.nil?
    q.push outcome
  else
    q.insert idx, outcome
  end
end

def calc_weight score, hall, rooms
  hall_score = 0
  (0..10).each do |i|
    if hall[i] != 0
      hall_score += ($amp2room[hall[i]] - i).abs * $energy[hall[i]]
    end
  end

  room_score = 0
  (0..3).each do |i|
    et = $order[i].ord
    rooms[i].each do |amp|
      dc = (amp.ord - et).abs
      room_score += 2 << 3*dc if dc > 0
    end
  end 

  score + room_score + hall_score
end

def is_final rooms
  (0..3).each do |i|
    (0..1).each do |j|
      return false if rooms[i][j] != $order[i]
    end
  end
  return true
end

gq = [[0, hall, rooms, calc_weight(0, hall, rooms)]]
cache = {}

results = []
while gq.size > 0
  outcomes = game gq[0][0], gq[0][1], gq[0][2]
  for out in outcomes
    key = "#{out[0]}:#{out[1].join}:#{out[2][0].join}:#{out[2][1].join}:#{out[2][2].join}:#{out[2][3].join}"
    next if cache[key]
    cache[key] = true
    if is_final out[2]
      results << out[0]
      if results.size > 25
        puts results.min
        return
      end
    end
    add_to(gq, out)
  end
  gq.shift
end

puts results.min