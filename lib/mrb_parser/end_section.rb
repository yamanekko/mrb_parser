class MrbParser
  class EndSection < Section
    def initialize(*)
      super
    end

    def parse_body(parser)
    end

    def end?
      true
    end

    def dump
      printf "*** END SECTION ***\n"
      printf "secID: %s\n", @signature
      printf "size : %s\n", @size
      printf "*** ***\n"
    end
  end
end
