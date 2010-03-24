module Geera
  module Commands
    class Start < Geera::Commands::Command
      def self.handle? command
        'start' == command
      end

      def execute!
        unless ticket.startable?
          abort "Ticket #{@number} is not startable. Available actions:\n" \
            "  - #{ticket.available_actions.map { |x| x.name + "\n" }.join("  - ")}"
        end
        ticket.start!
      end
    end
  end
end
