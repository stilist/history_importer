# frozen_string_literal: true

require 'open-uri'
require_relative 'enforce_os'

# @return [String] the hardware model of the macOS device the user is running
def hardware_model
  enforce_os('Darwin')

  @hardware_model ||= begin
    # @see http://apple.stackexchange.com/a/98089
    serial = `system_profiler SPHardwareDataType`.lines
      .find { |line| line =~ /Serial/ }
      .strip[-4..-1]
    uri = URI.parse("http://support-sp.apple.com/sp/product?cc=#{serial}")
    xml = uri.read.
      match(/<configCode>(.*?)<\/configCode>/)[1]
  rescue
    'Unknown'
  end
end
