require 'poiful/renderer'
require 'rblineprof'

module Poiful
  class << self
    @@profile_result = nil

    def start(&block)
      profile = lineprof(/./, &block)
      print Renderer.text(profile)
    end
  end
end

class_exist = begin
                klass = Module.const_get("RbLineProf")
                klass.is_a?(Class)
              rescue
                false
              end

if class_exist
  module Poiful
    class << self
      def begin
        RbLineProf.begin(/./)
      end

      def end
        @@profile_result = RbLineProf.end
        @@profile_result
      end

      def show
        print Renderer.text(@@profile_result)
      end

      def render_html
        Renderer.html(@@profile_result, "prof")
      end
    end
  end
end
