# frozen_string_literal: true
#!/usr/bin/env ruby

require 'FlightXML2RESTDriver'
require 'json'
require_relative '../support/import_file'

return if !ENV['FLIGHTAWARE_KEY'] || !ENV['FLIGHTAWARE_USER']

def client
  @client ||= begin
    FlightXML2REST.new(ENV['FLIGHTAWARE_USER'], ENV['FLIGHTAWARE_KEY'])
  end
end

def sanitize_timestamp(timestamp)
  Time.at(timestamp).getlocal.iso8601
end

def sanitize(raw_points, id)
  points = raw_points.map do |point|
    {
      altitude: point.altitude * 100,
      altitudeChange: point.altitudeChange,
      groundspeed: point.groundspeed,
      latitude: point.latitude,
      longitude: point.longitude,
      timestamp: sanitize_timestamp(point.timestamp),
      updateType: point.updateType,
    }.freeze
  end

  {
    points: points,
    startTime: sanitize_timestamp(raw_points.first.timestamp),
    endTime: sanitize_timestamp(raw_points.last.timestamp),
  }.freeze
end

data_directory = "#{ENV.fetch("HISTORY_DATA_PATH")}/data/flightaware/"
input_path = File.expand_path("#{data_directory}/flight-ids.txt")
if !File.file?(input_path)
  puts 'Missing source file (data/flightaware/flight-ids.txt)'
  return
end

ids = File.read(input_path)
  .lines
  .map(&:strip)
  .reject { |line| line[0] == '#' }
output_data = ids.map do |id|
  response = client.GetHistoricalTrack(GetHistoricalTrackRequest.new(id))
  sanitize(response.getHistoricalTrackResult.data, id)
end

output_path = File.expand_path("#{data_directory}/flightaware.json")
serialized = JSON.dump(output_data)
File.open(output_path, 'w') { |f| f.write(serialized) }





#
# require 'FlightXML2RESTDriver'
# require 'active_support/core_ext/time'
# # XXX
# require 'byebug'
#
# KEY = '292b7b51fe308ad0e33f9310d984bc8dde33c18f'
# USER = 'stilist'
# CLIENT = FlightXML2REST.new(USER, KEY)
#
# def get_flight_id(timestamp, tail)
#   result = CLIENT.GetFlightID(GetFlightIDRequest.new(timestamp, tail))
#   result.getFlightIDResult
# end
#
# def get_track(flight_id)
#   response = CLIENT.GetHistoricalTrack(GetHistoricalTrackRequest.new(flight_id))
#   data = response.getHistoricalTrackResult.data
#   process_data(data)
# end
#
# def process_data(raw_data=[])
#   first = raw_data.first
#   time = Time.at(first.timestamp).getlocal.iso8601
#   process_trackpoints(raw_data)
# end
#
# def process_trackpoints(trackpoints=[])
#   keys = [:altitude, :altitudeChange, :altitudeStatus, :groundspeed,
#       :latitude, :longitude, :timestamp, :updateType]
#
#   trackpoints.map do |point|
#     Hash[keys.map { |k| [k.to_s, point.send(k)] }]
#   end
# end
#
# zone_names = {
#   'EST' => 'America/New_York',
#   'CST' => 'America/Chicago',
#   'MST' => 'America/Boise',
#   'PST' => 'America/Los_Angeles',
# }.freeze
# need_ids = [
#   ['2006-09-20', '07:18', 'EST', 'N651ML', 'UAL7475'],
#   ['2006-09-20', '08:50', 'CST', nil,      'UAL5634'],
#   ['2006-09-22', '14:20', 'CST', nil,      'UAL8017'],
#   ['2006-09-23', nil,     'EST', nil,      nil],
#   ['2009-11-11', '14:45', 'EST', 'N17620', 'COA1523'],
#   ['2009-11-11', '17:55', 'CST', 'N78501', 'COA553'],
#   ['2009-11-16', '12:10', 'PST', 'N75429', 'COA1546'],
#   ['2009-11-16', '18:55', 'CST', 'N14652', 'COA1417'],
#   ['2010-02-12', '15:05', 'EST', nil,      'COA3366'],
#   ['2010-02-13', '19:50', 'EST', 'N16234', 'COA784'],
#   ['2010-03-11', '09:05', 'PST', 'N418WN', 'SWA593'],
#   ['2010-03-11', '14:45', 'CST', 'N491WN', 'SWA173'],
#   ['2010-03-17', '12:05', 'CST', 'N618WN', 'SWA968'],
#   ['2010-03-17', '13:25', 'CST', 'N508SW', 'SWA514'],
#   ['2010-03-17', '14:40', 'MST', 'N508SW', 'SWA514'],
#   ['2010-09-24', '23:00', 'PST', 'N3766',  'DAL2396'],
#   ['2010-09-24', '07:30', 'EST', 'N810CA', 'DAL6302'],
#   ['2010-10-03', '15:30', 'EST', nil,      'DAL5352'],
#   ['2010-10-03', '19:40', 'EST', 'N3737C', 'DAL1331'],
#   ['2010-12-11', '10:00', 'PST', nil,      'ASA2589'],
#   ['2010-12-15', '19:30', 'PST', nil,      'ASA2574'],
#   ['2011-11-14', '12:25', 'PST', 'N4YAAA', 'AAL1130'],
#   ['2011-11-14', '19:45', 'CST', 'N4WUAA', 'AAL1100'],
#   ['2011-11-21', '17:55', 'EST', 'N504AA', 'AAL1479'],
#   ['2011-11-21', '21:50', 'CST', 'N4WMAA', 'AAL2211'],
#   ['2012-10-19', '21:49', 'PST', 'N76515', 'UAL1289'],
#   ['2012-10-20', nil,     'EST', nil,      nil],
#   ['2012-10-24', '14:44', 'EST', 'N76517', 'UAL1030'],
#   ['2012-10-24', '18:34', 'CST', 'N73283', 'UAL1193'],
# ].reject { |row| row.last.nil? }.
#   map do |row|
#     Time.zone = zone_names[row[2]]
#     local = Time.zone.parse("#{row[0]}T#{row[1]}:00")
#
#     [local.to_i, row[3], row[4]]
#   end
# # need_ids.each do |flight|
# #   get_flight_id(*flight[0..1])
# # end
