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
    @word_container
  end
  
  def play
    @secret_word_length = @chooser.pick_word_length
    @word_container = Array.new(@secret_word_length)

    until game_over?
      @round_number += 1
      
      # Raises a custom error when the guesser guesses a letter that has 
      # already been guessed and retries.
      begin
        display_board
        guessed_letter = @guesser.make_guess
        raise GuessError if @wrong_letters.include?(guessed_letter) || 
                            @word_container.include?(guessed_letter)
      rescue GuessError
        puts "Already guessed that letter!"
        retry
      end
      
      guess_response = @chooser.respond_to_guess(guessed_letter)
      unless guess_response.empty?
        update_word_container(guessed_letter, guess_response)
      else
        @wrong_guesses += 1
        @wrong_letters << guessed_letter
      end
    end
    
    display_board
    puts @wrong_guesses == 6 ? "The chooser wins!\n\n" : "The guesser wins!\n\n"
  end
  
  private
  
  def game_over?
    @wrong_guesses == 6 || @word_container.all?
  end
  
  def update_word_container(guessed_letter, guess_response)
    guess_response.each do |letter_pos| 
      @word_container[letter_pos] = guessed_letter 
    end
  end
  
  def render_word
    rendered_str = ""
    @word_container.each { |el| rendered_str += el.nil? ? "_ " : "#{el} " }
    rendered_str.strip    
  end
  
  def display_board
    puts "\nRound: #{@round_number}"
    puts "Incorrect letters: #{@wrong_letters}"
    puts "Incorrect guesses: #{@wrong_guesses}"
    puts render_word
  end
  
end

class GuessError < StandardError
  def initialize(msg = "GuessError: letter has already been guessed")
    super
  end
end


if __FILE__ == $PROGRAM_NAME
  human = HumanPlayer.new
  computer = ComputerPlayer.new
  
  if ARGV.empty?
    Hangman.new(human, computer).play
  else    
    case ARGV
    when ["human", "computer"]
      Hangman.new(human, cpu).play
    when ["human", "human"]
      Hangman.new(human, human).play
    when ["computer", "human"]
      Hangman.new(computer, human).play
    when ["computer", "computer"]
      Hangman.new(computer, computer).play
    end
  end
end


