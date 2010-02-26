module Geera
  class Ticket
    ###
    # Create a new Ticket using JiraTool context +ctx+ and +ticket_number+.
    # This constructor should not be called directly, use Geera::Client#ticket
    # instead.
    def initialize ctx, ticket_number
      @ctx    = ctx
      @number = ticket_number
    end

    ###
    # Add a comment to this ticket with +text+.
    def comment text
      @ctx.addComment @number, Jira4R::V2::RemoteComment.new(nil, text)
    end

    ###
    # Returns a list of the actions that can be performed on this ticket.
    def available_actions
      @ctx.getAvailableActions @number
    end

    def startable?
      available_actions.map { |a| a.name }.include?('Start')
    end
  end
end
