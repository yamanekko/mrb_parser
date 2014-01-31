require 'mrb_parser/header'
require 'mrb_parser/section'
require 'mrb_parser/error'
require "mrb_parser/version"
require "mrb_parser/utils"

class MrbParser
  include MrbParser::Utils

  attr_accessor :verbose
  attr_accessor :irep_section
  attr_reader :header, :sections

  def self.parse(filename)
    parser = MrbParser.new(filename)
    parser.parse
  end

  def initialize(filename)
    @filename = filename
    @data = nil
    @irep_section = nil
    @sections = []
  end

  def parse
    @data = File.open(@filename)
    @header = MrbParser::Header.parse(self)

    while true
      section = MrbParser::Section.parse(self)
      @sections << section
      break if section.end?
    end
  end

  def dump
    @header.dump
    @sections.each do |section|
      section.dump
    end
  end

end
