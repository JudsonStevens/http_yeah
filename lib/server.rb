require 'socket'
require "./lib/printer.rb"
require './lib/router.rb'

class Server
  attr_reader :server,
              :router,
              :printer

  def initialize
    @server = TCPServer.new(9292)
    @router = nil
    @printer = Printer.new
  end

  def start_server
    @client = @server.accept
    @router = Router.new(@client)
    @printer.ready_message
    loop do
      request_lines = []
      while line = @client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      @router.got_a_request(request_lines)
      @router.parse_request(request_lines)
    end
  end
end

x = Server.new
x.start_server
