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
    loop do
      # Thread.start(@server.accept) { |client|
      client = @server.accept
      request_lines = []
      @router.accept_client(client)
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      @router.got_a_request(request_lines)
      require "pry"; binding.pry
      message = @router.parse_request(request_lines)
      require "pry"; binding.pry
      if message
        require "pry"; binding.pry
        shutdown(client)
      end
    # }
    end
  end

  def shutdown(client)
    client.close
    @server.close
  end
end

# x = Server.new
# x.start_server
