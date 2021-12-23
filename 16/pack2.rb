inp = File.open('input.txt').read

hex2bin = {
  '0' => '0000',
  '1' => '0001',
  '2' => '0010',
  '3' => '0011',
  '4' => '0100',
  '5' => '0101',
  '6' => '0110',
  '7' => '0111',
  '8' => '1000',
  '9' => '1001',
  'A' => '1010',
  'B' => '1011',
  'C' => '1100',
  'D' => '1101',
  'E' => '1110',
  'F' => '1111'
}
$bin = inp.chars.map{|c| hex2bin[c]}.join

def bin2dec binstr
  result = 0;
  binstr.chars.each do |c|
    result = 2 * result + c.to_i
  end
  result
end

def calcExpr type, a, b
  case type
  when 0
    a.to_i + b.to_i
  when 1
    b.nil? ? a : a * b
  when 2
    b.nil? ? a : [a, b].min
  when 3
    b.nil? ? a : [a, b].max
  when 5
    a > b ? 1 : 0
  when 6
    a < b ? 1 : 0
  when 7
    a == b ? 1 : 0
  end
end

$ver_sum = 0
def parse_packet p
  ver = bin2dec p[0..2]
  type = bin2dec p[3..5]
  p = p[6..-1]

  if type == 4
    # literal
    num = ''
    while true do
      gtype = p[0]
      num += p[1..4]
      p = p[5..-1]
      break if gtype == '0'
    end
    val = bin2dec(num)
  else
    # operator
    val = []
    if p[0] == '0'
      len = bin2dec p[1..15]
      p = p[16..-1]

      rest = p[0...len]
      p = p[len..-1]
      while rest.size > 0 do
        s_val, rest = parse_packet(rest)
        val << s_val
      end
    else
      cnt = bin2dec p[1..11]
      p = p[12..-1]

      (1..cnt).each do |i|
        s_val, p = parse_packet(p)
        val << s_val
      end
    end

    result = calcExpr type, val[0], val[1]
    (2...val.size).each do |i|
      result = calcExpr type, result, val[i]
    end
    val = result

  end

  $ver_sum += ver
  return val, p
end

puts parse_packet($bin).inspect
puts $ver_sum