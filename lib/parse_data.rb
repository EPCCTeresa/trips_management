# frozen_string_literal: true

require 'time'

# Reading a file and storing data
class ParseData
  def initialize(file)
    @file = file
  end

  def call
    parse_file_into_array
  end

  private

  attr_reader :file

  def parse_file_into_array
    array = []
    aux = []
    @file.each_line do |line|
      next if line.blank? || line.start_with?("#") || line.start_with?("\n")
      begin
        line.slice!("SEGMENT: ")
        array << line if Time.parse(line) 	# We just save the segments that contains parseable Time 
      rescue ArgumentError
      end 
    end
    array    
  end
end
