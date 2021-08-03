# frozen_string_literal: true

class Mastermind
  attr_reader :code
  
  def initialize(colours, code_length)
    @colours = colours
    @code_length = code_length
    @code = ''
  end

  def generate_code
    @code = ''
    @code_length.times {|i| @code += @colours[rand(@colours.length)]}
  end

  def generate_response(guess)
    response = Array.new(@code_length)
    @code.each_char.with_index do |c, i|
      if c == guess[i]
        response[i] = 'w'
      elsif guess.split('').each_index.select { |j| response[j] != 'w' && guess[j] == c}.length > 0
        response[i] = 'b'
      else
        response[i] = '_'
      end
    end
    white = Array.new(response.count('w'), 'w').join
    black = Array.new(response.count('b'), 'b').join
    "#{white} | #{guess} | #{black}"
  end
end
