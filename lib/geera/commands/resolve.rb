module Geera
  module Commands
    class Resolve < Geera::Commands::Command
      def self.handle? command
        'resolve' == command
      end

      def execute!
        ticket.resolve!
      end
    end
  end
end
