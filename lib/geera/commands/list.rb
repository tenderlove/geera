module Geera
  module Commands
    class List < Geera::Commands::Command
      def self.handle? command
        'list' == command
      end

      def number
        ## Ensure that +number+ is actually a number
        begin
          @number = Integer(super)
        rescue ArgumentError
          @number = geera.filters.find { |f| f.name == super }.id
        end
      end

      def execute!
        tickets = geera.list number
        if tickets.empty?
          puts "No Tickets found"
        else
          tickets.first(10).each do |ticket|
            puts "#{ticket.key.ljust(8)} #{ticket.summary}"
          end
        end
      end
    end
  end
end
