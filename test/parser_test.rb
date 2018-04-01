require 'simplecov'
SimpleCov.start
require "minitest"
require "minitest/emoji"
require "minitest/autorun"
require_relative "../lib/parser.rb"

class ParserTest < MiniTest::Test

  def setup
    @p = Parser.new
    @r = ["GET / HTTP/1.1", "Host: localhost:9292", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:59
      .0) Gecko/20100101 Firefox/59.0", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
       "Accept-Language: en-US,en;q=0.5", "Accept-Encoding: gzip, deflate", "Connection: keep-alive", "Upgrade-Insecure-Requests: 1"]
  end

  def test_it_exists
    assert_instance_of Parser, @p
  end

  def test_it_can_retrieve_the_verb
    expected = "GET"
    actual = @p.retrieve_verb(@r)
    assert_equal expected, actual
  end

  def test_it_can_retrieve_the_path
    expected = "/"
    actual = @p.retrieve_path(@r)
    assert_equal expected, actual
  end


end
