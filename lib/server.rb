require 'socket'
class Server
  attr_reader :server,
              :router,
              :printer,
              :threads

  def initialize(port)
    @server = TCPServer.new(port)
    @router = Router.new
    @threads = []
  end

  # This is where we start the server loop that will continue to take in input
  # as the server runs. The client is initialized to receive input to the server
  # as sort of a gateway. We pass the client to the router object in order for
  # it to be able to print to the client. The server reads information from the
  # client input stream until it sees a line break, during which it finishes
  # shoveling information into the request_lines array. After that, the request
  # is sent to the router in order for it to be parsed and then operated on.
  # The got_a_request method prints out the request to the server/terminal,
  # enabling some debugging.
  
  def start_server
    puts "Ready for a request."
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
  end
end
