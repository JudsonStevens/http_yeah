class Game

  def initialize
    @guesses = []
    @answer = rand(100)
  end


  def receive_guess(guess)
    @guesses << guess
  end

  def respond_to_query
    if @guesses.last > @answer
      return "too high"
    elsif @guesses.last < @answer
      return "too low"
    else
      return "congratulations"
    end
  end
  
