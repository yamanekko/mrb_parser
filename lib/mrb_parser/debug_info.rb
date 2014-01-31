class MrbParser
  class DebugInfo

    MRB_DEBUG_LINE_ARY  = 0
    MRB_DEBUG_LINE_FLAT_MAP = 1

    LINE_TYPE = ["ARY", "FLAT_MAP"]

    attr_accessor :pc_count
    attr_accessor :files
    attr_accessor :debug_section
    attr_accessor :irep_record
    attr_reader :infos

    def initialize(debug_section, irep_record)
      @debug_section = debug_section
      @irep_record = irep_record
      irep_record.debug_info = self
      @infos = []
    end

    def parse_record(parser)
      @pc_count = parser.read_uint32
      flen = parser.read_uint16
      @files = []
      flen.times do
        file = DebugInfoFile.new
        @files << file
        file.start_pos = parser.read_uint32
        filename_idx = parser.read_uint16
        file.filename = @debug_section.filenames[filename_idx]

        file.line_entry_count = parser.read_uint32
        file.line_type = parser.read_uint8
        case file.line_type
        when MRB_DEBUG_LINE_ARY ## 0
          file.line_ary = []
          file.line_entry_count.times do
            file.line_ary << parser.read_uint16
          end
        when MRB_DEBUG_LINE_FLAT_MAP ## 1
          file.line_flat_map = []
          file.line_entry_count.times do
            start_pos = parser.read_uint32
            line = parser.read_uint16
            file.line_flat_map << {start_pos: start_pos, line: line}
          end
        else
          raise
        end
      end
      @irep_record.recs.each do |irep_record|
        info = MrbParser::DebugInfo.new(@debug_section, irep_record)
        @infos << info
        info.parse_record(parser)
      end
      self
    end

    def printf_indent(n, *args)
      print " "*n
      printf *args
    end

    def dump(n = 2)
      printf_indent n, "*** DEBUG INFO ***\n"
      printf_indent n, "count: %d\n", @pc_count
      printf_indent n, "files: %d\n", @files.size
      @files.map{|file| file.dump(n+2)}
      @infos.each do |debug_info|
        debug_info.dump(n + 2)
      end
      printf_indent n, "*** ***\n"
    end
  end
end
