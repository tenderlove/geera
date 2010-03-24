module Geera
  module Commands
    class Fix < Geera::Commands::Command
      def self.handle? command
        'fix' == command
      end

      def execute!
        ticket.start! if ticket.startable?
        ticket.fix! if ticket.fixable?
        ticket.assign_to config['qa'] if config['qa']
      end
    end
  end
end
