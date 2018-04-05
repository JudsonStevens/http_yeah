require 'simplecov'
SimpleCov.start
require "minitest"
require "minitest/emoji"
require "minitest/autorun"
require 'mocha/minitest'
require_relative '../lib/printer.rb'
require_relative '../lib/parser.rb'

class PrinterTest < MiniTest::Test

  def setup
    @printer = Printer.new
    @parser = Parser.new
    @request = ["POST /game HTTP/1.1", "Host: localhost:9292", "Connection: keep-alive", "Content-Length: 8", "Accept: application/json", "Cache-Control: no-cache", "Origin: chrome-extension://fhbjgbiflinjbdggehc
                ddcbncdddomop", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36", "Postman-Token: cc75c5d8-14f4-77fa-3fd4-9299
                322b1229", "Content-Type: application/x-www-form-urlencoded", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]
    @word_request =  ["GET /word_search?word=never HTTP/1.1", "Host: localhost:9292", "Connection: keep-alive", "Content-Length: 8", "Accept: application/json", "Cache-Control: no-cache", "Origin: chrome-extension://fhbjgbiflinjbdggehc
                ddcbncdddomop", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36", "Postman-Token: cc75c5d8-14f4-77fa-3fd4-9299
                322b1229", "Content-Type: application/x-www-form-urlencoded", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]
  end

  def test_it_exists
    assert_instance_of Printer, @printer
  end

  def test_it_can_retrieve_the_path
    expected = "/game"
    actual = @printer.retrieve_path(@request)
    assert_equal expected, actual
  end

  def test_it_can_retrieve_the_verb
    expected = "POST"
    actual = @printer.retrieve_verb(@request)
    assert_equal expected, actual
  end

  def test_it_can_respond_with_hello_world_response
    expected = "<pre>Hello, World! (1)</pre>"
    actual = @printer.hello_world_response
    assert_equal expected, actual
  end

  def test_it_can_respond_with_start_game_first_message
    expected = "You need to start a game with a POST request first!"
    actual = @printer.start_game_first_message
    assert_equal expected, actual
  end

  def test_it_can_respond_with_correctly_formatted_date_and_time
  end

  def test_it_can_respond_with_shutdown_message
    expected = "<pre> Total Requests: 5 </pre>"
    actual = @printer.shutdown_message(5)
    assert_equal expected, actual
  end

  def test_it_can_return_formatted_output
    expected = "<html><head></head><body>Hello World</body></html>"
    actual = @printer.output_formatted("Hello World")
    assert_equal expected, actual
  end

  def test_it_can_return_formatted_headers
  end

  def test_it_returns_the_correct_error_message
    expected = "500 ERROR - A system error has occured, the server has shut down."
    actual = @printer.error_message_contents
    assert_equal expected, actual
  end

  def test_it_returns_the_sleep_message
    expected = "yawn..."
    actual = @printer.sleep_message
    assert_equal expected, actual
  end

  def test_it_returns_the_request_lines_message
    # expected = "Got this request:"
    # actual = @printer.got_a_request_message(@request)
    # assert_equal expected, actual
  end

  def test_it_returns_the_right_content_length
    expected = "8"
    actual = @printer.print_content_length(@request)
    assert_equal expected, actual
  end

  def test_it_returns_game_start_method
    expected = "Good luck!"
    actual = @printer.game_start_message
    assert_equal expected, actual
  end

  # def test_it_returns_the_continue_guessing_message
  #   expected = "Send a GET request with the PATH /game to check your guess " +
  #           "see if your guess is too low or too high. Send a POST " +
  #           "with a guess to keep guessing."
  #   actual = @printer.game_continue_guessing
  #   assert_equal expected, actual
  # end

  def test_it_can_return_a_found_word
    expected = "never is a known word"
    actual = @printer.word_found_or_not_found_message(@word_request)
    assert_equal expected, actual
  end

  def test_it_can_return_a_found_word_with_suggestions_from_word_fragment
    # word = "pizz"
    # suggestions = ["pizza", "pizzeria", "pizzicato", "pizzle", "spizzerinctum"]
    # value = false
    # expected = """{"word":"pizz","is_word":"is_a_word_fragment","possible_matches":"["pizza", "pizzeria", "pizzicato", "pizzle", "spizzerinctum"]"}"""
    # actual = @printer.print_word_suggestions(word, suggestions, value)
    # assert_equal expected, actual
  end

  def test_it_can_print_the_correct_debug_message
    expected =  "Verb: POST" + ("\n") +
                "Path: /game" + ("\n") +
                "Protocol: HTTP/1.1" + ("\n") +
                "Host: localhost" + ("\n") +
                "Port: 9292" + ("\n") +
                "Origin: localhost" + ("\n") +
                "Accept: application/json"
    actual = @printer.print_debug(@request)
    assert_equal expected, actual
  end
end
