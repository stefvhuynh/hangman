require "./human_player"
require "./computer_player"

class Hangman
    
  def initialize(guesser, chooser, wrong_guesses_limit = 6)
    @guesser = guesser
    @chooser = chooser
    @wrong_guesses_limit = wrong_guesses_limit
    @wrong_guesses = 0
    @wrong_letters = []
    @round_number = 0
    @secret_word_length
    @right_letters
  end
  
  def play
    # @right_letters contains the correct letters in their correct positions.
    # The blank positions are occupied by nils.
    @secret_word_length = @chooser.pick_word_length
    @right_letters = Array.new(@secret_word_length)
    @guesser.receive_word_length(@secret_word_length)

    until game_over?
      @round_number += 1

      display_board
      guessed_letter = @guesser.make_guess(@wrong_letters, @right_letters)
      guess_response = @chooser.respond_to_guess(guessed_letter)
      
      unless guess_response.empty?
        update_right_letters(guessed_letter, guess_response)
      else
        @wrong_guesses += 1
        @wrong_letters << guessed_letter
      end
    end
    
    display_board
    secret_word = @chooser.secret_word
    puts "The word was: #{secret_word}"
    if @right_letters.join == secret_word 
      puts "The guesser wins!"
    else
      puts "The chooser wins!"
    end
  end
  
  private
  
  def game_over?
    @wrong_guesses == 6 || @right_letters.all?
  end
  
  def update_right_letters(guessed_letter, guess_response)
    guess_response.each do |letter_pos| 
      @right_letters[letter_pos] = guessed_letter 
    end
  end
  
  def render_word
    rendered_str = ""
    @right_letters.each { |el| rendered_str += el.nil? ? "_ " : "#{el} " }
    rendered_str.strip    
  end
  
  def display_board
    puts "\nRound: #{@round_number}"
    puts "Incorrect letters: #{@wrong_letters}"
    puts "Incorrect guesses: #{@wrong_guesses}"
    puts render_word
  end
  
end


if __FILE__ == $PROGRAM_NAME  
  human = HumanPlayer.new
  computer = ComputerPlayer.new
  
  if ARGV.empty?
    Hangman.new(human, computer).play
  else    
    args = ARGV.dup
    ARGV.clear
    
    case args
    when ["human", "computer"]
      Hangman.new(human, computer).play
    when ["human", "human"]
      Hangman.new(human, human).play
    when ["computer", "human"]
      Hangman.new(computer, human).play
    when ["computer", "computer"]
      Hangman.new(computer, computer).play
    end
  end
end


