require "test/unit"
require "geera"
require 'flexmock/test_unit'

class TestTicket < Test::Unit::TestCase
  def test_estimate=
    jira   = Object.new
    number = 10

    flexmock(jira) do |thing|
      thing.should_receive(:updateIssue).with(number, on { |thing|
        thing.first.id == 'timetracking' &&
          thing.first.values == '3h'
      }).once
    end
    ticket = Geera::Ticket.new(Struct.new(:ctx).new(jira), number)
    ticket.estimate = '3h'
  end
end
