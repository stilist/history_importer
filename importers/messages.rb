require 'fileutils'
require_relative '../support/enforce_os'
require_relative '../support/import_file'

enforce_os('Darwin')
import_file('~/Library/Messages/chat.db', 'messages')

source = File.expand_path('~/Library/Messages')
destination = "#{ENV.fetch("HISTORY_DATA_PATH")}/data/messages"
FileUtils.mkdir_p(destination)
FileUtils.cp_r("#{source}/attachments", destination, preserve: true, verbose: true)
