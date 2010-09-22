require 'jira4r'
require 'geera/client'
require 'geera/ticket'
require 'geera/executable'
require 'geera/commands/command'
require 'geera/commands/assign'
require 'geera/commands/start'
require 'geera/commands/resolve'
require 'geera/commands/fix'
require 'geera/commands/take'
require 'geera/commands/show'
require 'geera/commands/filters'
require 'geera/commands/list'
require 'geera/commands/estimate'

module Geera
  VERSION = '1.3.0'
end

# Total hacks for shutting up Jira4R
class Jira4R::JiraTool
  def puts *args
  end
end
