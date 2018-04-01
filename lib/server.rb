require 'socket'
require "./lib/printer.rb"

class Server
  attr_reader :server,
              :printer,
              :client,
              :counter

  def initialize
    @server = TCPServer.new(9292)
    @printer = Printer.new
    @counter = 0
  end

  def start_server
    @client = @server.accept
    @printer.ready_message
    loop do
      request_lines = []
      while line = @client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      got_a_request(request_lines)
      parse_request(request_lines)
    end
  end

  def got_a_request(request_lines)
    @printer.got_a_request_message(request_lines)
  end

  def parse_request(request_lines)
    input = @printer.retrieve_path(request_lines)
    verb = @printer.retrieve_verb(request_lines)
    case
    when verb == "POST"           then post_handler(request_lines)
    when input == "/"             then output_diagnostics(request_lines)
    when input == "/hello"        then send_hello_world
    when input == "/datetime"     then print_date_and_time
    when input == "/shutdown"     then shutdown(@counter)
    when word_search_input(input) then search_dictionary(request_lines)
    end
  end

  def word_search_input(input)
    input.include?("word_search")
  end

  def post_handler(request_lines)
    puts @client.read(@printer.printing_content_length(request_lines).to_i)
    @printer.got_a_request_message(request_lines)
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

  def send_hello_world
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

x = Server.new
x.start_server
