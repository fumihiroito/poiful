require 'poiful/result'
require 'poiful/formatter'
require 'erb'

module Poiful
  class Renderer
    def self.text(result)
      buf = ""

      parsed_result = LineprofResult.parse(result)
      parsed_result.each do |r|
        buf += "#{r.file_path}\n"
        buf += r.render(TextFormatter.new(r))
        buf += "\n"
      end
      buf
    end

    def self.html(result, directory)
      FileUtils.mkdir_p(directory) unless FileTest.exist?(directory)

      results = LineprofResult.parse(result)
      results.each do |r|
        r.render(HTMLFormatter.new(directory, r.file_path))
      end

      buf = ERB.new(open("#{File.dirname(__FILE__)}/../../views/html/index.html.erb").read).result(binding)
      File.open("#{directory}/index.html", "w") do |f|
        f.write(buf)
      end

      FileUtils.cp_r("#{File.dirname(__FILE__)}/../../assets", "#{directory}/")
    end
  end
end
