# frozen_string_literal: true

class Mastermind
  attr_accessor :code
  
  def initialize(colours, code_length)
    @colours = colours
    @code_length = code_length
    @code = ''
    @last_guess = nil
    @background_digits = 0
  end

  def generate_code
    @code = ''
    @code_length.times {|i| @code += @colours[rand(@colours.length)]}
  end

  def generate_response(guess)
    response = Array.new(@code_length)
    @code.each_char.with_index do |c, i|
      if c == guess[i]
        response[i] = 'b'
      elsif guess.split('').each_index.select { |j| response[j] != 'b' && guess[j] == c}.length > 0
        response[i] = 'w'
      else
        response[i] = '_'
      end
    end
    white = Array.new(response.count('w'), 'w').join
    black = Array.new(response.count('b'), 'b').join
    "#{white} | #{guess} | #{black}"
  end

  def generate_guess(response = nil)
    guess = Array.new(@code_length)
    if response
      @last_guess = @last_guess.split('')
      if response.length == @code_length
        guess = @last_guess.shuffle
      else
        diff = response.length - @background_digits
        guess = @last_guess.take(diff) if diff > 0
        next_colour = @colours.index(@last_guess.last) + 1
        next_colour = @colours[next_colour]
        guess = guess + Array.new(@code_length - guess.length, next_colour)
      end
    else
      @background_digits = 0
      guess = Array.new(@code_length, @colours[0])
    end
    guess = guess.join
    @last_guess = guess
    guess
  end
end
