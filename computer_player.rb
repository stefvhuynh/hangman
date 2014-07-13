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
    @target_word_length
  end
  
  # Chooser methods
  
  def pick_word_length    
    @secret_word = @dictionary.sample
    @secret_word.length
  end
  
  def respond_to_guess(guessed_letter)
    [].tap do |letter_positions|
      @secret_word.each_char.with_index do |char, index|
        letter_positions << index if char == guessed_letter
      end
    end
  end
  
  # Guesser methods
  
  def make_guess(wrong_letters, right_letters)
    trim_dictionary(wrong_letters, right_letters)
    catch_nonexistent_words
    freq_table = freq_table(@dictionary.join.split(//))
    # Randomly select one of the top three most frequent letters. By 
    # selecting a random letter rather than the most frequent letter, we
    # have a chance at guessing words that would otherwise be unguessable
    # when following the most-frequent-letter strategy.
    letter_pool = freq_table[0..2]
    # We need these or statements for when the letter pool shrinks to less
    # than three letters. This occurs near the end of the game.
    guess = letter_pool[rand(0..2)] ||
            letter_pool[rand(0..1)] ||
            letter_pool[0]
    # Skip over the letters that we've already guessed. Don't need to check 
    # this with wrong letters because trim_dictionary takes care of it.
    while right_letters.include?(guess[0])
      freq_table.delete(guess)
      letter_pool = freq_table[0..2]
      guess = letter_pool[rand(0..2)] ||
              letter_pool[rand(0..1)] ||
              letter_pool[0]
    end

    guess[0]
  end
  
  def receive_word_length(word_length)
    # Get the word length and trim the dictionary to words of that length
    @dictionary.select! { |word| word.length == word_length }
    @target_word_length = word_length
  end
  
  # Helper methods
  private
  
  def trim_dictionary(wrong_letters, right_letters)
    # Join together right_letters into a string so we can get letter counts
    # below.
    right_letters_str = right_letters.join
    # Uses the index to keep track of the beginning and ending of the 
    # combined arrays. This allows us to iterate through the dictionary
    # just one time, although the code is less clear.
    (right_letters + wrong_letters).each_with_index do |letter, index|
      @dictionary.reject! do |word|
        # Returns bools of the condition being tested based on whether we
        # are in the right_letters or the wrong_letters portion of the
        # combined array.
        if index < right_letters.length
          # Rejects words that do not have a correct letter in the right
          # position and words that have a different number of the correct
          # letter. right_letters is the first array, so the index here
          # aligns correctly.
          (!letter.nil? && word[index] != letter) ||
          (word.char_count(letter) != right_letters_str.char_count(letter))
        else
          # Rejects words that include an incorrect letter.
          word.include?(letter)
        end
      end
    end
  end
  
  def freq_table(arr)
    # Creates a hash of letter frequencies and returns an array of the form
    # [["a", 100], ["e", 68], ... ] that is sorted by letter frequency
    table = arr.each_with_object(Hash.new(0)) { |key, hash| hash[key] += 1 }
    table.sort_by { |key, value| value }.reverse
  end
  
  def catch_nonexistent_words
    if @dictionary.empty?
      puts "Your word is not in the dictionary!\n\n"
      raise UserError
    end
  end
  
end

class String
  def char_count(char)
    count = 0
    self.each_char { |c| count += 1 if c == char }
    count
  end
end


