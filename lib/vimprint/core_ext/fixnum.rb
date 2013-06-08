class Fixnum
  def ordinalize
    if (11..13).include?(self.to_i % 100)
      "#{self}th"
    else
      case self.to_i % 10
        when 1; "#{self}st"
        when 2; "#{self}nd"
        when 3; "#{self}rd"
        else    "#{self}th"
      end
    end
  end
end
