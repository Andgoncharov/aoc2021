require 'set'

file = File.read('input.txt')

xpos = file.index('x=') + 2
file = file[xpos..-1]
xint = file[0...file.index(',')]
x1, x2 = xint.split('..').map!(&:to_i)
x1, x2 = x2, x1 if x2 < x1

ypos = file.index('y=') + 2
file = file[ypos..-1]
yint = file[0..-1]
y1, y2 = yint.split('..').map!(&:to_i)
y1, y2 = y2, y1 if y2 < y1

def vely vy, n
  r = n - vy
  if r <= 0
    vely1 vy, n
  else
    vely1(vy, vy) - vely2(r)
  end
end

def vely1 vy, n
  vy*n - n*(n - 1)/2
end

def vely2 n
  (n - 1) * n / 2
end

def velx vx, n
  (n <= vx) ? vx*n - n*(n - 1)/2 : vx*(vx + 1) / 2
end

cur_vy = -y1 * 2

result = 0
while true do
  allowed_n = []
  n = 1
  y = 0
  while y >= y1 do
    y = vely cur_vy, n
    if y1 <= y && y <= y2
      allowed_n << n
    end
    n += 1
  end

  fits = []
  allowed_n.each do |nn|
    (0..x2).each do |vx|
      x = velx vx, nn
      if x1 <= x && x <= x2
        fits << vx
      end
    end
  end
  result += fits.uniq.size

  cur_vy -= 1
  break if cur_vy < y1
end

puts result