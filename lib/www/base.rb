# encoding: utf-8
module Www
  class Base
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

        class_eval do
          alias_method :"www_#{name}", name
          define_method name do |*args|
            instance_eval(&self.class.before_block)
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
            path.match(route.pattern) && route.request_methods.include?(request_method) }, $~]
      end
    end

    def initialize(request = nil)
      @request = request
      @response = Rack::Response.new
    end
  end
end
