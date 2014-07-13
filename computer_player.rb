class ComputerPlayer
  attr_reader :secret_word
  
  def self.read_dictionary
    # File.dirname(__FILE__) grabs the current directory of this file and 
    # prepends it to the dictionary's file name.
    File.readlines(File.dirname(__FILE__) + "/dictionary.txt").map(&:chomp)
  end
  
  def initialize(dictionary = self.class.read_dictionary)
    @dictionary = dictionary
    @secret_word
  end
  
  def pick_word_length    
    @secret_word = @dictionary.sample
    @secret_word.length
  end
  
  def respond_to_guess(letter)
    [].tap do |letter_positions|
      @secret_word.each_char.with_index do |char, index|
        letter_positions << index if char == letter
      end
    end
  end
  
  def make_guess
  end
  
end


