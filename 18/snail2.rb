lines = File.open('input.txt').readlines.map(&:chomp)

class SnailNum
  attr_accessor :left
  attr_accessor :right
  attr_accessor :parent
  attr_accessor :is_left

  def initialize parent, left, right, is_left=false
    @parent = parent
    @left = left
    @right = right
    @is_left = is_left unless @parent.nil?
  end

  def printout
    str = '['
    if @left.is_a?(Integer)
      str += @left.to_s
    else
      str += @left.printout
    end
    str += ','
    if @right.is_a?(Integer)
      str += @right.to_s
    else
      str += @right.printout
    end
    str += ']'
    str
  end

  def copy parent = nil
    res = SnailNum.new(parent, nil, nil, @is_left)
    res.left = @left.is_a?(Integer) ? @left : @left.copy(res)
    res.right = @right.is_a?(Integer) ? @right : @right.copy(res)
    res
  end

  def add num
    sum = SnailNum.new(nil, self, num)
    self.parent = sum
    self.is_left = true
    num.parent = sum
    sum
  end

  def propagate_left
    is_l = @is_left
    par = @parent
    while par
      if !is_l
        pl = par.left
        if pl.is_a?(Integer)
          par.left += @left
          return
        else
          while !pl.is_a?(Integer)
            if pl.right.is_a?(Integer)
              pl.right += @left
              return
            else
              pl = pl.right
            end
          end
        end
      end
      is_l = par.is_left
      par = par.parent
    end
  end

  def propagate_right
    is_l = @is_left
    par = @parent
    while par
      if is_l
        pr = par.right
        if pr.is_a?(Integer)
          par.right += @right
          return
        else
          while !pr.is_a?(Integer)
            if pr.left.is_a?(Integer)
              pr.left += @right
              return
            else
              pr = pr.left
            end
          end
        end
      end
      is_l = par.is_left
      par = par.parent
    end
  end

  def reduce_num cur_level = 0
    if @left.is_a?(Integer) && @right.is_a?(Integer)
      if cur_level >= 4
        propagate_left
        propagate_right
        if @is_left
          @parent.left = 0
        else
          @parent.right = 0
        end
        return true
      end
      return false
    else
      if !@left.is_a?(Integer)
        return true if @left.reduce_num(cur_level + 1)
      end
      if !@right.is_a?(Integer)
        return true if @right.reduce_num(cur_level + 1)
      end
      return false
    end
  end

  def split_num
    if @left.is_a?(Integer)
      if @left > 9
        half = (@left / 2.0).floor
        @left = SnailNum.new(self, half, @left - half, true)
        return true
      end
    else
      return true if @left.split_num
    end

    if @right.is_a?(Integer)
      if @right > 9
        half = (@right / 2.0).floor
        @right = SnailNum.new(self, half, @right - half)
        return true
      end
    else
      return true if @right.split_num
    end
    return false
  end

  def magnitude 
    res = 0
    lmag = @left.is_a?(Integer) ? @left : @left.magnitude
    res += 3 * lmag

    rmag = @right.is_a?(Integer) ? @right : @right.magnitude
    res += 2 * rmag
    res
  end
end

def parse_num str, idx, num
  if str[idx] == '['
    idx += 1
    if str[idx] == '['
      ch = SnailNum.new(num, nil, nil, true)
      idx = parse_num str, idx, ch
    else
      col_pos = str.index(',', idx)
      ch = str[idx...col_pos].to_i
      idx = col_pos - 1
    end
    num.left = ch

    idx += 2
    if str[idx] == '['
      ch = SnailNum.new(num, nil, nil)
      idx = parse_num str, idx, ch
    else
      close_pos = str.index(']', idx)
      ch = str[idx...close_pos].to_i
      idx = close_pos - 1
    end
    num.right = ch
    return idx + 1
  else
    puts 'error, unexpected symbol ' + str[idx]
  end
end

nums = Array.new(lines.size) {SnailNum.new(nil, nil, nil)}
lines.each_with_index do |l, i|
  parse_num l, 0, nums[i]
end

sums = []
(0...nums.size).each do |i|
  (0...nums.size).each do |j|
    next if i == j
    a = nums[i].copy
    b = nums[j].copy
    sum = a.add b
    reduce_result = true
    while reduce_result
      reduce_result = sum.reduce_num
    end

    while true
      split_res = sum.split_num
      reduce_res = sum.reduce_num
      break if !split_res && !reduce_res
      while reduce_result
        reduce_result = sum.reduce_num
      end
    end
    sums << sum.magnitude
  end
end

puts sums.sort!.inspect