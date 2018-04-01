class Game

<<<<<<< HEAD
<<<<<<< HEAD
  attr_reader :guesses,
              :answer

=======
>>>>>>> 65c9ecf579bc81e8836ae66dd300cb914b0dc1d8
=======

  attr_reader :guesses,
              :answer
  
>>>>>>> 1ae7fa49170e89e6e118880d148034127db79834
  def initialize
    @guesses = []
    @answer = rand(100)
  end


  def receive_guess(guess)
    @guesses << guess
  end

  def respond_to_query
<<<<<<< HEAD
    if @guesses.last > @answer
<<<<<<< HEAD
=======
>>>>>>> 1ae7fa49170e89e6e118880d148034127db79834
      return "Your current guess is too high."
    elsif @guesses.last < @answer
      return "Your current guess is too low."
    else
      return "Congratulations, you guessed the number."
    end
  end

  def list_guess_information
    return "You have made #{@guesses.count} guesses " +
           "and your current guess is #{guesses.last}. " +
           "#{respond_to_query}"
  end
end
<<<<<<< HEAD
=======
      return "too high"
    elsif @guesses.last < @answer
      return "too low"
    else
      return "congratulations"
    end
  end
  
>>>>>>> 65c9ecf579bc81e8836ae66dd300cb914b0dc1d8
=======
>>>>>>> 1ae7fa49170e89e6e118880d148034127db79834
