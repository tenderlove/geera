module Geera
  module Commands
    class Show < Geera::Commands::Command
      def self.handle? command
        'show' == command
      end

      def execute!
        puts ticket.inspect
      end
    end
  end
end
