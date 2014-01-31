require 'mrb_parser/irep_record'
class MrbParser
  class IrepSection < Section

    attr_reader :rec

    def initialize(*)
      super
    end

    def parse_body(parser)
      @vm_version = parser.read_chars(4)
      @rec = parse_record(parser)
      parser.irep_section = self
      self
    end

    def parse_record(parser)
      rec = MrbParser::IrepRecord.new
      rec.parse_record(parser)
      rec
    end

    def dump
      printf "*** IREP SECTION ***\n"
      printf "secID : %s\n", @signature
      printf "size  : %s\n", @size
      printf "vm ver: %s\n", @vm_version
      @rec.dump
      printf "*** ***\n"
    end

  end
end
