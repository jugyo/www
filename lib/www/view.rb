# encoding: utf-8
require 'tilt'

module Www
  module View
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      @@view_dir = 'views'

      def view_dir(dir)
        @view_dir = dir
      end

      def view_dir_path
        @view_dir || @@view_dir
      end
    end

    Tilt.mappings.keys.map { |key| key.to_sym }.each do |name|
      define_method(name) do |*args|
        render name, *args
      end
    end

    def render(type, *args)
      name = args[0].is_a?(String) ? args.shift : @route_name
      values = args[0]
      path = File.join(self.class.view_dir_path, "#{name}.#{type}")
      template = Tilt.new(path)
      template.render self, values # TODO: helper class instead of Object.new
    end
  end
end
