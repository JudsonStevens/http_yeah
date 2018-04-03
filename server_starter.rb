Dir["./lib/*.rb"].each { |file| require file }

Server.new(9292).start_server
