require 'pp'

$imp_line, image = File.read('input.txt').split("\n\n")
pre_image = image.split("\n")
addon = 50 * 2
$m = pre_image.size + addon * 2
$n = pre_image[0].size + addon * 2

$imp_line = $imp_line.chars.map!{|c| c == '#' ? 1 : 0}

image = addon.times.map{|i| Array.new($n, 0)}
pre_image.each do |pi|
  image << ([0] * addon).concat( pi.split('').map!{|p| p == '#' ? 1 : 0}.concat([0] * addon) )
end
image.concat addon.times.map{|i| Array.new($n, 0)}
post_image = Array.new($m) { Array.new($n, $imp_line[0]) }

def calcVal img, i, j, cache = nil
  res = 0
  if cache
    prev = cache
    cache &= 63
    cache = cache << 3
    bot = 0
    (-1..1).each do |y|
      bot = bot * 2 + img[i + 1][j + y]
    end
    res = cache + bot
  else
    (-1..1).each do |x|
      (-1..1).each do |y|
        res = res * 2 + img[i + x][j + y]
      end
    end
  end
  res
end

def process shift, img, post_img
  lit = 0
  upline = Array.new($n, 0)
  (shift...($n - 1)).each do |j|
    upline[j] = calcVal(img, shift, j)
    post_img[shift][j] = $imp_line[ upline[j] ]
    lit += post_img[shift][j]
  end

  ((shift + 1)...($m - 1)).each do |i|
    (shift...($n - 1)).each do |j|
      upline[j] = calcVal(img, i, j, upline[j])
      post_img[i][j] = $imp_line[ upline[j] ]
      lit += post_img[i][j]
    end
  end
  return lit
end

lit = 0
25.times do |i|
  shift = addon - 4*(i + 1) + 2
  process shift, image, post_image
  lit = process shift - 2, post_image, image
end

# pp post_image
# puts ''
# pp image

puts lit