require_relative '../../complete_me/lib/complete_me'

class Router
  attr_reader :printer,
              :counter,
              :client,
              :guesses,
              :game,
              :threads

  def initialize
    @parser = Parser.new
    @printer = Printer.new
    @word_search_trie = CompleteMe.new
    @counter = 0
    @guesses = []
    @client = nil
    @game = nil
  end

  def populate_dictionary_into_trie
    @word_search_trie.populate(File.read('/usr/share/dict/words'))
  end

  def accept_client(client)
    @client = client
  end

  def got_a_request(request_lines)
    @printer.got_a_request_message(request_lines)
  end

  def parse_request(request_lines)
    path = @parser.retrieve_path(request_lines)
    verb = @parser.retrieve_verb(request_lines)
    @counter += 1
    case
    when verb == "POST"                 then post_handler(request_lines, path)
    when path == "/"                    then output_diagnostics(request_lines)
    when path == "/hello"               then print_hello_world
    when path == "/datetime"            then print_date_and_time
    when path == "/shutdown"            then shutdown(@counter)
    when path == "/game"                then guess_response
    when path == "/force_error"         then error_message
    when path == "/sleepy"              then sleepy_time
    when word_search_path(path)         then search_dictionary(request_lines)
    end
    uknown_string
  end

  def post_handler(request_lines, path)
    if path == "/start_game" && @game == nil
      start_new_game
    elsif path == "/start_game" && @game.class == Game
      print_to_client("Game in progress!", "403 Forbidden")
    elsif path == "/game"
      store_guess_and_check_win_conditions(request_lines, path)
    end
  end

  def start_new_game
    response = @printer.game_start_message
    print_to_client(response, "301 Moved Permanently")
    @game = Game.new
  end

  def store_guess_and_check_win_conditions(request_lines, path)
    @printer.got_a_request_message(request_lines)
    body = @client.read(@printer.print_content_length(request_lines).to_i)
    guess = body.split("=")[1]
    response = @printer.game_continue_guessing
    win = @game.receive_guess(guess)
    response = @printer.game_win_message if win
    print_to_client(response)
  end

  def output_diagnostics(request_lines)
    response = @printer.print_debug(request_lines)
    print_to_client(response)
  end

  def print_hello_world
    response = @printer.hello_world_response
    print_to_client(response)
  end

  def print_date_and_time
    response = @printer.date_and_time_message
    print_to_client(response)
  end

  def guess_response
    response = start_game_first_message if @game == nil
    response = @game.list_guess_information
    print_to_client(response)
  end


  def shutdown(counter)
    response = @printer.shutdown_message(counter)
    print_to_client(response)
    @client.close
  end

  def sleepy_time
    sleep(3)
    response = @printer.sleep_message + "#{@counter}"
    print_to_client(response)
  end

  def word_search_path(path)
    path.include?("word_search") if path != nil
  end

  def search_dictionary(request_lines)
    response = @printer.word_found_or_not_found_message(request_lines)
    if @parser.retrieve_accept(request_lines) == "application/json"
      word = response.split[0]
      if response.split[2] == "not"
        value = false
      else
        value = true
      end
      word_fragment_search(word, value)
    end
    print_to_client(response)
  end

  def word_fragment_search(word, value)
    populate_dictionary_into_trie
    suggestions = @word_search_trie.suggest(word, true)
    require "pry"; binding.pry
    response = @printer.print_word_suggestions(word, suggestions, value)
    print_to_client(response)
  end

  def error_message
    response = @printer.error_message_contents
    print_to_client(response, "500 Internal Service Error")
    raise "A SYSTEM ERROR has occured"
  end

  def uknown_string
    print_to_client("Uknown PATH!", "404 Not Found")
  end

  def print_to_client(response, status_code = "200 ok")
    output = @printer.output_formatted(response)
    header = @printer.headers_formatted(output, status_code)
    @client.puts header
    @client.puts output
  end

end
