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
  YES = %w[yes y]
  NO = %w[no n]
  START_INFO = 'Play as codemaker or codebreaker?'.freeze
  START_RETRY = 'Invalid input. Please enter "codemaker" or "codebreaker"'.freeze
  GUESS_RETRY = 'Invalid input. Guess must be four characters' +
    'long and consists of "r", "o", "y", "g", "b", or "i"'
  REPLAY_RETRY = 'Invalid input. Please enter "y" to replay, "n" to quit, or "codemaker" to switch roles'


  def initialize
    @input = Input.new(EXIT_CODE)
    @mastermind = Mastermind.new(COLOURS, CODE_LENGTH)
  end

  def start
    role = @input.get_input(START_INFO, START_RETRY) do |input|
      (MAKER + BREAKER).include?(input)
    end

    if MAKER.include?(role) then play_as_codemaker
    elsif BREAKER.include?(role) then play_as_codebreaker end
  end

  private

  def play_as_codebreaker
    puts 'playing as codebreaker'
    @mastermind.generate_code
    num_guesses = 0
    guess = ''
    until guess == @mastermind.code || num_guesses >= MAX_GUESSES
      puts "Code: #{@mastermind.code}"
      guess_info = "Enter #{ordinalize(num_guesses + 1)} guess:"
      guess = @input.get_input(guess_info, GUESS_RETRY) do |input|
        input.length == CODE_LENGTH && input.each_char.all? do |c|
          COLOURS.include?(c)
        end
      end
      return if EXIT_CODE.include?(guess)

      response = @mastermind.generate_response(guess)
      puts response
      num_guesses += 1
    end
    end_game(guess, num_guesses)
  end

  def play_as_codemaker
    puts 'playing as codemaker'
  end

  def end_game(final_guess, num_guesses)
    if final_guess == @mastermind.code
      info = "Correct! You succeeded in #{num_guesses} guesses"
    else
      info = "You've run out of guesses. The correct code was #{@mastermind.code}"
    end
    info += "\nPlay again? (y/n). Or enter \"codemaker\" to switch roles."
    replay = @input.get_input(info, REPLAY_RETRY) { |input| (YES + NO + MAKER).include?(input) }
    if YES.include?(replay) then play_as_codebreaker
    elsif MAKER.include?(replay) then play_as_codemaker end
  end
end

Game.new.start