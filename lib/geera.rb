require 'jira4r'
require 'geera/client'
require 'geera/ticket'

module Geera
  VERSION = '1.2.1'
end

# Total hacks for shutting up Jira4R
class Jira4R::JiraTool
  def puts *args
  end
end
