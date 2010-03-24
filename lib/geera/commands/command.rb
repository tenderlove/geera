module Geera
  module Commands
    class Command
      attr_reader :geera, :number, :config

      def initialize config, number, geera, argv
        @argv   = argv
        @config = config
        @number = number
        @geera  = geera
        @ticket = nil
      end

      def ticket
        @ticket ||= geera.ticket number
      end
    end
  end
end
