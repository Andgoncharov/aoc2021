require 'set'
file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)

cave_connections = Array.new(16){Array.new(16, 0)};
cave_indexes = {'end' => 0}
is_big = Array.new(16, false)
num_caves = 1

file_data.each do |path|
  caves = path.split('-')
  2.times do |i|
    if caves[i] != 'end' && cave_indexes[caves[i]].nil?
      cave_indexes[caves[i]] = num_caves
      is_big[num_caves] = true if caves[i][0].upcase == caves[i][0]
      num_caves += 1
    end
  end
  cave_connections[cave_indexes[caves[0]]][cave_indexes[caves[1]]] = 1
  cave_connections[cave_indexes[caves[1]]][cave_indexes[caves[0]]] = 1
end

start_idx = cave_indexes['start']

Cave = Struct.new(:id, :slist, :fav)
track = [Cave.new(0, Set.new([0]))]
cur_step = 0
tracks_num = 0
while cur_step < track.length do
  cur_cave = track[cur_step]
  if cur_cave.id == start_idx
    tracks_num += 1
  else
    (0...num_caves).each do |i|
      if cave_connections[cur_cave.id][i] == 1 && (is_big[i] || !cur_cave.slist.include?(i) || (cur_cave.fav.nil? && i != 0))
        next_cave = Cave.new(i, cur_cave.slist, cur_cave.fav)
        unless is_big[i]
          if cur_cave.slist.include?(i)
            next_cave.fav = i
          else
            next_cave.slist = cur_cave.slist.dup
            next_cave.slist << i
          end
        end
        track << next_cave
      end
    end
    cur_cave.slist = nil
  end
  cur_step += 1
end

puts tracks_num
