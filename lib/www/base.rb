# encoding: utf-8
module Www
  class Base
    include View

    class << self
      @@current_route = nil
      @@routes = []

      def routes
        @@routes
      end

      def route(pattern, methods = [:get])
        @@current_route = Route.new(pattern, methods, self)
      end
      alias_method :_, :route

      def get(pattern)    _(pattern, :get)    end
      def post(pattern)   _(pattern, :post)   end
      def put(pattern)    _(pattern, :put)    end
      def delete(pattern) _(pattern, :delete) end

      def before(*route_names, &block)
        before_blocks << [route_names.map{ |i| i.to_sym }, block]
      end

      def before_blocks
        @before_blocks ||= []
      end

      def method_added(name)
        return unless @@current_route
        @@current_route.name = name
        @@routes << @@current_route
        @@current_route = nil

        class_eval do
          alias_method :"www_#{name}", name
          define_method name do |*args|
            self.class.before_blocks.each do |route_names, block|
              if route_names.empty? || route_names.include?(name)
                instance_eval(&block)
              end
            end

            @route_name = name
            body = send(:"www_#{name}", *args) || ''
            body = body.inspect unless body.is_a?(String)
            [@response.status, @response.header, [body].flatten]
          end
        end
      end

      def error(code)
        [code, {"Content-Type" => "text/html"}, []]
      end

      def find_route(path, request_method)
        [@@routes.detect { |route|
            path.match(route.pattern) && route.request_methods.include?(request_method.downcase.to_sym) }, $~]
      end

      def call(env)
        request = Rack::Request.new(env)
        route, match = find_route(request.path_info, request.request_method)
        if route
          handler = route.clazz.new(request)
          args = match[1..-1] << request.params
          args = adjust_args_for(args, handler.method(:"www_#{route.name}").arity)
          # puts "#{route.clazz}##{route.name}(#{args.map{|i| "'#{i}'"}.join(', ')})"
          handler.send(route.name, *args)
        else
          error 404
        end
      end

      def adjust_args_for(args, arity)
        args = args[0, arity] if arity >= 0
      end
    end

    def initialize(request = nil)
      # TODO: @_ で始まるようにした方がいいかもしれない
      @request = request
      @response = Rack::Response.new
    end
  end
end
