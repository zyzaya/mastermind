# frozen_string_literal: true
require_relative 'input'
require_relative 'mastermind'
require_relative 'ordinalize'

class Game
  COLOURS = %w[r o y g b i].freeze
  MAX_GUESSES = 12
  CODE_LENGTH = 4
  
  EXIT_CODE = %w[e exit].freeze
  MAKER = %w[codemaker maker m].freeze
  BREAKER = %w[codebreaker breaker b].freeze
  START_INFO = 'Play as codemaker or codebreaker?'.freeze
  START_RETRY = 'Invalid input. Please enter "codemaker" or "codebreaker"'.freeze
  GUESS_RETRY = 'Invalid input. Guess must be four characters' +
    'long and consists of "r", "o", "y", "g", "b", or "i"'
  


  def initialize
    @input = Input.new(EXIT_CODE)
    @mastermind = Mastermind.new(COLOURS, CODE_LENGTH)
  end

  def start
    role = @input.get_input(START_INFO, START_RETRY) do |input|
      (MAKER + BREAKER).include?(input)
    end
    return if EXIT_CODE.include?(role)

    if MAKER.include?(role) then play_as_codemaker
    elsif BREAKER.include?(role) then play_as_codebreaker end
  end

  private

  def play_as_codebreaker
    puts 'playing as codebreaker'
    @mastermind.generate_code
    puts @mastermind.code
    correct = false
    num_guesses = 0
    until correct || num_guesses >= MAX_GUESSES
      guess_info = "Enter #{ordinalize(num_guesses + 1)} guess."
      guess = @input.get_input(guess_info, GUESS_RETRY) do |input|
        input.length == CODE_LENGTH && input.each_char.all? do |c|
          COLOURS.include?(c)
        end
      end
      response = @mastermind.generate_response(guess)
      puts "Code: #{@mastermind.code}"
      puts response
    end
    puts guess
  end

  def play_as_codemaker
    puts 'playing as codemaker'
  end
end

Game.new.start