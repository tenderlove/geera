require "test/unit"
require "geera"
require 'flexmock/test_unit'

module Geera
  module Commands
    class TestStart < Test::Unit::TestCase
      def test_handle?
        assert Start.handle?('start')
      end

      def test_execute!
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:startable?).once.and_return(true)
          thing.should_receive(:start!).once
        end

        Class.new(Geera::Commands::Start) {
          def initialize ticket
            super(nil, nil, nil, nil)
            @ticket = ticket
          end
        }.new(recorder).execute!
      end
    end
  end
end
