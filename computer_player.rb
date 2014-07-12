class ComputerPlayer
  
  def self.read_dictionary
    # Need File.dirname(__FILE__) to test this in Rspec. This code grabs
    # the current directory of this file.
    File.readlines(File.dirname(__FILE__) + "/dictionary.txt").map(&:chomp)
  end
  
  def initialize(dictionary = self.class.read_dictionary)
    @dictionary = dictionary
  end
  
  def pick_word_length    
    @secret_word = @dictionary.sample
    @secret_word.length
  end
  
  def respond_to_guess(letter)
  end
  
  def make_guess
  end
  
end


