# frozen_string_literal: true

require 'dotenv/load'
require 'fileutils'
require 'json'
require 'open-uri'

class LastfmError < StandardError ; end
class NetworkError < StandardError ; end

class Lastfm
  attr_reader :data

  SECONDS_BETWEEN_REQUESTS = 0.2

  def initialize
    @uri = URI.parse("https://ws.audioscrobbler.com/2.0/")

    @default_params = {
      api_key: ENV.fetch('LASTFM_API_KEY'),
      format: 'json',
      limit: 200,
      method: 'user.getrecenttracks',
      user: ENV.fetch('LASTFM_USER'),
    }.freeze

    output_directory = "#{ENV.fetch("HISTORY_DATA_PATH")}/data/lastfm"
    @output_path = File.expand_path("#{output_directory}/#{ENV.fetch('LASTFM_USER')}.json")
    FileUtils.mkdir_p(File.dirname(@output_path))
    @data = JSON.parse(File.read(@output_path))
  rescue ::Errno::ENOENT, ::JSON::ParserError
    @data = []
  end

  def import
    total_pages = fetch.dig('@attr', 'totalPages')
      .to_i
    (1..total_pages).each do |page|
      print " #{page} "

      begin
        tracks = fetch(page: page)['track']
        print '+'
      rescue ::NetworkError
        sleep SECONDS_BETWEEN_REQUESTS
        redo
      end

      @data = @data.concat(tracks)
      persist_data if !tracks.empty?

      sleep SECONDS_BETWEEN_REQUESTS
    end
  end

  private

  def persist_data
    File.open(@output_path, 'w') { |f| f.write(JSON.dump(data)) }
  end

  def fetch(params = {})
    uri = @uri.dup
    uri.query = @default_params.merge(params)
      .map { |k, v| "#{k}=#{v}" }
      .join('&')
    response = open(uri, read_timeout: 5) do |res|
      JSON.parse(res.read)
    end

    raise LastfmError if response.key?('error')

    response['recenttracks']
  rescue ::Errno::ENETDOWN
    puts 'Network failure'
    exit
  rescue ::JSON::ParserError
    print 'x'
    raise LastfmError
  rescue ::Net::ReadTimeout, ::OpenURI::HTTPError
    print '<'
    raise NetworkError
  end
end

if ENV['INCLUDE_IMPORTERS'] =~ Regexp.new(File.basename(__FILE__, '.rb'))
  Lastfm.new.import
end
