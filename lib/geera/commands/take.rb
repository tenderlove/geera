module Geera
  module Commands
    class Take < Geera::Commands::Command
      def self.handle? command
        'take' == command
      end

      def execute!
        ticket.assign_to config['username']
      end
    end
  end
end
