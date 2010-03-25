require "test/unit"
require "geera"
require 'flexmock/test_unit'

module Geera
  module Commands
    class TestShow < Test::Unit::TestCase
      def test_handle?
        assert Show.handle?('show')
      end

      def test_execute!
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:inspect).once.and_return('foo')
        end

        cmd = fake_command.new recorder

        flexmock(cmd).should_receive(:puts).with('foo')
        cmd.execute!
      end

      def fake_command
        Class.new(Geera::Commands::Show) {
          def initialize ticket
            super(nil, nil, nil, nil)
            @ticket = ticket
          end
        }
      end
    end
  end
end
