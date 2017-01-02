require 'fileutils'
require_relative '../support/enforce_os'
require_relative '../support/import_file'

enforce_os('Darwin')
import_file('~/Library/Messages/chat.db', 'messages')

source = File.expand_path('~/Library/Messages')
directories = %w(Archive Attachments)
directories.each do |directory|
  destination = "#{ENV.fetch("HISTORY_DATA_PATH")}/data/messages/#{directory}"
  FileUtils.mkdir_p(destination)
  FileUtils.cp_r("#{source}/#{directory.downcase}", destination,
                 preserve: true,
                 verbose: true)
end
