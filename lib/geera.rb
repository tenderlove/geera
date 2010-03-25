require 'jira4r'
require 'geera/client'
require 'geera/ticket'
require 'geera/executable'
require 'geera/commands/command'
require 'geera/commands/assign'
require 'geera/commands/start'
require 'geera/commands/fix'
require 'geera/commands/take'
require 'geera/commands/show'
require 'geera/commands/filters'

module Geera
  VERSION = '1.2.2'
end

# Total hacks for shutting up Jira4R
class Jira4R::JiraTool
  def puts *args
  end
end
