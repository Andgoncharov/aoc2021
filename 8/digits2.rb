inputs = File.read('input.txt').split("\n")

outputs = []
entries = []
inputs.each do |input|
  bar_pos = input.index('|')
  inp = input[0...bar_pos]
  out = input[(bar_pos+1)..-1]
  inp_entries = inp.split(' ').map!{|e| e.strip.chars.sort.join}

  digit = {235 => [], 690 => []}
  inp_entries.each do |ie|
    if ie.size == 2
      digit[1] = ie
    elsif ie.size == 3
      digit[7] = ie
    elsif ie.size == 4
      digit[4] = ie
    elsif ie.size == 7
      digit[8] = ie
    elsif ie.size == 5
      digit[235].push ie
    else
      digit[690].push ie
    end
  end
  entries.push digit

  out_entries = out.split(' ').map!{|e| e.strip.chars.sort.join}
  outputs.push(out_entries)
end

result = 0
entries.each_with_index do |ent, idx|
  a = (ent[7].chars - ent[1].chars)[0]
  ent[235].each do |e|
    ent[3] = e and break if !e.index(ent[1][0]).nil? && !e.index(ent[1][1]).nil?
  end
  ent[690].each do |e|
    ent[6] = e and break if e.index(ent[1][0]).nil? || e.index(ent[1][1]).nil?
  end
  c = (ent[8].chars - ent[6].chars)[0]
  ent[235].each do |e|
    next if e == ent[3]
    if !e.index(c).nil?
      ent[2] = e
    else
      ent[5] = e
    end
  end
  a4 = ent[4] + a
  ent[690].each do |e|
    next if e == ent[6]
    if (e.chars - a4.chars).size == 1
      ent[9] = e
    else
      ent[0] = e
    end
  end

  str2num = (0..9).each_with_object({}) {|i, h| h[ent[i]] = i}

  num = 0
  outputs[idx].each do |o|
    num = 10 * num + str2num[o]
  end
  result += num
end

puts result