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




end




