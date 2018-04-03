require 'socket'
require "./lib/printer.rb"
require './lib/router.rb'

class Server
  attr_reader :server,
              :router,
              :printer,
              :threads

  def initialize(port)
    @server = TCPServer.new(port)
    @router = Router.new
    @printer = Printer.new
    @threads = []
  end

  def start_server
    @printer.ready_message
     @threads << Thread.start {
    loop do
      client = @server.accept
      request_lines = []
      @router.accept_client(client)
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      @router.got_a_request(request_lines)
      @router.parse_request(request_lines)
    end
  }
  @threads.each { |thread| thread.join }
  end
end
