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
      if @printer.hello_world_counter == 3
        @client.close
        exit
      end
      output_diagnostics
    end

  end

  def send_hello_world
    @counter += 1
    response = @printer.hello_world_response
    output = @printer.output_formatted(response)
    header = @printer.headers_formatted(output)
    @client.puts header
    @client.puts output
  end

  def got_a_request(request_lines)
    @printer.got_a_request_message(request_lines)
  end

  def output_diagnostics(request_lines)
    @counter += 1
    @client.puts @printer.print_debug(request_lines)
  end

  def parse_request(request_lines)
    input = @printer.retrieve_path(retrieve_lines)
    case input
    when input == "/"         then output_diagnostics(request_lines)
    when input == "/hello"    then send_hello_world
    when input == "/datetime" then print_date_and_time
    when input == "/shutdown" then shutdown(@counter)
    end
  end

  def print_date_and_time
    @client.puts @printer.date_and_time_message
  end

  def shutdown(counter)
    @client.puts @printer.shutdown_message(counter)
  end



end
