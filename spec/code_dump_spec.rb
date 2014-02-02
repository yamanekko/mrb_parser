require 'spec_helper'

describe MrbParser::CodeDump do
  let(:irep) { double("irep_record") }
  let(:dump) { MrbParser::CodeDump.new(irep) }

  describe "#opcode" do
    subject { dump.opcode(0x00c00003) }
    it { should == MrbParser::CodeDump::OP_LOADI }
  end

  describe "#dump" do
    it "get OP_LOADI from code 0x00c00003" do
      tmp = $stdout
      out = StringIO.new
      $stdout = out
      dump.dump(0x00c00003, 1)
      $stdout = tmp
      expect(out.string).to eq "001 OP_LOADI\tR1\t1\n"
    end
  end


end

