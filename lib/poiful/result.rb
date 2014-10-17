module Poiful
  class LineprofResult
    def self.parse(raw_result)
      raw_result.map do |file_path, r|
        next unless r.size > 1

        parse_result(file_path, r)
      end.compact
    end

    private
    def self.parse_result(file_path, result)
      file_result = nil
      begin
        file_result = FileResult.new(file_path, result.shift)
      rescue
        return nil
      end
      file_result.file_obj.each_line.with_index do |code, idx|
        file_result.rows << RowResult.new(file_path, idx+1, result[idx], code)
      end
      file_result.file_obj.close
      file_result
    end
  end

  class Result
    attr_reader :file

    def initialize(file_path)
      @file_path = file_path
      @file = File.basename(file_path)
    end

    def render(formatter)
      formatter.format(rows)
    end
  end

  class FileResult < Result
    attr_accessor :rows, :file_path, :total_wall_time, :total_cpu_time

    def initialize(file_path, profile)
      super(file_path)
      unless File.exist?(file_path)
        raise
      end
      @total_wall_time = profile[0] / 1000.0
      @child_wall_time = profile[1] / 1000.0
      @exclusive_wall_time = profile[2] / 1000.0
      @total_cpu_time = profile[3] / 1000.0
      @child_cpu_time = profile[4] / 1000.0
      @exclusive_cpu_time = profile[5] / 1000.0
      @total_allocated_bojects = profile[6] if profile.size == 7
      @rows = []
    end

    def file_obj
      @file_obj ||= File.open(@file_path)
    end
  end

  class RowResult < Result
    attr_reader :total_wall_time, :line, :calls, :code

    def initialize(file_path, line_number, profile, code)
      super(file_path)
      @line = line_number
      @total_wall_time = profile[0] / 1000.0
      @total_cpu_time = profile[1] / 1000.0
      @calls = profile[2]
      @total_allocated_objects = profile[3] if profile.size == 4
      @code = code
    end
  end
end
