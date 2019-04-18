# frozen_string_literal: true

require 'json'
require 'nokogiri'

data_path = File.expand_path(File.join(ENV['HISTORY_DATA_PATH'], 'data', 'gyroscope_places'))
input_files = Dir[File.join(data_path, '*.html')]

exit(0) if input_files.empty?

# This parses the HTML that renders Gyroscope's 'Places' data, e.g.
# https://gyrosco.pe/stilist/helix/places/2018/7/. This can be either the full
# document or just the partial data the server sends when navigating between
# months.
mapped = input_files.reduce({ paths: [], points: [] }) do |memo, file|
  raw = ::File.read(file)

  path_regex = /travel_points\s=\s(\[.+?\]);/m
  path_data = raw.match(path_regex)[1]
  # +path_data+ is an array of ECMAScript objects, rather than JSON --
  # the object keys aren't quoted strings. The data format is simple enough to
  # parse as an array of Ruby objects.
  memo[:paths].concat(eval(path_data))

  document = ::Nokogiri::HTML(raw)
  nodes = document.css('[data-longitude]')
  points = nodes.map do |node|
    {
      latitude: node['data-latitude'],
      longitude: node['data-longitude'],
      name: node['data-name'],
    }.freeze
  end
  memo[:points].concat(points)

  memo
end

File.write(File.join(data_path, 'parsed.json'),
           JSON.pretty_generate(mapped))
