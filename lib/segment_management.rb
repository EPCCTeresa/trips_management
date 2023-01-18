# frozen_string_literal: true
require "pry"
require 'time'
# Fetching and printing data
class SegmentManagement
  def initialize(entries)
    @entries = entries
  end

  def call
    sort_by_date		# We assume that the trips will not overlap so will start by sorting all the given segments by date
    sort_by_destination		# This method creates groups by destination detected, in each group we keep ascending order by date
    sort_destination_segments	# Within each group of destination, we need the stay segment to be after the segment that contains arrival information
  end

  def sort_by_date
    @entries = @entries.sort_by{|l| Time.parse(l)}
  end

  def sort_by_destination
    destination = ""
    result = {}
    visit = 0
    @entries.each_with_index do |entry, i|
      # Depending on if it is a connection trip in the same day or a roundtrip with stay, we compute destination
      new_destination = compute_destination(entry, @entries[i-1].presence, @entries[i+1].presence, i, result)
      new_destination = "Trip to " + new_destination
      if result[new_destination].nil?		# If result[new_destination] is nil, it means that we need a new group for incoming segments so we gonna initialize it
        result[new_destination] = []
      end
      result[new_destination].push(entry)	# Add segment to the collection
    end
    @result = result
  end

  def sort_destination_segments
    @result.each do |key, value|
      order_segments(value)
    end
   @result
  end

  # Since the segments containing stay info do not specify check-in times, we assume that you first need to arrive at the stay and then stay
  # This method stablishes order to take this into account and modifies the order accordingly to this assumption
  def order_segments(segments)
    pos = []
    i = 1
    # Get positions of segments that contains stays(We just consider "Hotel" as stay but it can be extended)
    segments.each_with_index{ |str,i| pos << i if str.start_with?("Hotel") }
    pos.each do |position|
      # The script accepts more than one stays in a roundtrip with stay within the same destination group.
      segments.insert(i, segments.delete_at(position))
      i = i+1
    end
  end

  def compute_destination(entry, prev_entry = "", next_entry = "", i, result)
    new_destination = entry.scan(/[A-Z][A-Z][A-Z]/).reject{|string| string == ENV['BASE']}
    destination = new_destination if new_destination != destination 			# Refreshes destination value
    is_connection = is_connection(prev_entry.presence, entry, next_entry.presence, i)
    # we assume that there are no more than two words that contain 3 consecutive capital letters
    # and that the target segment will not contain the base environment attribute
    new_destination = if is_connection == 2
                        # Takes the destination from the next entry.
                        # Here we assume that the destination is the second word of three consecutive capital letters
                        next_entry.scan(/[A-Z][A-Z][A-Z]/).second
                      elsif is_connection == 1
                        # Takes the destination from the current entry
                        # Here we assume that the destination is the second word of three consecutive capital letters
                        entry.scan(/[A-Z][A-Z][A-Z]/).second if is_connection == 1
                      else
                        # It is not a connection, so it takes the destination from the current entry
                        new_destination = new_destination.first
		                  end
    new_destination
  end

  # We consider there is a connection when there is a difference of less than 24 hours between two flights
  # is_connection method will return true in that case. If the other case occurs, it will return false
  def is_connection_segment?(entry1, entry2)
    return false if entry1.blank? || entry2.blank?
    return false if entry1.start_with?("Hotel") || entry2.start_with?("Hotel") 		# It is not a connection if one of the segments contains accomodation data

    # Here we determine if the time difference between two segments is less than 24 hours. If this is the case, it is considered to be a connection
    ((Time.parse(entry2) - Time.parse(entry1)) / 3600) < 24
  end

  def is_connection(prev_entry, entry, next_entry, index)
    return 2 if is_connection_segment?(entry, next_entry.presence)			# Return 2 if the connection happens between current segment and next one
    return 1 if is_connection_segment?(prev_entry.presence, entry)      		# Return 1 if the connection happens between current segment and previous one
    0
  end
end
