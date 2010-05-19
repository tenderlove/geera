require "test/unit"
require "geera"
require 'flexmock/test_unit'

module Geera
  module Commands
    class TestList < Test::Unit::TestCase
      FakeTicket = Struct.new(:key, :summary)

      def test_handle?
        assert List.handle?('list')
      end

      def test_number_with_name
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:filters).once.and_return(
            [Struct.new(:name, :id).new('foo', 10)]
          )
        end

        cmd = List.new(nil, 'foo', recorder, [])
        assert_equal 10, cmd.number
      end

      def test_number
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:filters).never
        end

        cmd = List.new(nil, 10, recorder, [])
        assert_equal 10, cmd.number
      end

      def test_execute!
        number = 10

        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:list).with(number).once.and_return([
            FakeTicket.new('BZ-123', 'hello'),
            FakeTicket.new('BZ-124', 'world'),
          ])
        end

        cmd = Class.new(List) {
          attr_reader :putses
          def initialize *args
            super
            @putses = []
          end

          def puts string
            @putses << string
          end
        }.new(nil, number, recorder, [])

        cmd.execute!
        assert_match(/BZ-123/, cmd.putses.first)
        assert_match(/hello/, cmd.putses.first)
        assert_match(/BZ-124/, cmd.putses[1])
        assert_match(/world/, cmd.putses[1])
      end

      def test_empty_execute
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:list).with(10).once.and_return([])
        end

        cmd = Class.new(List) {
          attr_reader :putses
          def initialize *args
            super
            @putses = []
          end

          def puts string
            @putses << string
          end
        }.new(nil, 10, recorder, [])
        cmd.execute!

        assert_equal ["No Tickets found"], cmd.putses
      end
    end
  end
end

