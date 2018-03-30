require 'simplecov'
SimpleCov.start
require "minitest"
require "minitest/emoji"
require "minitest/autorun"
require "./lib/server.rb"

class ServerTest < MiniTest::Test

  def setup
    @server = Server.new
  end

  def test_it_exists
    assert_instance_of Server, @server
  end

  def test_it_uses_the_correct_port

  end

  def test_it_can_receive_a_request
    
  end

  def test_it_responds_to_valid_HTTP_requests

  end



end




