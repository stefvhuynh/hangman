require "human_player"
require "computer_player"

class Hangman
  attr_accessor :input, :output
  
  def initialize(guesser, chooser, wrong_guesses = 6)
    @guesser = guesser
    @chooser = chooser
    @wrong_guesses = wrong_guesses
    @wrong_letters = []
  end
  
  def play
    @secret_word_length = chooser.pick_word_length
    @word_container = Array.new(@secret_word_length)
    
    until game_over?
      display_board
      guessed_letter = guesser.make_guess
      guess_response = chooser.respond_to_guess
      
      unless guess_response.nil?
        update_word_contaner(guess_response)
      else
        @wrong_guesses += 1
        @wrong_letters << guessed_letter
      end
    end
  end
  
  private
  
  def game_over?
    @wrong_guesses == 6 || @word_container.all?
  end
  
  def render_board
    rendered_str = ""
    
    @word_container.each do |el|
      rendered_str += el.nil? ? "_ " : "#{el} "
    end
    
    rendered_str.strip    
  end
  
  def display_board
    puts @wrong_letters
    puts render_board
  end
  
end


