class MrbParser
  module Utils
    def read(n)
      @data.read(n)
    end

    def pos
      @data.pos
    end

    def seek(n)
      @data.seek(n)
    end

    def read_format(pat, n)
      byteseq = @data.read(n)
      val = byteseq.unpack(pat)[0]
      if @verbose
        p [@data, n, val]
      end
      val
    end

    def read_uint8
      read_format("C1", 1)
    end

    def read_uint16
      read_format("n1", 2)
    end

    def read_uint32
      read_format("N1", 4)
    end

    def read_chars(n)
      read_format("a#{n}", n)
    end

    def read_n16string
      len = read_uint16
      read_format("a#{len}", len)
    end
  end
end
