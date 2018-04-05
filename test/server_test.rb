require 'simplecov'
SimpleCov.start
require "minitest"
require "minitest/emoji"
require "minitest/autorun"
require "./lib/server.rb"
require "./lib/router.rb"
require "./lib/printer.rb"
require "./lib/parser.rb"

require 'faraday'

class ServerTest < MiniTest::Test

  def test_it_can_receive_a_request_and_send_a_response_to_hello
    response = Faraday.get "http://localhost:9292/hello"

    assert response.body.include?("Hello, World")
  end

  def test_it_can_receive_a_request_and_send_a_response_to_datetime
    response = Faraday.get "http://localhost:9292/datetime"

    assert response.body.include?("April")
  end

  def test_it_can_receive_a_request_and_send_a_response_to_sleepy
    response = Faraday.get "http://localhost:9292/sleepy"

    assert response.body.include?("yawn")
  end

  # def test_it_can_receive_a_request_and_send_a_response_to_force_error
  #   response = Faraday.get "http://localhost:9292/force_error"
  #
  #   assert response.body.include?("500")
  # end

  def test_it_can_receive_a_request_and_send_a_response_to_diagnostics
    response = Faraday.get "http://localhost:9292/"

    assert response.body.include?("Accept")
  end

  # def test_it_can_receive_a_request_and_send_a_response_to_game
  #   response = Faraday.get "http://localhost:9292/game"
  #
  #   assert response.body.include?("You need")
  # end

  def test_it_can_receive_a_request_and_send_a_response_to_word_search
    response = Faraday.get "http://localhost:9292/word_search?word=never"

    assert response.body.include?("is a known word")
  end
end
