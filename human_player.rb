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
  
  def respond_to_guess(letter)
    
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


