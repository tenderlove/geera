require "test/unit"
require "geera"
require 'flexmock/test_unit'

module Geera
  module Commands
    class TestFix < Test::Unit::TestCase
      def test_handle?
        assert Fix.handle?('fix')
      end

      def test_execute_startable
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:startable?).once.and_return(true)
          thing.should_receive(:start!).once
          thing.should_receive(:fixable?).once.and_return(true)
          thing.should_receive(:fix!).once
          thing.should_receive(:assign_to).once.with('foo')
        end

        fake_command.new(recorder, {'qa' => 'foo'}).execute!
      end

      def test_execute_not_startable
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:startable?).once.and_return(false)
          thing.should_receive(:start!).never
          thing.should_receive(:fixable?).once.and_return(true)
          thing.should_receive(:fix!).once
          thing.should_receive(:assign_to).once.with('foo')
        end

        fake_command.new(recorder, {'qa' => 'foo'}).execute!
      end

      def test_execute_not_fixable
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:startable?).once.and_return(false)
          thing.should_receive(:start!).never
          thing.should_receive(:fixable?).once.and_return(false)
          thing.should_receive(:fix!).never
          thing.should_receive(:assign_to).once.with('foo')
        end

        fake_command.new(recorder, {'qa' => 'foo'}).execute!
      end

      def test_execute_no_qa
        recorder = Object.new
        flexmock(recorder) do |thing|
          thing.should_receive(:startable?).once.and_return(false)
          thing.should_receive(:start!).never
          thing.should_receive(:fixable?).once.and_return(false)
          thing.should_receive(:fix!).never
          thing.should_receive(:assign_to).never
        end

        fake_command.new(recorder, {'qa' => nil}).execute!
      end

      def fake_command
        Class.new(Geera::Commands::Fix) {
          def initialize ticket, config
            super(config, nil, nil, nil)
            @ticket = ticket
          end
        }
      end
    end
  end
end
