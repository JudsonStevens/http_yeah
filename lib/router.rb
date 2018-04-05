require_relative '../../complete_me/lib/complete_me'

class Router
  attr_reader :printer,
              :counter,
              :client,
              :guesses,
              :game,
              :threads

  def initialize
    @printer = Printer.new
    @word_search_trie = CompleteMe.new
    @counter = 0
    @guesses = []
    @client = nil
    @game = nil
  end

  # This method populates the Complete Me project word trie in order to be
  # utilized for the word search functionality. This function reads into the
  # trie the local dictionary.
  def populate_dictionary_into_trie
    @word_search_trie.populate(File.read('/usr/share/dict/words'))
  end

  def accept_client(client)
    @client = client
  end

  def got_a_request(request_lines)
    @printer.got_a_request_message(request_lines)
  end

  # This function takes in the request from the server and decides what to do
  # with the input. We obtain the path and the verb from the printer object and
  # dive into our conditional with those two pieces of information. We also
  # increment the total request counter in order to eventually pass it to the
  # shutdown method. If the verb is POST, the request is sent to the seperate
  # POST handler which then decides what to do with the input. Otherwise,
  # there are a variety of forks in this conditional depending on the input.

  def parse_request(request_lines)
    path = @printer.retrieve_path(request_lines)
    verb = @printer.retrieve_verb(request_lines)
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
    unknown_string
  end

  # The post handler takes in input with a verb of POST and decides where it
  # goes. This input will be game related, and is either used to start the game
  # or make a guess. There is a redirect that this conditional ties into. If
  # a request is made to start the game, the game is started and the user is
  # redirected to another path to start guessing.

  def post_handler(request_lines, path)
    case
    when path == "/start_game" && @game == nil  then start_new_game_redirect
    when path == "/start_game" && @game         then print_to_client("403 - FORBIDDEN - Game in progress!", "403 Forbidden")
    when path == "/game" && @game == nil        then start_new_game
    when path == "/game"                        then store_guess_and_check_win_conditions(request_lines, path)
    end
  end

  # This method starts a new game, and redirects the user to the base path.

  def start_new_game_redirect
    @game = Game.new
    new_location = "http://localhost:9292/"
    redirect_print_to_client("301 Moved Permanently", new_location)
  end

  # This method starts a new game and responds to the client with a good luck
  # message.

  def start_new_game
    @game = Game.new
    response = @printer.game_start_message
    print_to_client(response)
  end

  # This method takes the request in, and seperates out the guess based on the
  # content length identifier and the .read method performed on the client.
  # The guess is then passed to the game class, where it is stored and evaluated.
  # On a win, the user is notified. Otherwise the game redirects the user to
  # the GET request path /game. This utilizes a 303 redirect to the client.

  def store_guess_and_check_win_conditions(request_lines, path)
    @printer.got_a_request_message(request_lines)
    body = @client.read(@printer.print_content_length(request_lines).to_i)
    guess = body.split("=")[1]
    win = @game.receive_guess(guess)
    if win
      response = @printer.game_win_message(@game.list_guess_information)
      print_to_client(response)
    end
    new_location = "http://localhost:9292/game"
    redirect_print_to_client("303 Redirect to Game", new_location)
  end

  # This method outputs the diagnostics, which include the PATH, VERB, and
  # PROTOCOL.

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

  # This method responds to the users guess, and if the game doesn't exist,
  # tells the user to start the game.

  def guess_response
    response = @printer.start_game_first_message if @game == nil
    response = @game.list_guess_information
    print_to_client(response)
  end

  # This method is the end of the /shutdown PATH, and shuts down the client
  # connection, causing the server to raise an error and end the session.

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

  # This method ensures that the word search PATH contains the string "word_search".

  def word_search_path(path)
    path.include?("word_search") if path != nil
  end

  # This method takes in the request and sends it to the printer in order to be
  # evaluated to see if the word is a valid word. If the accept message
  # includes the "Accept: application/json" tag, then the word is sent to the
  # trie search. If the word is an existing word, it also sends along a value
  # of true, in order to tell the word_fragment_search method that the result
  # should be printed out in a certain way.

  def search_dictionary(request_lines)
    response = @printer.word_found_or_not_found_message(request_lines)
    if @printer.retrieve_accept(request_lines) == "application/json"
      word = response.split[0]
      response.split[2] == "not" ? value = false : value = true
      word_fragment_search(word, value)
    end
    print_to_client(response)
  end

  # This method utilizes a word search trie from a previous project. It
  # takes in the word and the value indicating whether it is a word fragment or
  # not. If it is, it utilizes a mid-word suggest method in the word search
  # trie. It sends the word, suggestions, and the true or false value to the
  # printer in order to be formatted and returned to the client.

  def word_fragment_search(word, value)
    populate_dictionary_into_trie
    suggestions = @word_search_trie.suggest(word, true)
    response = @printer.print_word_suggestions(word, suggestions, value)
    print_to_client(response)
  end

  def error_message
    response = @printer.error_message_contents
    print_to_client(response, "500 Internal Service Error")
    raise "A SYSTEM ERROR has occured"
  end

  def unknown_string
    print_to_client("404 - Uknown PATH!", "404 Not Found")
  end

  # This is the method used to print to the client. It takes a default value
  # of 200 ok for the status, but that can be changed at any time. It sends
  # whatever response it gets along to the formatting portion of the printer
  # in order to be returned to the client.

  def print_to_client(response, status_code = "200 ok")
    output = @printer.output_formatted(response)
    header = @printer.headers_formatted(output, status_code)
    @client.puts header
    @client.puts output
  end

  # This method simply takes the redirect code and adds in a new location,
  # sending that information to the printer to be formatted and then returned
  # to the client, allowing the server to redirect the client wherever it
  # chooses.

  def redirect_print_to_client(status_code = "200 ok", new_location)
    header = @printer.redirect_headers_formatted(status_code, new_location)
    @client.puts header
  end
end
