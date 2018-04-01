require 'socket'
require "./lib/printer.rb"
require './lib/router.rb'

class Server
  attr_reader :server,
              :router,
              :printer

  def initialize
    @server = TCPServer.new(9292)
    @router = Router.new
    @printer = Printer.new
  end

  def start_server
    @printer.ready_message
    loop do
      request_lines = []
      @client = @server.accept
      @router.accept_client(@client)
      while line = @client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      @router.got_a_request(request_lines)
      message = @router.parse_request(request_lines)
      if message == "Shutdown"
        shutdown
      end
    end
  end

  def shutdown
    @client.close
    @server.close
  end
end

x = Server.new
x.start_server
