require 'mrb_parser/debug_info'
require 'mrb_parser/debug_info_file'

class MrbParser
  class DebugSection < Section

    attr_accessor :debug_info
    attr_accessor :filenames

    def initialize(*)
      super
    end

    def parse_record(parser)
      rec = parser.irep_section.rec
      @debug_info = MrbParser::DebugInfo.new(self, rec)
      @debug_info.parse_record(parser)
    end

    def parse_body(parser)
      filenames_len = parser.read_uint16
      @filenames = []
      filenames_len.times do
        @filenames << parser.read_n16string
      end
      parse_record(parser)
      self
    end

    def dump
      printf "*** DEBUG SECTION ***\n"
      printf "secID: %s\n", @signature
      printf "size : %s\n", @size
      printf "files: %d\n", @filenames.size
      @filenames.each do |fname|
        printf "  filename: %s\n", fname
      end
      @debug_info.dump
      printf "*** ***\n"
    end

  end
end
