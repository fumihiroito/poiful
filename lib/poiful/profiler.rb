require 'poiful/renderer'
require 'rblineprof'

module Poiful
  class << self
    @@profile_result = nil

    def start(&block)
      start_html(&block)
    end

    def start_text(&block)
      profile = lineprof(/./, &block)
      print Renderer.text(profile)
    end

    def start_html(dir="prof", &block)
      profile = lineprof(/./, &block)
      Renderer.html(profile, dir)
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

      def end(render=true)
        @@profile_result = RbLineProf.end
        if render
          render_html
        end
        @@profile_result
      end

      def show
        print Renderer.text(@@profile_result)
      end

      def render_html(dir="prof")
        Renderer.html(@@profile_result, dir)
      end
    end
  end
end

begin
  klass = Module.const_get("LineProf")
rescue
  LineProf = Poiful
end
