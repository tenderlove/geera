require "test/unit"
require "geera"
require 'flexmock/test_unit'

module Geera
  module Commands
    class TestFilters < Test::Unit::TestCase
      def test_handle?
        assert Filters.handle?('filters')
      end

      def test_execute!
        filter = Struct.new(:name).new('hi')

        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:filters).once.and_return([filter])
        end

        cmd = fake_command.new(recorder)
        flexmock(cmd).should_receive(:puts)
        cmd.execute!
      end

      def fake_command
        Class.new(Geera::Commands::Filters) {
          def initialize geera
            super(nil, nil, geera, nil)
          end
        }
      end
    end
  end
end
