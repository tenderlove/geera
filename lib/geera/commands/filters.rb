module Geera
  module Commands
    class Filters < Geera::Commands::Command
      def self.handle? command
        'filters' == command
      end

      def execute!
        puts "# Your filters"
        geera.filters.each do |filter|
          puts "  * #{filter.name.inspect}"
        end
      end
    end
  end
end
