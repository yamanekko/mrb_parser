class MrbParser
  class LinenoSection < Section
    def initialize(*)
      super
    end

    def parse_body(parser, irep_record = nil)
      record_size = parser.read_uint32
      @filename = parser.read_n16string
      @niseq = parser.read_uint32
      @lines = []
      @niseq.times do |i|
        line = parser.read_uint16
        @lines << line
      end

      unless irep_record
        irep_record = parser.irep_section.rec
      end
      irep_record.debug_info = self

      irep_record.recs.each do |rec|
        parse_body(parser, rec)
      end
    end

    def dump
      printf "*** LINENO SECTION ***\n"
      printf "secID : %s\n", @signature
      printf "size  : %s\n", @size
      printf "*** ***\n"
    end

  end
end
