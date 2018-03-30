require 'socket'
require "./lib/printer.rb"

class Server


  def initialize
    @server = TCPServer.new(9292)
    @printer = Printer.new
  end

  def start_server
    client = @server.accept
    @printer.ready_message
    loop do
      while line = client.gets and !line.chomp.empty?
        request_lines << lines.chomp
      end

  end


end
