module Geera
  module Commands
    class Estimate < Geera::Commands::Command
      def self.handle? command
        'estimate' == command
      end

      def execute!
        ticket.estimate = argv.shift
      end
    end
  end
end
