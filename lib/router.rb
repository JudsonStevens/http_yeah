require_relative 'printer.rb'
require_relative 'game.rb'

class Router
  attr_reader :printer,
              :counter,
              :client,
              :guesses,
              :game

  def initialize
    @counter = 0
    @printer = Printer.new
    @guesses = []
    @client = nil
    @game = nil
  end

  def accept_client(client)
    @client = client
  end

  def got_a_request(request_lines)
    @printer.got_a_request_message(request_lines)
  end

  def parse_request(request_lines)
    input = @printer.retrieve_path(request_lines)
    verb = @printer.retrieve_verb(request_lines)
    case
    when verb == "POST"           then post_handler(request_lines, input)
    when input == "/"             then output_diagnostics(request_lines)
    when input == "/hello"        then print_hello_world
    when input == "/datetime"     then print_date_and_time
    when input == "/shutdown"     then shutdown(@counter)
    when input == "/game"         then guess_response
    when word_search_input(input) then search_dictionary(request_lines)
    end
    print_to_client("Uknown PATH!", "404 Not Found")
  end

  def word_search_input(input)
    if input != nil
      input.include?("word_search")
    end
  end

  def guess_response
    @counter += 1
    if @game == nil
      response = "You need to start a game with a POST request first!"
    else
      response = @game.list_guess_information
    end
    print_to_client(response)
  end

  def post_handler(request_lines, input)
    @counter += 1
    if input == "/start_game" && @game == nil
      response = @printer.game_start_message
      print_to_client(response, "301 Moved Permanently")
      @game = Game.new
    elsif input == "/start_game" && @game.class == Game
      print_to_client("Game in progress!", "403 Forbidden")
    elsif input == "/game"
      @printer.got_a_request_message(request_lines)
      body = @client.read(@printer.print_content_length(request_lines).to_i)
      guess = body.split("=")[1]
      win = @game.receive_guess(guess)
      response = @printer.game_continue_guessing
      print_to_client(response)
      if win == true
        response = @printer.game_win_message
        print_to_client(response)
      end
    end
  end

  def search_dictionary(request_lines)
    @counter += 1
    response = @printer.word_found_or_not_found_message(request_lines)
    print_to_client(response)
  end

  def output_diagnostics(request_lines)
    @counter += 1
    response = @printer.print_debug(request_lines)
    print_to_client(response)
  end

  def print_hello_world
    @counter += 1
    response = @printer.hello_world_response
    print_to_client(response)
  end

  def print_date_and_time
    @counter += 1
    response = @printer.date_and_time_message
    print_to_client(response)
  end

  def shutdown(counter)
    response = @printer.shutdown_message(counter)
    print_to_client(response)
    @client.close
    return "Shutdown"
  end

  def print_to_client(response, status_code = "200 ok")
    output = @printer.output_formatted(response)
    header = @printer.headers_formatted(output, status)
    @client.puts header
    @client.puts output
  end


end
