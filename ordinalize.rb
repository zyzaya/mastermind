# frozen_string_literal: true

def ordinalize(n)
  return unless n.is_a?(Integer)

  if (11..13).include?(n % 100)
    "#{n}th"
  else
    case n % 10
    when 1 then "#{n}st"
    when 2 then "#{n}nd"
    when 3 then "#{n}rd"
    else "#{n}th"
    end
  end
end
