# encoding: utf-8
module Www
  class App
    def self.call(env)
      Base.call(env)
    end
  end
end
