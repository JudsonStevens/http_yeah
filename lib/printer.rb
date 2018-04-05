require 'json'

class Printer

  # This class contains almost all of the messages we send back to the client.
  # It also contains three methods, all named retrieve, that reach into the
  # parser object and return values. This was done in order to keep the chain
  # of communication clear, as the parser only talks to the printer.

  attr_reader :hello_world_counter

  def initialize
    @hello_world_counter = 0
    @parser = Parser.new
  end

  def retrieve_path(request_lines)
    @parser.retrieve_path(request_lines)
  end

  def retrieve_verb(request_lines)
    @parser.retrieve_verb(request_lines)
  end

  def retrieve_accept(request_lines)
    @parser.retrieve_accept(request_lines)
  end

  def hello_world_response
    @hello_world_counter += 1
    return "<pre>" + "Hello, World! (#{hello_world_counter})" + "</pre>"
  end

  def start_game_first_message
    return "You need to start a game with a POST request first!"
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

  def headers_formatted(output, status)
    return ["http/1.1 #{status}",
            "date: #{Time.now.strftime('%a, %e, %b, %Y, %H:%M:%S %z')}",
            "server: ruby",
            "content-type: text/html; charset=iso-8859-1",
            "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def redirect_headers_formatted(status, new_location)
    return ["http/1.1 #{status}",
            "Location: #{new_location}",
            "date: #{Time.now.strftime('%a, %e, %b, %Y, %H:%M:%S %z')}",
            "server: ruby",
            "content-type: text/html; charset=iso-8859-1"].join("\r\n")
  end

  def error_message_contents
    return "500 ERROR - A system error has occured, the server has shut down."
  end

  def sleep_message
    return "yawn..."
  end

  def got_a_request_message(request_lines)
    print "Got this request:"
    puts request_lines.inspect
    puts "\n"
  end

  def print_content_length(request_lines)
    @parser.retrieve_content_length(request_lines)
  end

  def game_start_message
    return "Good luck!"
  end

  def game_win_message(message_from_game)
    return message_from_game
  end

  def word_found_or_not_found_message(request_lines)
    word = @parser.retrieve_word_for_word_search(request_lines)
    result = @parser.return_word_validity(word)
    return "#{word} is a known word" if result
    return "#{word} is not a known word" if !result
  end

  # This method takes in the word we are looking for, the suggestions form
  # the word search trie if it's a fragment, and the true or false value,
  # which tells it whether or not the word is a fragment. If it is,
  # it returns a formatted JSON string that includes possible word suggestions
  # for the fragment. If it is not a fragment, it returns the word and
  # tells the user it is a valid word. 

  def print_word_suggestions(word, suggestions, value)
    if value == true
      return {word: "#{word}", is_word: "#{value}"}.to_json
    else
      value = "is_a_word_fragment"
      word_hash = {word: "#{word}", is_word: "#{value}",
                   possible_matches: "#{suggestions}"}.to_json
      return JSON.pretty_generate(word_hash).delete('\\')
    end
  end

  def print_debug(request_lines)
    "Verb: #{@parser.retrieve_verb(request_lines)}" + ("\n") +
    "Path: #{@parser.retrieve_path(request_lines)}" + ("\n") +
    "Protocol: #{@parser.retrieve_protocol(request_lines)}" + ("\n") +
    "Host: #{@parser.retrieve_host(request_lines)}" + ("\n") +
    "Port: #{@parser.retrieve_port(request_lines)}" + ("\n") +
    "Origin: #{@parser.retrieve_origin(request_lines)}" + ("\n") +
    "Accept: #{@parser.retrieve_accept(request_lines)}"
  end
end
