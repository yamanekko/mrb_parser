require 'spec_helper'

describe MrbParser::CRC do
  describe ".calc_crc_16_ccitt" do
    it "takes valid CRC16 CCITT checksum" do
      data = "123456789"
      expect(MrbParser::CRC.calc_crc_16_ccitt(data,data.size,0)).to eq(48879)
    end
  end
end
