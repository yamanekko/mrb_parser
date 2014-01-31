require 'mrb_parser/crc'
class MrbParser
  class Header

    attr_reader :signature, :version, :crc, :size,
                :compiler_name, :compiler_version

    def self.parse(parser)
      header = Header.new()
      header.parse(parser)
    end

    def initialize
    end

    def parse(parser)
      @signature = parser.read_chars(4)
      @version = parser.read_chars(4)
      @crc = parser.read_uint16
      @crc_verified = check_crc(parser)
      @size = parser.read_uint32
      @compiler_name = parser.read_chars(4)
      @compiler_version = parser.read_chars(4)

      if parser.verbose
        if !valid?
          STDERR.print "** [WARN] This header seems to be invalid. **\n"
        end
      end

      self
    end

    def check_crc(parser)
      pos = parser.pos
      rest_data = parser.read(nil)
      parser.seek(pos)
      checksum = MrbParser::CRC.calc_crc_16_ccitt(rest_data, rest_data.size, 0)
      @crc == checksum
    end


    def valid?
      @signature == "RITE" && @version == "0002" && @crc_verified
    end

    def dump
      printf "*** BINARY HEADER ***\n"
      printf "secID: %s\n", @signature
      printf "ver  : %s\n", @version
      printf "crc  : 0x%04x (%s)\n", @crc, @crc_verified
      printf "size : 0x%08x\n", @size
      printf "compiler:\n"
      printf "  name: %s\n", @compiler_name
      printf "  ver : %s\n", @compiler_version
      printf "*** ***\n"
    end
  end
end
