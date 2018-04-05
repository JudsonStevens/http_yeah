This is a project from Turing, Module 1, where we create a simple HTTP server to explore the relationship between the web and servers, using the HTTP protocol. 

In order to use this repo, clone it down, navigate to the root folder in your terminal, and use the command 'ruby server_starter.rb'. You will need to use an application similar to Postman in order to interact with all of the different aspects of the server.

Once you have the server running, you can do a variety of things to interact with the server, which is located at port 9292 on your localhost, or http://localhost:9292. The "path" are the "/" and words that come after the port, allowing you to do various things such as:

1. Using a GET request, you can utilize the path "/" to see a diagnostic message that will display information about the request the server received.
2. Using a GET request, you can utilize the path "/hello" to see the string "Hello, World!" printed out to the browser/clients screen that also includes a counter specific to that request that will increment every time it's called.
3. Using a GET request, you can utilize the path "/datetime" in order to see the current date and time.
4. Using a GET request, you can utilize the path "/game" in order to see the current guess you made and how many total guesses you have made. However, you must have a game running in order to do this. 
5. Using a GET request, you can utilize the path "/force_error" in order to force the server to shutdown by sending a "500" response code to the browser/client and raising a SystemError exception to the server.
6. Using a GET request, you can utilize the path "/sleepy" in order to pause for three seconds and print out the string "...yawn" to the browser/client. This was intended to be utilized to showcase threading, but I was unable to get threading to work.
7. Using a GET request, you can utilize the path "/shutdown" to list the total amount of requests to the screen of the client/browser and shut the server down.
8. Using a GET request, you can utilize the path "/word_search?" in the format "/word_search?word=(word_you_want_to_search_for)" in order to see if the word you want to search for is a valid word. If you include a "Accept: application/json" tag in your request, you can also search using a word fragment and the server will return possible word matches. 
8. Using a POST request, you can utilize the path "/start_game" to start a new guessing game. The object is to guess the number, which is between 1 and 100. 
9. Using a POST request, you can utilize the path "/game" with a guess in the body of the message to make a guess. Once you've made the guess, the server will print out the information from the GET request with path "/game" in order to tell you about your guess.


