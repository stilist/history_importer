# frozen_string_literal: true

require 'fileutils'
require_relative 'hardware_model'

# Copy the +path+ file into the appropriate history data directory, renamed
# to reflect the device the file came from (since devices usually don't sync
# data perfectly.)
#
# @param path [String] path to locate the source file
# @param data_source [String] the app (or other source) the data is from -- for
#   example, +'safari'+
# @param destination_filename [String, nil] custom filename for the imported
#   file; useful if the source filename doesn't convey the data type -- for
#   example, iOS backups use SHA-1 to generate filenames
def import_file(path, data_source, destination_filename: nil)
  raise 'Source not passed' if !path
  raise 'Need a source type (e.g. "safari")' if !data_source

  full_path = File.expand_path(path)
  if !File.file?(full_path)
    puts "Not a file: #{path}"
    return
  end

  # @note +HISTORY_DATA_PATH+ is something like +~/Documents/history+.
  destination = "#{ENV.fetch("HISTORY_DATA_PATH")}/data/#{data_source}"
  FileUtils.mkdir_p(destination)

  filename = if destination_filename then destination_filename
             else "#{hardware_model}#{File.extname(full_path)}"
             end
  FileUtils.cp(full_path, "#{destination}/#{filename}",
               preserve: true,
               verbose: true)
end
