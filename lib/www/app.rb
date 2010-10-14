# encoding: utf-8
module Www
  class App
    def self.call(env)
      request = Rack::Request.new(env)
      route, match = Base.find_route(request.path_info, request.request_method)
      if route
        handler = route.clazz.new(request)
        args = match[1..-1]
        args << request.params
        # adjust args
        arity = handler.method(:"www_#{route.name}").arity
        args = arity == 0 ? [] : args[0..(arity-1)]
        puts "#{route.clazz}##{route.name}(#{args.map{|i| "'#{i}'"}.join(', ')})" # TODO: use logger
        handler.send(route.name, *args)
      else
        error 404
      end
    end
  end
end
