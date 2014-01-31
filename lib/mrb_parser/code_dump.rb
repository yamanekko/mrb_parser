class MrbParser
  class CodeDump

    MAXARG_Bx = 0xffff
    MAXARG_sBx = (MAXARG_Bx>>1)    ## `sBx' is signed

    OP_NOP   = 0     # /*                                                             */
    OP_MOVE  = 1     # /*      A B     R(A) := R(B)                                    */
    OP_LOADL = 2     # /*     A Bx    R(A) := Lit(Bx)                                 */
    OP_LOADI = 3     # /*     A sBx   R(A) := sBx                                     */
    OP_LOADSYM = 4   # /*   A Bx    R(A) := Sym(Bx)                                 */
    OP_LOADNIL = 5   # /*   A       R(A) := nil                                     */
    OP_LOADSELF = 6  # /*  A       R(A) := self                                    */
    OP_LOADT = 7     # /*     A       R(A) := true                                    */
    OP_LOADF = 8     # /*     A       R(A) := false                                   */

    OP_GETGLOBAL = 9 # /* A Bx    R(A) := getglobal(Sym(Bx))                      */
    OP_SETGLOBAL =10 # /* A Bx    setglobal(Sym(Bx), R(A))                        */
    OP_GETSPECIAL=11 # /*A Bx    R(A) := Special[Bx]                             */
    OP_SETSPECIAL=12 # /*A Bx    Special[Bx] := R(A)                             */
    OP_GETIV = 13    # /*     A Bx    R(A) := ivget(Sym(Bx))                          */
    OP_SETIV = 14    # /*     A Bx    ivset(Sym(Bx),R(A))                             */
    OP_GETCV = 15    # /*     A Bx    R(A) := cvget(Sym(Bx))                          */
    OP_SETCV = 16    # /*     A Bx    cvset(Sym(Bx),R(A))                             */
    OP_GETCONST = 17 # /*  A Bx    R(A) := constget(Sym(Bx))                       */
    OP_SETCONST = 18 # /*  A Bx    constset(Sym(Bx),R(A))                          */
    OP_GETMCNST = 19 # /*  A Bx    R(A) := R(A)::Sym(B)                            */
    OP_SETMCNST = 20 # /*  A Bx    R(A+1)::Sym(B) := R(A)                          */
    OP_GETUPVAR = 21 # /*  A B C   R(A) := uvget(B,C)                              */
    OP_SETUPVAR = 22 # /*  A B C   uvset(B,C,R(A))                                 */

    OP_JMP = 23      # /*       sBx     pc+=sBx                                         */
    OP_JMPIF = 24    # /*     A sBx   if R(A) pc+=sBx                                 */
    OP_JMPNOT = 25   # /*    A sBx   if !R(A) pc+=sBx                                */
    OP_ONERR = 26    # /*     sBx     rescue_push(pc+sBx)                             */
    OP_RESCUE = 27   # /*    A       clear(exc); R(A) := exception (ignore when A=0) */
    OP_POPERR = 28   # /*    A       A.times{rescue_pop()}                           */
    OP_RAISE = 29    # /*     A       raise(R(A))                                     */
    OP_EPUSH = 30    # /*     Bx      ensure_push(SEQ[Bx])                            */
    OP_EPOP = 31     # /*      A       A.times{ensure_pop().call}                      */

    OP_SEND = 32     # /*      A B C   R(A) := call(R(A),mSym(B),R(A+1),...,R(A+C))    */
    OP_SENDB = 33    # /*     A B C   R(A) := call(R(A),mSym(B),R(A+1),...,R(A+C),&R(A+C+1))*/
    OP_FSEND = 34    # /*     A B C   R(A) := fcall(R(A),mSym(B),R(A+1),...,R(A+C-1)) */
    OP_CALL = 35     # /*      A B C   R(A) := self.call(R(A),.., R(A+C))              */
    OP_SUPER = 36    # /*     A B C   R(A) := super(R(A+1),... ,R(A+C-1))             */
    OP_ARGARY = 37   # /*    A Bx    R(A) := argument array (16=6:1:5:4)             */
    OP_ENTER = 38    # /*     Ax      arg setup according to flags (24=5:5:1:5:5:1:1) */
    OP_KARG = 39     # /*      A B C   R(A) := kdict[mSym(B)]; if C kdict.rm(mSym(B))  */
    OP_KDICT = 40    # /*     A C     R(A) := kdict                                   */

    OP_RETURN = 41   # /*    A B     return R(A) (B=normal,in-block return/break)    */
    OP_TAILCALL = 42 # /*  A B C   return call(R(A),mSym(B),*R(C))                 */
    OP_BLKPUSH = 43  # /*   A Bx    R(A) := block (16=6:1:5:4)                      */

    OP_ADD = 44      # /*       A B C   R(A) := R(A)+R(A+1) (mSyms[B]=:+,C=1)           */
    OP_ADDI = 45     # /*      A B C   R(A) := R(A)+C (mSyms[B]=:+)                    */
    OP_SUB = 46      # /*       A B C   R(A) := R(A)-R(A+1) (mSyms[B]=:-,C=1)           */
    OP_SUBI = 47     # /*      A B C   R(A) := R(A)-C (mSyms[B]=:-)                    */
    OP_MUL = 48      # /*       A B C   R(A) := R(A)*R(A+1) (mSyms[B]=:*,C=1)           */
    OP_DIV = 49      # /*       A B C   R(A) := R(A)/R(A+1) (mSyms[B]=:/,C=1)           */
    OP_EQ = 50       # /*        A B C   R(A) := R(A)==R(A+1) (mSyms[B]=:==,C=1)         */
    OP_LT = 51       # /*        A B C   R(A) := R(A)<R(A+1)  (mSyms[B]=:<,C=1)          */
    OP_LE = 52       # /*        A B C   R(A) := R(A)<=R(A+1) (mSyms[B]=:<=,C=1)         */
    OP_GT = 53       # /*        A B C   R(A) := R(A)>R(A+1)  (mSyms[B]=:>,C=1)          */
    OP_GE = 54       # /*        A B C   R(A) := R(A)>=R(A+1) (mSyms[B]=:>=,C=1)         */

    OP_ARRAY = 55    # /*     A B C   R(A) := ary_new(R(B),R(B+1)..R(B+C))            */
    OP_ARYCAT = 56   # /*    A B     ary_cat(R(A),R(B))                              */
    OP_ARYPUSH = 57  # /*   A B     ary_push(R(A),R(B))                             */
    OP_AREF = 58     # /*      A B C   R(A) := R(B)[C]                                 */
    OP_ASET = 59     # /*      A B C   R(B)[C] := R(A)                                 */
    OP_APOST = 60    # /*     A B C   *R(A),R(A+1)..R(A+C) := R(A)                    */

    OP_STRING = 61   # /*    A Bx    R(A) := str_dup(Lit(Bx))                        */
    OP_STRCAT = 62   # /*    A B     str_cat(R(A),R(B))                              */

    OP_HASH = 63     # /*      A B C   R(A) := hash_new(R(B),R(B+1)..R(B+C))           */
    OP_LAMBDA = 64   # /*    A Bz Cz R(A) := lambda(SEQ[Bz],Cm)                      */
    OP_RANGE = 65    # /*     A B C   R(A) := range_new(R(B),R(B+1),C)                */

    OP_OCLASS = 66   # /*    A       R(A) := ::Object                                */
    OP_CLASS = 67    # /*     A B     R(A) := newclass(R(A),mSym(B),R(A+1))           */
    OP_MODULE = 68   # /*    A B     R(A) := newmodule(R(A),mSym(B))                 */
    OP_EXEC = 69     # /*      A Bx    R(A) := blockexec(R(A),SEQ[Bx])                 */
    OP_METHOD = 70   # /*    A B     R(A).newmethod(mSym(B),R(A+1))                  */
    OP_SCLASS = 71   # /*    A B     R(A) := R(B).singleton_class                    */
    OP_TCLASS = 72   # /*    A       R(A) := target_class                            */

    OP_DEBUG = 73    # /*     A       print R(A)                                      */
    OP_STOP = 74     # /*              stop VM                                         */
    OP_ERR = 75      # /*       Bx      raise RuntimeError with message Lit(Bx)         */

    OP_RSVD1 = 76    # /*             reserved instruction #1                         */
    OP_RSVD2 = 77    # /*             reserved instruction #2                         */
    OP_RSVD3 = 78    # /*             reserved instruction #3                         */
    OP_RSVD4 = 79    # /*             reserved instruction #4                         */
    OP_RSVD5 = 80    # /*             reserved instruction #5                         */


    OP_R_NORMAL = 0
    OP_R_BREAK  = 1
    OP_R_RETURN = 2

    # instructions: packed 32 bit
    # -------------------------------
    #   A:B:C:OP = 9: 9: 7: 7
    #    A:Bx:OP =    9:16: 7
    #      Ax:OP =      25: 7
    # A:Bz:Cz:OP = 9:14: 2: 7

    def initialize(irep)
      @irep = irep
    end

    def opcode(code)
      code & 0x7F
    end

    def getarg_a(code)
      (code >> 23) & 0x1ff
    end

    def getarg_b(code)
      (code >> 14) & 0x1ff
    end

    def getarg_c(code)
      (code >> 7) & 0x7f
    end

    def getarg_bx(code)
      (code >> 7) & 0xffff
    end

    def getarg_sbx(code)
      getarg_bx(code) - MAXARG_sBx
    end

    def getarg_ax(code)
      (code >> 7) & 0x1ffffff
    end

    def getarg_unpack_b(code, n1, n2)
      (code >> (7 + n2)) & ((1 << n1)-1)
    end

    def getarg_unpack_c(code, n1, n2)
      (code >> 7) & ((1 << n2)-1)
    end

    def getarg_b2(code)
      getarg_unpack_b(code, 14, 2)
    end

    def getarg_c2(code)
      getarg_unpack_c(code, 14, 2)
    end


    def dump(c, i)
      printf("%03d ", i)
      op = opcode(c)
      case op
      when OP_NOP
        printf("OP_NOP\n")
      when OP_MOVE
        printf("OP_MOVE\tR%d\tR%d\n", getarg_a(c), getarg_b(c))
      when OP_LOADL
        printf("OP_LOADL\tR%d\tL(%d)\n", getarg_a(c), getarg_bx(c))
      when OP_LOADI
        printf("OP_LOADI\tR%d\t%d\n", getarg_a(c), getarg_sbx(c))
      when OP_LOADSYM
        printf("OP_LOADSYM\tR%d\t:%s\n", getarg_a(c),
               @irep.syms[getarg_bx(c)])
      when OP_LOADNIL
        printf("OP_LOADNIL\tR%d\n", getarg_a(c))
      when OP_LOADSELF
        printf("OP_LOADSELF\tR%d\n", getarg_a(c))
      when OP_LOADT
        printf("OP_LOADT\tR%d\n", getarg_a(c))
      when OP_LOADF
        printf("OP_LOADF\tR%d\n", getarg_a(c))
      when OP_GETGLOBAL
        printf("OP_GETGLOBAL\tR%d\t:%s\n", getarg_a(c),
               @irep.syms[getarg_bx(c)])
      when OP_SETGLOBAL
        printf("OP_SETGLOBAL\t:%s\tR%d\n",
               @irep.syms[getarg_bx(c)],
               getarg_a(c))
      when OP_GETCONST
        printf("OP_GETCONST\tR%d\t:%s\n", getarg_a(c),
               @irep.syms[getarg_bx(c)])
      when OP_SETCONST
        printf("OP_SETCONST\t:%s\tR%d\n",
               @irep.syms[getarg_bx(c)],
               getarg_a(c))
      when OP_GETMCNST
        printf("OP_GETMCNST\tR%d\tR%d::%s\n", getarg_a(c), getarg_a(c),
               @irep.syms[getarg_bx(c)])
      when OP_SETMCNST
        printf("OP_SETMCNST\tR%d::%s\tR%d\n", getarg_a(c)+1,
               @irep.syms[getarg_bx(c)],
               getarg_a(c))
      when OP_GETIV
        printf("OP_GETIV\tR%d\t%s\n", getarg_a(c),
               @irep.syms[getarg_bx(c)])
      when OP_SETIV
        printf("OP_SETIV\t%s\tR%d\n",
               @irep.syms[getarg_bx(c)],
               getarg_a(c))
      when OP_GETUPVAR
        printf("OP_GETUPVAR\tR%d\t%d\t%d\n",
               getarg_a(c), getarg_b(c), getarg_c(c))
      when OP_SETUPVAR
        printf("OP_SETUPVAR\tR%d\t%d\t%d\n",
               getarg_a(c), getarg_b(c), getarg_c(c))
      when OP_GETCV
        printf("OP_GETCV\tR%d\t%s\n", getarg_a(c),
               @irep.syms[getarg_bx(c)])
      when OP_SETCV
        printf("OP_SETCV\t%s\tR%d\n",
               @irep.syms[getarg_bx(c)],
               getarg_a(c))
      when OP_JMP
        printf("OP_JMP\t\t%03d\n", i+getarg_sbx(c))
      when OP_JMPIF
        printf("OP_JMPIF\tR%d\t%03d\n", getarg_a(c), i+getarg_sbx(c))
      when OP_JMPNOT
        printf("OP_JMPNOT\tR%d\t%03d\n", getarg_a(c), i+getarg_sbx(c));
      when OP_SEND
        printf("OP_SEND\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_SENDB
        printf("OP_SENDB\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_TAILCALL
        printf("OP_TAILCALL\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_SUPER
        printf("OP_SUPER\tR%d\t%d\n", getarg_a(c),
               getarg_c(c))
      when OP_ARGARY
        printf("OP_ARGARY\tR%d\t%d:%d:%d:%d\n", getarg_a(c),
               (getarg_bx(c)>>10)&0x3f,
               (getarg_bx(c)>>9)&0x1,
               (getarg_bx(c)>>4)&0x1f,
               (getarg_bx(c)>>0)&0xf)

      when OP_ENTER
        printf("OP_ENTER\t%d:%d:%d:%d:%d:%d:%d\n",
               (getarg_ax(c)>>18)&0x1f,
               (getarg_ax(c)>>13)&0x1f,
               (getarg_ax(c)>>12)&0x1,
               (getarg_ax(c)>>7)&0x1f,
               (getarg_ax(c)>>2)&0x1f,
               (getarg_ax(c)>>1)&0x1,
               getarg_ax(c) & 0x1)
      when OP_RETURN
        printf("OP_RETURN\tR%d", getarg_a(c))
        case getarg_b(c)
        when OP_R_NORMAL
          printf("\n")
        when OP_R_RETURN
          printf("\treturn\n")
        when OP_R_BREAK
          printf("\tbreak\n")
        else
          printf("\tbroken\n")
        end
      when OP_BLKPUSH
        printf("OP_BLKPUSH\tR%d\t%d:%d:%d:%d\n", getarg_a(c),
               (getarg_bx(c)>>10)&0x3f,
               (getarg_bx(c)>>9)&0x1,
               (getarg_bx(c)>>4)&0x1f,
               (getarg_bx(c)>>0)&0xf)

      when OP_LAMBDA
        printf("OP_LAMBDA\tR%d\tI(%+d)\t%d\n", getarg_a(c), getarg_b2(c), getarg_c2(c))
      when OP_RANGE
        printf("OP_RANGE\tR%d\tR%d\t%d\n", getarg_a(c), getarg_b(c), getarg_c(c))
      when OP_METHOD
        printf("OP_METHOD\tR%d\t:%s\n", getarg_a(c),
               @irep.syms[getarg_b(c)])

      when OP_ADD
        printf("OP_ADD\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_ADDI
        printf("OP_ADDI\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_SUB
        printf("OP_SUB\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_SUBI
        printf("OP_SUBI\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_MUL
        printf("OP_MUL\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_DIV
        printf("OP_DIV\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_LT
        printf("OP_LT\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_LE
        printf("OP_LE\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_GT
        printf("OP_GT\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_GE
        printf("OP_GE\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))
      when OP_EQ
        printf("OP_EQ\tR%d\t:%s\t%d\n", getarg_a(c),
               @irep.syms[getarg_b(c)],
               getarg_c(c))

      when OP_STOP
        printf("OP_STOP\n")

      when OP_ARRAY
        printf("OP_ARRAY\tR%d\tR%d\t%d\n", getarg_a(c), getarg_b(c), getarg_c(c))
      when OP_ARYCAT
        printf("OP_ARYCAT\tR%d\tR%d\n", getarg_a(c), getarg_b(c))
      when OP_ARYPUSH
        printf("OP_ARYPUSH\tR%d\tR%d\n", getarg_a(c), getarg_b(c))
      when OP_AREF
        printf("OP_AREF\tR%d\tR%d\t%d\n", getarg_a(c), getarg_b(c), getarg_c(c))
      when OP_APOST
        printf("OP_APOST\tR%d\t%d\t%d\n", getarg_a(c), getarg_b(c), getarg_c(c))
      when OP_STRING
        s = @irep.pool[getarg_bx(c)]
        printf("OP_STRING\tR%d\t%s\n", getarg_a(c), s)
      when OP_STRCAT
        printf("OP_STRCAT\tR%d\tR%d\n", getarg_a(c), getarg_b(c))
      when OP_HASH
        printf("OP_HASH\tR%d\tR%d\t%d\n", getarg_a(c), getarg_b(c), getarg_c(c))

      when OP_OCLASS
        printf("OP_OCLASS\tR%d\n", getarg_a(c))
      when OP_CLASS
        printf("OP_cLASS\tR%d\t:%s\n", getarg_a(c),
               @irep.syms[getarg_b(c)])
      when OP_MODULE
        printf("OP_MODULE\tR%d\t:%s\n", getarg_a(c),
               @irep.syms[getarg_b(c)])
      when OP_EXEC
        printf("OP_EXEC\tR%d\tI(%+d)\n", getarg_a(c), getarg_bx(c))
      when OP_SCLASS
        printf("OP_SCLASS\tR%d\tR%d\n", getarg_a(c), getarg_b(c))
      when OP_TCLASS
        printf("OP_TCLASS\tR%d\n", getarg_a(c))
      when OP_ERR
        printf("OP_ERR\tL(%d)\n", getarg_bx(c))
      when OP_EPUSH
        printf("OP_EPUSH\t:I(%+d)\n", getarg_bx(c))
      when OP_ONERR
        printf("OP_ONERR\t%03d\n", i+getarg_sbx(c))
      when OP_RESCUE
        printf("OP_RESCUE\tR%d\n", getarg_a(c))
      when OP_RAISE
        printf("OP_RAISE\tR%d\n", getarg_a(c))
      when OP_POPERR
        printf("OP_POPERR\t%d\n", getarg_a(c))
      when OP_EPOP
        printf("OP_EPOP\t%d\n", getarg_a(c))
      else
        printf("OP_unknown %d\t%d\t%d\t%d\n", opcode(c),
               getarg_a(c), getarg_b(c), getarg_c(c))
      end
    end

  end
end
