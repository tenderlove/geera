module Geera
  class Client
    def initialize url
      @tool = Jira4R::JiraTool.new 2, url

      # Make jira4r quiet
      @tool.logger = Logger.new nil
    end

    def login user, pass
      @tool.login user, pass
    end
  end
end
