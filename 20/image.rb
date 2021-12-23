require 'pp'

$imp_line, image = File.read('input_test.txt').split("\n\n")
pre_image = image.split("\n")
$m = pre_image.size + 8
$n = pre_image[0].size + 8

puts $imp_line.size

image = 4.times.map{|i| Array.new($n, '.')}
pre_image.each do |pi|
  image << ['.', '.', '.', '.'].concat( pi.split('').concat(['.', '.', '.', '.']) )
end
image.concat 4.times.map{|i| Array.new($n, '.')}
post_image = Array.new($m) { Array.new($n, $imp_line[0]) }

pp image
puts ''

def calcVal img, i, j
  res = 0
  (-1..1).each do |x|
    (-1..1).each do |y|
      res = res * 2 + (img[i + x][j + y] == '#' ? 1 : 0)
    end
  end
  res
end

def process shift, img, post_img
  lit = 0
  (shift...($m - 1)).each do |i|
    (shift...($n - 1)).each do |j|
      pix = $imp_line[ calcVal(img, i, j) ]
      lit += 1 if pix == '#'
      post_img[i][j] = pix
    end
  end
  return lit
end

process 2, image, post_image
lit = process 0, post_image, image
pp post_image
puts ''
pp image
puts lit