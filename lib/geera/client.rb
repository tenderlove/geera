module Geera
  class Client
    attr_reader :username
    attr_reader :ctx

    def initialize url
      @ctx = Jira4R::JiraTool.new 2, url

      # Make jira4r quiet
      @ctx.logger = Logger.new nil
      @username = nil
    end

    ###
    # Login with +user+ and +password+
    def login user, password
      @username = user
      @ctx.login user, password
    end

    ###
    # Get the ticket with +number+.  Returns a Geera::Ticket object.
    #
    #   client.ticket 'BZ-123' # => #<Geera::Ticket>
    def ticket number
      Geera::Ticket.new self, number
    end
  end
end
