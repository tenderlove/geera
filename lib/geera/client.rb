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

    ###
    # Create a ticket using +params+.  +params+ should be a hash, and *must*
    # have a +project+, +summary+, and +description+ field.
    #
    # For example:
    #
    #   client.create_ticket :project => 'AB',
    #                        :summary => 'foo',
    #                        :description => 'bar'
    #
    def create_ticket params
      [:project, :summary, :description].each do |param|
        raise(ArgumentError, "#{param} required") unless params[param]
      end

      issue = Jira4R::V2::RemoteIssue.new
      issue.project     = params[:project]
      issue.summary     = params[:summary]
      issue.description = params[:description]
      issue.assignee    = params[:assignee] || @username
      issue.type        = '1' #FIXME: wtf is this for?
      issue = @ctx.createIssue issue
      ticket issue.key
    end

    def filters
      @ctx.getSavedFilters
    end

    def list filter
      m = @ctx.driver.method('getIssuesFromFilter')
      m.call @ctx.token, filter
    end
  end
end
