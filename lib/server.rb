require 'socket'
require "./lib/printer.rb"

class Server
  attr_reader :server,
              :printer,
              :client

  def initialize
    @server = TCPServer.new(9292)
    @printer = Printer.new
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
      send_hello_world
      if @printer.hello_world_counter == 3
        @client.close
        exit
      end
      output_diagnostics
    end

  end

  def send_hello_world
    response = @printer.hello_world_response
    output = @printer.output_formatted(response)
    header = @printer.headers_formatted(output)
    @client.puts header
    @client.puts output
  end

  def got_a_request(request_lines)
    @printer.got_a_request_message(request_lines)
  end

  def output_diagnostics
    @printer.print_debug
  end


end

x = Server.new
x.start_server
