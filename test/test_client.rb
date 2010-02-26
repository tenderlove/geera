require "test/unit"
require "geera"
require 'flexmock/test_unit'

###
# This is our fake jira object
class FakeJiraTool
  attr_accessor :call_stack, :returns

  def initialize
    @call_stack = []
    @returns = {}
  end

  def method_missing *args
    @call_stack << args
    @returns.delete(args.first) if @returns.key?(args.first)
  end
end

class TestClient < Test::Unit::TestCase
  def setup
    @url = 'some_url'
    @fj = FakeJiraTool.new
    flexmock(Jira4R::JiraTool).should_receive(:new).with(2, @url).
      and_return(@fj)

    @number   = 'BZ-123'
    @client   = Geera::Client.new(@url)
    @username = 'foo'
    @client.login(@username, 'bar')
    @ticket = @client.ticket @number
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

  def test_available_actions
    actions = [
      Jira4R::V2::RemoteNamedObject.new("1", "Fix"),
      Jira4R::V2::RemoteNamedObject.new("2", "Update Progress"),
    ]

    @fj.returns[:getAvailableActions] = actions

    assert_equal(actions, @ticket.available_actions)
  end

  def test_startable?
    actions = [
      Jira4R::V2::RemoteNamedObject.new("1", "Fix"),
      Jira4R::V2::RemoteNamedObject.new("2", "Update Progress"),
    ]
    @fj.returns[:getAvailableActions] = actions

    assert !@ticket.startable?

    actions = [
      Jira4R::V2::RemoteNamedObject.new("1", "Fix"),
      Jira4R::V2::RemoteNamedObject.new("2", "Start"),
    ]

    @fj.returns[:getAvailableActions] = actions
    assert @ticket.startable?
  end

  def test_start!
    startid = '1'

    actions = [
      Jira4R::V2::RemoteNamedObject.new(startid, "Start"),
      Jira4R::V2::RemoteNamedObject.new("2", "Update Progress"),
    ]

    @fj.returns[:getAvailableActions] = actions
    @ticket.start!

    last_call = @fj.call_stack.pop
    assert_equal :progressWorkflowAction, last_call.first
    assert_equal @number, last_call[1]
    assert_equal startid, last_call[2]

    assert_instance_of(Array, last_call.last)

    rfv = last_call.last.first
    assert_equal 'assignee', rfv.id
    assert_equal @username, rfv.values
  end

  def test_fixable
  end
end

