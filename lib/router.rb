require_relative 'printer.rb'

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
<<<<<<< HEAD
<<<<<<< HEAD
    when input == "/game"         then guess_response
=======
    when input == "/game"         then guess_history
>>>>>>> 65c9ecf579bc81e8836ae66dd300cb914b0dc1d8
=======
    when input == "/game"         then guess_response
>>>>>>> 1ae7fa49170e89e6e118880d148034127db79834
    when word_search_input(input) then search_dictionary(request_lines)
    end
  end

  def word_search_input(input)
    if input != nil
      input.include?("word_search")
    end
  end
<<<<<<< HEAD

<<<<<<< HEAD
=======
      
>>>>>>> 1ae7fa49170e89e6e118880d148034127db79834
  def guess_response
    response = @game.list_guess_information
    print_to_client(response)
  end
<<<<<<< HEAD

=======
>>>>>>> 65c9ecf579bc81e8836ae66dd300cb914b0dc1d8
=======
      
>>>>>>> 1ae7fa49170e89e6e118880d148034127db79834
  def post_handler(request_lines, input)
    if input == "/start_game"
      response = @printer.game_start_message
      print_to_client(response)
      @game = Game.new
    elsif input == "/game"
      body = @client.read(@printer.print_content_length(request_lines).to_i)
      guess = body.split("=")[1]
      @guesses << guess
      require "pry"; binding.pry
    @printer.got_a_request_message(request_lines)
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

  def print_to_client(response)
    output = @printer.output_formatted(response)
    header = @printer.headers_formatted(output)
    @client.puts header
    @client.puts output
  end


end
