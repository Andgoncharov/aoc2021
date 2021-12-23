require 'pp'

file = File.read('input.txt').split
res = 0

counts = {val: 0}

def process_num bits, pos, h
  return if pos >= bits.size
  
  cur = bits[pos].to_i
  h[cur] ||= {val: 0}
  h[:val] += 1

  process_num bits, pos + 1, h[cur]
end

file.each do |n|
  process_num n.chars, 0, counts
end

def find_ogr info, ogr
  if info[:val] > 0
    ones = info[1].nil? ? 0 : info[1][:val]
    zers = info[0].nil? ? 0 : info[0][:val]
    if ones >= zers
      ogr = ogr * 2 + 1
      ogr = find_ogr info[1], ogr
    else
      ogr = ogr * 2
      ogr = find_ogr info[0], ogr
    end
  end
  return ogr
end

def find_csr info, csr
  if info[:val] > 0
    ones = info[1].nil? ? 10000 : info[1][:val]
    zers = info[0].nil? ? 10000 : info[0][:val]
    if zers <= ones
      csr = csr * 2
      csr = find_csr info[0], csr
    else
      csr = csr * 2 + 1
      csr = find_csr info[1], csr
    end
  end
  return csr
end

ogr = find_ogr counts, 0
csr = find_csr counts, 0

puts ogr
puts csr
puts ogr*csr
