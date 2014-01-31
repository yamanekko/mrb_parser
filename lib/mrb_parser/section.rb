class MrbParser
  class Section

    require 'mrb_parser/irep_section'
    require 'mrb_parser/lineno_section'
    require 'mrb_parser/debug_section'
    require 'mrb_parser/end_section'

    BINARY_EOF        = "END\0"
    IREP_IDENTIFIER   = "IREP"
    LINENO_IDENTIFIER = "LINE"
    DEBUG_IDENTIFIER  = "DBG\0"

    attr_reader :signature, :size

    def initialize(signature = nil, size = nil)
      @signature = signature
      @size = size
    end

    def self.parse(parser)
      section = MrbParser::Section.new
      section.parse(parser)
    end

    def parse(parser)
      signature = parser.read_chars(4)
      size = parser.read_uint32
      case signature
      when IREP_IDENTIFIER
        section = MrbParser::IrepSection
      when LINENO_IDENTIFIER
        section = MrbParser::LinenoSection
      when DEBUG_IDENTIFIER
        section = MrbParser::DebugSection
      when BINARY_EOF
        section = MrbParser::EndSection
      else
        raise MrbParser::Error, "cannot parse; invalid section signature: '#{signature}'"
      end
      sec = section.new(signature, size)
      sec.parse_body(parser)
      sec
    end

    def end?
      false
    end

  end
end
