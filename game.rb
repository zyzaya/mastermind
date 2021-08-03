# frozen_string_literal: true
require_relative 'input'
require_relative 'mastermind.rb'

class Game
  COLOURS = %w[r o y g b i].freeze
  EXIT_CODE = %w[e exit].freeze
  MAKER = %w[codemaker maker m].freeze
  BREAKER = %w[codebreaker breaker b].freeze
  START_INFO = 'Play as codemaker or codebreaker?'.freeze
  START_RETRY = 'Invalid input. Please enter "codemaker" or "codebreaker"'.freeze
  GUESS_RETRY = 'Invalid input. Guess must be four characters' +
    'long and consists of "r", "o", "y", "g", "b", or "i"'
  MAX_GUESSES = 12


  def initialize
    @input = Input.new(EXIT_CODE)
    @mastermind = Mastermind.new
  end

  def start
    # start game
    # get codemaker/codebreaker
    
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
    # @mastermind.generate_code
    correct = false
    num_guesses = 0
    until correct || num_guesses >= MAX_GUESSES
      guess_info = "Enter #{num_guesses + 1} guess."
      guess = @input.get_input(GUESS_INFO, GUESS_RETRY) do |input|
        input.length == 4 && input.each_char.all? {|c| COLOURS.include?(c)}
      end
      response = @mastermind.generate_respone(guess)
    end
    puts guess
  end

  def play_as_codemaker
    puts 'playing as codemaker'
  end
end

Game.new.start