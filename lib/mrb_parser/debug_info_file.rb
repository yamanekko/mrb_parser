class MrbParser
  class DebugInfoFile
    attr_accessor :start_pos
    attr_accessor :filename
    attr_accessor :line_entry_count
    attr_accessor :line_type

    attr_accessor :line_flat_map
    attr_accessor :line_ary

    def initialize
    end

    def printf_indent(n, *args)
      print " "*n
      printf *args
    end

    def dump(n = 2)
      printf_indent n, "*** DEBUG INFO FILE ***\n"
      printf_indent n, "start: %d\n", @start_pos
      printf_indent n, "fname: %s\n", @filename
      printf_indent n, "line type: %d (%s)\n", @line_type,
                                               MrbParser::DebugInfo::LINE_TYPE[@line_type]
      printf_indent n, "lines: %d\n", @line_entry_count
      case @line_type
      when MrbParser::DebugInfo::MRB_DEBUG_LINE_ARY
        @line_ary.each do |line|
          printf_indent n, "  line: %d\n", line
        end
      when MrbParser::DebugInfo::MRB_DEBUG_LINE_FLAT_MAP
        @line_flat_map.each do |map|
          printf_indent n, "  line: %d, start_pos: %d\n", map[:line], map[:start_pos]
        end
      end

      printf_indent n, "*** ***\n"
    end
  end
end
