require "./user_error"

class HumanPlayer
  
  def pick_word_length
    begin
      print "How many letters are in your word? "
      word_length = gets.chomp
      raise UserError if word_length =~ /[^0-9]/
    rescue UserError
      puts "Not a number!"
    end
    
    word_length.to_i
  end
  
  def respond_to_guess(guessed_letter)    
    begin
      print "Is the letter, '#{guessed_letter}', in your word? (y/n) "
      response = gets.chomp
      raise UserError if response =~ /[^y|n|Y|N]/
    rescue UserError
      puts "Enter y or n!"
      retry
    end
    return [] if response.downcase =~ /n/
    
    begin
      print "Where does this letter occur? (enter numbers separated by commas) "
      positions = gets.chomp
      raise UserError if positions =~ /[^0-9|,|\s]/
    rescue UserError
      puts "Enter numbers separated by commas!"
      retry
    end
    
    # Decrement each position by 1 to account for 0-based indexing.
    positions.split(/,/).map { |pos| pos.to_i - 1 }  
  end
  
  def secret_word
    print "What was your word? "
    gets.chomp
  end
  
  def make_guess(wrong_letters, right_letters)
    guessed_letters = wrong_letters + right_letters
    
    begin
      print "Choose a letter: "
      guess = gets.chomp
      raise UserError if guess =~ /[^A-Za-z]/ || 
                         guess.length > 1 ||
                         guessed_letters.include?(guess)
    rescue UserError
      puts "Enter a letter that you have not already guessed!"
      retry
    end
    
    guess.downcase
  end
  
end


