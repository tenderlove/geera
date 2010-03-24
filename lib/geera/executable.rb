module Geera
  class Executable
    attr_reader :geera

    def initialize config, argv, cmd_opts
      @geera = Geera::Client.new(config['url'])
      @geera.login(config['username'], config['password'])
    end
  end
end
