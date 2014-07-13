require "./user_error"

class HumanPlayer
  
  def initialize
    @secret_word_length
    @target_word_length
  end
  
  # Chooser methods
  
  def pick_word_length
    begin
      print "How many letters are in your word? "
      word_length = gets.chomp
      raise UserError if word_length =~ /[^0-9]|^$/
    rescue UserError
      puts "Not a number!"
      retry
    end
    
    @secret_word_length = word_length.to_i
  end
  
  def respond_to_guess(guessed_letter)        
    response = retrieve_response(guessed_letter)
    return (response.downcase =~ /n/) ? [] : retrieve_positions 
  end
  
  def secret_word
    print "What was your word? "
    gets.chomp
  end
  
  # Guesser methods
  
  def make_guess(wrong_letters, right_letters)
    guessed_letters = wrong_letters + right_letters
    
    begin
      print "Choose a letter: "
      guess = gets.chomp
      raise UserError if guess =~ /[^A-Za-z]|^$/ || 
                         guessed_letters.include?(guess)
    rescue UserError
      puts "Enter a letter that you have not already guessed!"
      retry
    end
    
    guess.downcase
  end
  
  def receive_word_length(word_length)
    @target_word_length = word_length
  end
  
  # Helper methods
  private
  
  def retrieve_response(guessed_letter)
    # Retrieves the response and checks for input errors.
    begin
      print "Is the letter, '#{guessed_letter}', in your word? (y/n) "
      response = gets.chomp
      raise UserError if response =~ /[^y|n|Y|N]|^$/
    rescue UserError
      puts "Enter y or n!"
      retry
    end
    
    response
  end
  
  def retrieve_positions
    # Retrieves the positions and checks that positions are in bounds.
    begin
      positions_str = retrieve_positions_str
      positions_arr = positions_str.split(/,/).map(&:to_i)
      
      unless positions_arr.all? { |pos| pos.between?(1, @secret_word_length) }
        raise UserError 
      end
    rescue UserError
      puts "Positions are out of bounds!"
      retry
    end
    
    # Decrement each position by 1 to account for 0-based indexing.
    positions_arr.map { |pos| pos - 1 }
  end
  
  def retrieve_positions_str
    # Retrieves the raw user input and checks for valid input.
    begin
      print "Where does this letter occur? (enter numbers separated by commas) "
      positions_str = gets.chomp
      raise UserError if positions_str =~ /[^0-9|,|\s]|^$/
    rescue UserError
      puts "Enter numbers separated by commas!"
      retry
    end
    
    positions_str
  end
  
end


