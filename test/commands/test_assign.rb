require "test/unit"
require "geera"
require 'flexmock/test_unit'

module Geera
  module Commands
    class TestAssign < Test::Unit::TestCase
      def test_handle?
        assert Assign.handle?('assign')
      end

      def test_execute!
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:assign_to).with('foo').once
        end

        Class.new(Geera::Commands::Assign) {
          def initialize ticket, argv
            super(nil, nil, nil, argv)
            @ticket = ticket
          end
        }.new(recorder, ['foo']).execute!
      end
    end
  end
end
