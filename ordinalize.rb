def ordinalize(n)
  return unless n.is_a?(Integer)

  if (11..13).include?(n % 100)
    "#{n}th"
  else
    case n % 10
      when 1; "#{n}st"
      when 2; "#{n}nd"
      when 3; "#{n}rd"
      else    "#{n}th"
    end
  end
end