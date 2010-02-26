module Geera
  class Client
    def initialize url
      @tool = Jira4R::JiraTool.new 2, url

      # Make jira4r quiet
      @tool.logger = Logger.new nil
    end

    ###
    # Login with +user+ and +password+
    def login user, password
      @tool.login user, password
    end

    ###
    # Get the ticket with +number+.  Returns a Geera::Ticket object.
    #
    #   client.ticket 'BZ-123' # => #<Geera::Ticket>
    def ticket number
      Geera::Ticket.new @tool, number
    end
  end
end
