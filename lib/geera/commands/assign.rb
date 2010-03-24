module Geera
  module Commands
    class Assign < Geera::Commands::Command
      def self.handle? command
        'assign' == command
      end

      def execute!
        ticket.assign_to argv.shift
      end
    end
  end
end
