# encoding: utf-8
class Www
  class Route
    attr_accessor :pattern, :request_methods, :name, :clazz
    def initialize(pattern, request_methods, clazz)
      case pattern
      when Regexp then @pattern = /^#{pattern}$/
      when String then @pattern = /^#{Regexp.quote(pattern)}$/
      else
        raise 'pattern must be Regexp or String'
      end
      @request_methods = [request_methods].flatten.map { |m| m.to_s.upcase }
      @clazz = clazz
    end

    def to_s
      inspect
    end

    def inspect
      "#<#{self.class}: #{pattern}, [#{request_methods.join(',')}] => #{clazz}##{name} >"
    end
  end
end
