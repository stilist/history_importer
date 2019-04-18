# frozen_string_literal: true

require 'fileutils'
require_relative '../support/enforce_os'
require_relative '../support/import_file'

enforce_os('Darwin')
import_file('~/Library/Messages/chat.db', 'messages')

source = File.expand_path('~/Library/Messages')
destination = File.expand_path("#{ENV.fetch("HISTORY_DATA_PATH")}/data/messages/")
directories = %w(Archive Attachments)
directories.each do |directory|
  next if !File.exist?("#{source}/#{directory}")

  begin
    FileUtils.mkdir_p("#{destination}/#{directory.downcase}")
    FileUtils.cp_r("#{source}/#{directory}/.", "#{destination}/#{directory.downcase}",
                   preserve: true,
                   verbose: true)
  rescue ::Errno::EPERM
    puts "--> Unable to create #{destination}/#{directory.downcase} due to permissions issue."
  end
end
