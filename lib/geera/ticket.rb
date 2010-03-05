require 'erb'

module Geera
  class Ticket
    attr_reader :number

    ###
    # Create a new Ticket using Geera::Client +client+ and +ticket_number+.
    # This constructor should not be called directly, use Geera::Client#ticket
    # instead.
    def initialize client, ticket_number
      @client = client
      @ctx    = client.ctx
      @number = ticket_number
      @issue  = nil
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

    ###
    # Start this ticket.
    def start!
      action = available_actions.find { |x| x.name == 'Start' }

      assign   = Jira4R::V2::RemoteFieldValue.new('assignee', @client.username)
      desc     = Jira4R::V2::RemoteFieldValue.new('description', description)
      priority = Jira4R::V2::RemoteFieldValue.new('priority', issue.priority)

      @ctx.progressWorkflowAction(@number, action.id, [assign, desc, priority])
    end

    ###
    # Is this ticket in a Fix able state?
    def fixable?
      available_actions.map { |a| a.name }.include?('Fix')
    end

    ###
    # Fix this ticket.
    def fix!
      action = available_actions.find { |x| x.name == 'Fix' }

      assign   = Jira4R::V2::RemoteFieldValue.new('assignee', @client.username)
      desc     = Jira4R::V2::RemoteFieldValue.new('description', description)
      priority = Jira4R::V2::RemoteFieldValue.new('priority', issue.priority)

      @ctx.progressWorkflowAction(@number, action.id, [assign, desc, priority])
    end

    ###
    # Assign this ticket to +username+
    def assign_to username
      assign = Jira4R::V2::RemoteFieldValue.new('assignee', username)
      @ctx.updateIssue(@number, [assign])
    end

    def description
      issue.description
    end

    def inspect
      template = ERB.new <<-eoinspect
## Reporter: <%= issue.reporter %>
## Assignee: <%= issue.assignee %>
## Priority: <%= issue.priority %>

## Summary

<%= issue.summary %>

## Description:

<%= issue.description %>

## Comments:
<% comments.each do |comment| %>
* <%= comment.author %>
  <% comment.body.split(/[\r\n]+/).each do |line| %>
  > <%= line %><% end %>
<% end %>

      eoinspect
      template.result binding
    end

    private
    def issue
      @issue ||= @ctx.getIssue(@number)
    end

    def comments
      @ctx.getComments @number
    end
  end
end
