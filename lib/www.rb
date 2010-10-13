# encoding: utf-8
require 'www/route'

class Www
  autoload :Route, 'www/route'
  autoload :App, 'www/app'

  @@current_route = nil
  @@routes = []

  class << self
    def routes
      @@routes
    end

    def route(pattern, methods = [:get])
      # TODO: 他のとかぶってたら warnning を出した方が良いかもしれない
      @@current_route = Route.new(pattern, methods, self)
    end

    def before(&block)
      @before_block = block
    end

    def before_block
      @before_block
    end

    def method_added(name)
      return unless @@current_route
      @@current_route.name = name
      @@routes << @@current_route
      @@current_route = nil
    end

    def error(code)
      [code, {"Content-Type" => "text/html"}, []]
    end

    def call(env)
      request  = Rack::Request.new(env)
      route, match = find_route(request)
      if route
        handler = route.clazz.new(request, route.name)
        arity = handler.method(route.name).arity
        args = match[0..arity]
        args.shift
        puts "#{route.clazz}##{route.name}(#{args.map{|i| "'#{i}'"}.join(', ')})"
        handler.process!(args)
      else
        error 404
      end
    end

    def find_route(request)
      @@routes.each do |route|
        if route.pattern =~ request.path_info &&
            route.request_methods.include?(request.request_method)
          return route, $~
        end
      end
      nil
    end
  end

  def initialize(request, method_name)
    @request  = request
    @method_name = method_name
    @response = Rack::Response.new
    instance_eval(&self.class.before_block)
  end

  def process!(args)
    body = self.send(@method_name, *args) || ''
    body = body.inspect unless body.is_a?(String)
    [@response.status, @response.header, [body].flatten]
  end
end
