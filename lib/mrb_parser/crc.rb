class MrbParser

  ##
  # calculate CRC
  #
  # an Ruby port of src/crc.c in mruby
  #
  class CRC

    CRC_16_CCITT = 0x11021  ## x^16+x^12+x^5+1
    CRC_XOR_PATTERN = (CRC_16_CCITT << 8)
    CRC_CARRY_BIT = 0x01000000
    CHAR_BIT = 8

    def self.calc_crc_16_ccitt(data0, nbytes, crc)
      data = data0.unpack("C*")
      crcwk = crc << 8
      for ibyte in 0...nbytes
        crcwk |= data[ibyte]
        for ibit in 0...CHAR_BIT
          crcwk <<= 1
          carry = crcwk & CRC_CARRY_BIT
          if carry.nonzero?
            crcwk ^= CRC_XOR_PATTERN
          end
        end
      end
      return crcwk >> 8
    end

  end
end
