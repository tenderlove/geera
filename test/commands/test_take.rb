require "test/unit"
require "geera"
require 'flexmock/test_unit'

module Geera
  module Commands
    class TestTake < Test::Unit::TestCase
      def test_handle?
        assert Take.handle?('take')
      end

      def test_execute!
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:assign_to).with('foo').once
        end

        fake_command.new(recorder, 'username' => 'foo').execute!
      end

      def fake_command
        Class.new(Geera::Commands::Take) {
          def initialize ticket, config
            super(config, nil, nil, nil)
            @ticket = ticket
          end
        }
      end
    end
  end
end
