# encoding: utf-8
require 'tilt'

module Www
  module View
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def layout(layout)
        @layout = layout
      end

      def layout_path
        @layout || 'layout'
      end

      def view_dir(dir)
        @view_dir = dir
      end

      def view_dir_path
        @view_dir || '.'
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
      view_path = File.join(self.class.view_dir_path, "#{name}.#{type}")
      layout_path = "#{self.class.layout_path}.#{type}"

      if File.exists?(layout_path)
        Tilt.new(layout_path).render self, values do
          Tilt.new(view_path).render self, values
        end
      else
        Tilt.new(view_path).render self, values
      end
    end
  end
end
