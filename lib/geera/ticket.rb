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
  end
end
