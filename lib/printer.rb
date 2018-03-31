class Printer

  attr_reader :hello_world_counter

  def initialize
    @hello_world_counter = 0
  end

  def ready_message
    puts "Ready for a request."
  end

  def hello_world_response
    @hello_world_counter += 1
    return "<pre>" + "Hello, World! (#{hello_world_counter})" + "</pre>"
  end

  def date_and_time_message
    return "<pre> #{Time.now.strftime('%I:%M%p on %A, %B %e, %Y')} </pre>"
  end

  def shutdown_message(counter)
    return "<pre> Total Requests: #{counter} </pre>"
  end

  def output_formatted(response)
    return "<html><head></head><body>#{response}</body></html>"
  end

  def headers_formatted(output)
    return ["http/1.1 200 ok",
            "date: #{Time.now.strftime('%a, %e, %b, %Y, %H:%M:%S %z')}",
            "server: ruby",
            "content-type: text/html; charset=iso-8859-1",
            "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def got_a_request_message(request_lines)
    puts "Got this request:"
    puts request_lines.inspect
    puts "\n"
  end

  def retrieve_verb(request_lines)
    request_lines[0].split[0]
  end

  def retrieve_path(request_lines)
    request_lines[0].split[1]
  end

  def retrieve_protocol(request_lines)
    request_lines[0].split[2]
  end

  def retrieve_host(request_lines)
    request_lines[1].split(":")[1].strip
  end

  def retrieve_port(request_lines)
    request_lines[1].split(":")[2].strip
  end

  def retrieve_origin(request_lines)
    request_lines[1].split(":")[1].strip
  end

  def retrieve_accept(request_lines)
    request_lines[3].split(":")[1].strip
  end

  def print_debug(request_lines)
    puts "Verb: #{retrieve_verb(request_lines)}"
    puts "Path: #{retrieve_path(request_lines)}"
    puts "Protocol: #{retrieve_protocol(request_lines)}"
    puts "Host: #{retrieve_host(request_lines)}"
    puts "Port: #{retrieve_port(request_lines)}"
    puts "Origin: #{retrieve_origin(request_lines)}"
    puts "Accept: #{retrieve_accept(request_lines)}"
  end
end
