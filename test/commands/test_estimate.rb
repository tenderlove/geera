require "test/unit"
require "geera"
require 'flexmock/test_unit'

module Geera
  module Commands
    class TestEstimate < Test::Unit::TestCase
      def test_handle?
        assert Estimate.handle?('estimate')
      end

      def test_execute!
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:estimate=).with('3h').once
        end

        Class.new(Geera::Commands::Estimate) {
          def initialize ticket, argv
            super(nil, nil, nil, argv)
            @ticket = ticket
          end
        }.new(recorder, %w{3h}).execute!
      end
    end
  end
end
