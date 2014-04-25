require 'mrb_parser/code_dump'

class MrbParser
  class IrepRecord

    IREP_TT_STRING = 0
    IREP_TT_FIXNUM = 1
    IREP_TT_FLOAT  = 2

    MRB_DUMP_NULL_SYM_LEN = 0xFFFF

    attr_accessor :debug_info
    attr_reader :recs
    attr_reader :syms
    attr_reader :pool

    def initialize
    end

    def parse_record(parser)
      @section_size = parser.read_uint32
      @nlocals = parser.read_uint16
      @nregs = parser.read_uint16
      rlen = parser.read_uint16
      parse_iseq(parser)
      parse_pool(parser)
      parse_symbol(parser)
      @recs = []
      rlen.times do |i|
        rec = IrepRecord.new()
        @recs[i] = rec.parse_record(parser)
      end
      self
    end

    def parse_iseq(parser)
      ilen = parser.read_uint32
      @iseq = []
      ilen.times do |i|
        @iseq << parser.read_uint32
      end
    end

    def parse_pool(parser)
      plen = parser.read_uint32
      @pool = []
      plen.times do |i|
        type = parser.read_uint8
        str = parser.read_n16string
        case type
        when IREP_TT_FIXNUM
          @pool[i] = Integer(str)
        when IREP_TT_FLOAT
          @pool[i] = Float(str)
        when IREP_TT_STRING
          @pool[i] = str
        else
          @pool[i] = nil
        end
      end
    end

    def parse_symbol(parser)
      slen = parser.read_uint32
      @syms = []
      slen.times do |i|
        len = parser.read_uint16
        if len == MRB_DUMP_NULL_SYM_LEN
          @syms[i] = nil
          next
        end
        @syms[i] = parser.read_chars(len)
        terminater = parser.read_uint8 ## skip NULL byte
      end
    end

    def printf_indent(n, *args)
      print " "*n
      printf *args
    end

    def dump(n = 2)
      code_dump = MrbParser::CodeDump.new(self)
      printf_indent n, "*** IREP RECORD ***\n"
      printf_indent n, "locals: %d\n", @nlocals
      printf_indent n, "regs  : %d\n", @nregs
      printf_indent n, "iseqs : %d\n", @iseq.size
      @iseq.each_with_index do |code, i|
        printf_indent n, "  code: %08x ", code
        code_dump.dump(code, i)
      end
      printf_indent n, "pools : %d\n", @pool.size
      @pool.each do |pool|
        printf_indent n, "  pool: %s\n", pool.inspect
      end
      printf_indent n, "syms  : %d\n", @syms.size
      @syms.each do |item|
        printf_indent n, "  sym: %s\n", item.inspect
      end
      printf_indent n, "ireps : %d\n", @recs.size
      @recs.each do |rec|
        rec.dump(n+2)
      end
      printf_indent n, "*** ***\n"
    end
  end
end

