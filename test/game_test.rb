require 'simplecov'
SimpleCov.start
require "minitest"
require "minitest/emoji"
require "minitest/autorun"
require 'mocha/minitest'
require_relative "../lib/game.rb"

class GameTest < MiniTest::Test

  def setup
    @g = Game.new
  end

  def test_it_exists
    assert_instance_of Game, @g
  end

  def test_it_generates_a_random_number_between_1_and_100_on_instantiation
    expected = true
    actual = @g.answer.between?(1, 100)
    assert_equal expected, actual
  end

  def test_it_can_receive_guesses
    @g.receive_guess(100)
    @g.receive_guess(101)
    @g.receive_guess(100)

    expected = [100, 101, 100]
    actual = @g.guesses

    assert_equal expected, actual
  end

  def test_it_can_respond_correctly_to_high_guess
    @g.guesses << 101
    expected = "Your current guess is too high."
    actual = @g.respond_to_query
    assert_equal expected, actual
  end

  def test_it_can_respond_correctly_to_low_guess
    @g.guesses << 0
    expected = "Your current guess is too low."
    actual = @g.respond_to_query
    assert_equal expected, actual
  end

  def test_it_can_respond_to_correct_guess
    @g.guesses << @g.answer
    expected = "Congratulations, you guessed the number."
    actual = @g.respond_to_query
    assert_equal expected, actual
  end

  def test_it_can_handle_multiple_guesses_and_respond_correctly
    @g.guesses << 100
    @g.guesses << 15
    @g.guesses << 0
    expected = "Your current guess is too low."
    actual = @g.respond_to_query
    assert_equal expected, actual
  end

  def test_it_lists_guess_information_correctly
    @g.guesses << 100
    @g.guesses << 100
    @g.guesses << 15
    @g.guesses << 0

    expected =  "You have made 4 guesses " +
                "and your current guess is 0. " +
                "#{@g.respond_to_query}"
    actual = @g.list_guess_information

    assert_equal expected, actual
  end

end
