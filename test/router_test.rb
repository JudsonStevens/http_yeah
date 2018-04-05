require 'simplecov'
SimpleCov.start
require "minitest"
require "minitest/emoji"
require "minitest/autorun"
require './lib/printer.rb'
require '../complete_me/lib/complete_me.rb'

class RouterTest < MiniTest::Test

  def setup
    @r = Router.new
  end

  def test_it_exists
    assert_instance_of Router, @r
  end
end
