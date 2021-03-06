module ErbAsterisk
  module Yields
    # Apply line to place where yield_here :tag defined
    def apply_line_to(tag, line, args = {})
      default_args!(args)
      apply_to_yields(tag, line, args[:priority])

      log_debug("apply_line_to: :#{tag}, #{line}, #{args}", 2)
      "; Applied \"#{line}\" to :#{tag}"
    end

    # Apply block to yield_here
    def content_for(tag, args = {})
      default_args!(args)
      old_output = @erb_output
      @erb_output = ''

      apply_to_yields(tag, yield, args[:priority])

      log_debug("content_for: :#{tag}, #{args}", 2)
      @erb_output = old_output
    end

    # Define place where put apply_line_to
    def yield_here(tag)
      @yield_here_occured = true
      "<%= yield_actual :#{tag} %>"
    end

    def yield_actual(tag)
      "; Yield for :#{tag}\n" << output_yield(tag)
    end

    private

    def apply_to_yields(tag, content, priority)
      @yields[tag] = [] if @yields[tag].nil?
      @yields[tag] << { content: content, priority: priority }
    end

    def output_yield(tag)
      a = @yields[tag]

      log_debug("yield_here: :#{tag}, size=#{a.size}", 2)

      a = a.sort_by { |i| -i[:priority] }
      result = a.reduce('') do |s, i|
        s << "; priority: #{i[:priority]}\n" if i[:priority] != 0
        s << "#{i[:content]}\n"
      end

      result
    end
  end
end
