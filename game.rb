# frozen_string_literal: true

require_relative 'input'
require_relative 'mastermind'
require_relative 'ordinalize'

class Game
  COLOURS = %w[r o y g b i].freeze
  MAX_GUESSES = 12
  CODE_LENGTH = 4
  WHITE_PEG = 'w'
  BLACK_PEG = 'b'

  EXIT_CODE = %w[e exit].freeze
  MAKER = %w[codemaker maker m].freeze
  BREAKER = %w[codebreaker breaker b].freeze
  YES = %w[yes y].freeze
  NO = %w[no n].freeze
  START_INFO = 'Play as codemaker or codebreaker?'
  START_RETRY = 'Invalid input. Please enter "codemaker" or "codebreaker"'
  GUESS_RETRY = 'Invalid input. Guess must be four characters'\
    ' long and consists of "r", "o", "y", "g", "b", or "i"'
  REPLAY_RETRY = 'Invalid input. Please enter "y" to replay, "n" to quit, or "codemaker" to switch roles'
  CODE_INFO = 'Enter code with a length of four and consisting of the characters roygbi'
  CODE_RETRY = 'Invalid input. Code must be four characters'\
    ' long and consist of  "r", "o", "y", "g", "b", or "i"'
  FEEDBACK_RETRY = 'Invalid input. Feedback must be four characters or less'\
    ' consisting of only "w" or "b"'

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
    @mastermind.generate_code
    num_guesses = 0
    guess = ''
    until guess == @mastermind.code || num_guesses >= MAX_GUESSES
      # puts "Code: #{@mastermind.code}"
      guess_info = "Enter #{ordinalize(num_guesses + 1)} guess (four of the characters r, o, y, g, b, or i):"
      guess = @input.get_input(guess_info, GUESS_RETRY) do |input|
        valid_code?(input)
      end
      return if EXIT_CODE.include?(guess)

      response = @mastermind.generate_response(guess)
      puts response
      num_guesses += 1
    end
    end_game_as_code_breaker(guess, num_guesses)
  end

  def play_as_codemaker
    code = @input.get_input(CODE_INFO, CODE_RETRY) do |input|
      valid_code?(input)
    end
    return if EXIT_CODE.include?(code)

    @mastermind.code = code
    guess = ''
    num_guesses = 0
    feedback = nil
    until guess == @mastermind.code || num_guesses >= MAX_GUESSES
      feedback_info = "Computer's #{ordinalize(num_guesses + 1)} guess is "\
         "#{@mastermind.generate_guess(feedback)}. "\
         'Enter feedback:'
      feedback = @input.get_input(feedback_info, FEEDBACK_RETRY) do |input|
        valid_feedback?(input)
      end
      return if EXIT_CODE.include?(feedback)
      
      num_guesses += 1
    end
    end_game_as_code_maker(guess, num_guesses)
  end

  def valid_code?(code)
    all_valid_chars = code.each_char.all? { |c| COLOURS.include?(c) }
    code.length == CODE_LENGTH && all_valid_chars
  end

  def valid_feedback?(input)
    all_valid_chars = input.each_char.all? do |c|
      [WHITE_PEG, BLACK_PEG].include?(c)
    end
    input.length <= CODE_LENGTH && all_valid_chars
  end

  def end_game_as_code_breaker(final_guess, num_guesses)
    info =
      if final_guess == @mastermind.code
        "Correct! You succeeded in #{num_guesses} guesses"
      else
        "You've run out of guesses. The correct code was #{@mastermind.code}"
      end
    info += "\nPlay again? (y/n). Or enter \"codemaker\" to switch roles."
    replay = @input.get_input(info, REPLAY_RETRY) { |input| (YES + NO + MAKER).include?(input) }
    if YES.include?(replay) then play_as_codebreaker
    elsif MAKER.include?(replay) then play_as_codemaker end
  end

  def end_game_as_code_maker(final_guess, num_guesses)
    info =
      if final_guess == @mastermind.code
        "Computer succeed in #{num_guesses} guesses."
      else
        'You win! The computer has failed to guess your code!'
      end
    info += "\nPlay again? (y/n). Or enter \"codebreaker\" to switch roles."
    replay = @input.get_input(info, REPLAY_RETRY) { |input| (YES + NO + BREAKER).include?(input) }
    if YES.include?(replay) then play_as_codebreaker
    elsif MAKER.include?(replay) then play_as_codemaker end
  end
end

Game.new.start
