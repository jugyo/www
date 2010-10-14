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

    def haml(*args)
      name = args[0].is_a?(String) ? args.shift : @route_name
      values = args[0]
      path = File.join(self.class.view_dir_path, "#{name}.haml")
      template = Tilt.new(path)
      template.render self, values # TODO: helper class instead of Object.new
    end
  end
end
