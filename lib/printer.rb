require_relative "parser.rb"

class Printer

  attr_reader :hello_world_counter

  def initialize
    @hello_world_counter = 0
    @parser = Parser.new
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

  def retrieve_path(request_lines)
    @parser.retrieve_path(request_lines)
  end

  def retrieve_verb(request_lines)
    @parser.retrieve_verb(request_lines)
  end

  def got_a_request_message(request_lines)
    puts "Got this request:"
    puts request_lines.inspect
    # puts print_debug(request_lines)
    puts "\n"
  end

  def printing_content_length(request_lines)
    @parser.retrieve_content_length(request_lines)
  end

  def word_found_or_not_found_message(request_lines)
    word = @parser.retrieve_word_for_word_search(request_lines)
    result = @parser.return_word_validity(word)
    return "#{word} is a known word" if result
    return "#{word} is not a known word" if !result
  end

  def print_debug(request_lines)
    "Verb: #{@parser.retrieve_verb(request_lines)}" +
    "Path: #{@parser.retrieve_path(request_lines)}" +
    "Protocol: #{@parser.retrieve_protocol(request_lines)}" +
    "Host: #{@parser.retrieve_host(request_lines)}" +
    "Port: #{@parser.retrieve_port(request_lines)}" +
    "Origin: #{@parser.retrieve_origin(request_lines)}" +
    "Accept: #{@parser.retrieve_accept(request_lines)}"
  end
end
