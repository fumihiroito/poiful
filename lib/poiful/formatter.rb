require 'erb'

module Poiful
  class TextFormatter
    attr_accessor :result, :time_length, :calls_length, :ln_length

    def initialize(result)
      time_length = "time".length
      calls_length = "calls".length
      ln_length = "line number".length

      result.rows.each do |line|
        if time_length < line.total_wall_time.floor.to_s.length + 4
          time_length = line.total_wall_time.floor.to_s.length + 4
        end
        if calls_length < line.calls.to_s.length
          calls_length
        end
      end
      ln_length = (result.rows.size+1).to_s.length

      @time_length = time_length
      @calls_length = calls_length
      @ln_length = ln_length
    end

    def format(result)
      buf = ""
      buf += header
      result.each do |line|
        buf += render_line(line)
      end
      buf
    end

    def header
      [
        "time".rjust(time_length),
        "calls".rjust(calls_length),
      ].join(" | ") + " | \n"
    end

    def render_line(row)
      "%#{time_length-2}.1fms | %#{calls_length}d | %#{ln_length}d  %s" % [row.total_wall_time, row.calls, row.line, row.code]
    end
  end

  class HTMLFormatter
    def initialize(directory, filename)
      @directory = directory
      @filename = filename
    end

    def format(result)
      @lines = result
      buf = ERB.new(open("#{File.dirname(__FILE__)}/../../views/html/file.html.erb").read).result(binding)
      File.open("#{@directory}/#{@filename.gsub(/\//, "_")}.html", "w") do |f|
        f.write(buf)
      end
    end
  end
end
