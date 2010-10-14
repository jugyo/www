# encoding: utf-8
module Www
  class Route
    attr_accessor :pattern, :request_methods, :name, :clazz
    def initialize(pattern, request_methods, clazz)
      @pattern = "^#{pattern}$"
      @request_methods = [request_methods].flatten.map { |m| m.to_s.upcase }
      @clazz = clazz
    end

    def inspect
      "#<#{self.class}: #{pattern}, [#{request_methods.join(',')}] => #{clazz}##{name} >"
    end
    alias_method :to_s, :inspect
  end
end
