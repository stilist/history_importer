require 'fileutils'
require_relative 'hardware_model'

# Copy the +path+ file into the appropriate history data directory, renamed
# to reflect the device the file came from (since devices usually don't sync
# data perfectly.)
#
# @param path [String] path to locate the source file
# @param data_source [String] the app (or other source) the data is from -- for
#   example, +'safari'+
def import_file(path, data_source)
  raise 'Source not passed' if !path
  raise 'Need a source type (e.g. "safari")' if !data_source

  full_path = File.expand_path(path)
  raise 'Not a file' if !File.file?(full_path)

  # @note +HISTORY_DATA_PATH+ is something like +~/Documents/history+.
  destination = "#{ENV.fetch("HISTORY_DATA_PATH")}/data/#{data_source}"
  FileUtils.mkdir_p(destination)

  extension = File.extname(full_path)
  FileUtils.cp(full_path, "#{destination}/#{hardware_model}#{extension}",
               preserve: true,
               verbose: true)
end
