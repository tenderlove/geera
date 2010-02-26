require "test/unit"
require "geera"
require 'flexmock/test_unit'

###
# This is our fake jira object
class FakeJiraTool
  attr_accessor :call_stack

  def initialize
    @call_stack = []
  end

  def method_missing *args
    @call_stack << args
  end
end

class TestClient < Test::Unit::TestCase
  def setup
    @url = 'some_url'
    @fj = FakeJiraTool.new
    flexmock(Jira4R::JiraTool).should_receive(:new).with(2, @url).
      and_return(@fj)
  end

  def test_login
    client = Geera::Client.new(@url)
    client.login('foo', 'bar')

    assert_equal([:login, "foo", "bar"], @fj.call_stack.pop)
  end

  def test_comment
    number = 'BZ-123'
    comment = 'hello world'

    client = Geera::Client.new(@url)
    client.login('foo', 'bar')

    ticket = client.ticket number
    ticket.comment comment

    last_call = @fj.call_stack.pop
    assert_equal :addComment, last_call.first
    assert_equal number, last_call[1]
    assert_instance_of(Jira4R::V2::RemoteComment, last_call.last)
    assert_equal(comment, last_call.last.body)
  end
end

