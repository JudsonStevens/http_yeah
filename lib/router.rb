require_relative 'printer.rb'

class Router
  attr_reader :printer,
              :counter,
              :client,
              :guesses

  def initialize(client)
    @client = client
    @counter = 0
    @printer = Printer.new
    @guesses = []
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
    when input == "/game"         then guess_history
    when word_search_input(input) then search_dictionary(request_lines)
    end
  end

  def word_search_input(input)
    if input != nil
      input.include?("word_search")
    end
  end

  def post_handler(request_lines, input)
    if input == "/start_game"
      response = @printer.game_start_message
      print_to_client(response)
    elsif input == "/game"
      body = @client.read(@printer.print_content_length(request_lines).to_i)
      guess = body.split("=")[1]
      @guesses << guess
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
  end

  def print_to_client(response)
    output = @printer.output_formatted(response)
    header = @printer.headers_formatted(output)
    @client.puts header
    @client.puts output
  end


end
