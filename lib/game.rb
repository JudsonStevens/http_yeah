class Game

  attr_reader :guesses,
              :answer

  def initialize
    @guesses = []
    @answer = rand(100)
  end


  def receive_guess(guess)
    @guesses << guess
  end

  def respond_to_query
    if @guesses.last > @answer
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
