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
  def test_login
    url = 'some_url'

    fj = FakeJiraTool.new

    flexmock(Jira4R::JiraTool).should_receive(:new).with(2, url).
      and_return(fj)

    client = Geera::Client.new(url)
    client.login('foo', 'bar')

    assert_equal([:login, "foo", "bar"], fj.call_stack.pop)
  end
end

