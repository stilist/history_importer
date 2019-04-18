# frozen_string_literal: true

require 'digest/sha1'
require 'plist'
require_relative '../support/enforce_os'
require_relative '../support/import_file'

known_filenames = {
  messages: 'HomeDomain-Library/SMS/sms.db',
  calls: 'WirelessDomain-Library/CallHistory/call_history.db',
  notes: 'HomeDomain-Library/Notes/notes.sqlite',
  voicemail: 'HomeDomain-Library/Voicemail/voicemail.db',
}.each_with_object({}) do |(key, value), memo|
  next if !value =~ /.db$/
  memo[key] = Digest::SHA1.hexdigest(value)
end

backup_root = File.expand_path('~/Library/Application Support/MobileSync/Backup')
begin
  backups = Dir["#{backup_root}/*"]
rescue ::Errno::EPERM
  puts "--> Unable to access #{backup_root} due to permissions issue."
  exit(0)
end
backups.each do |backup_path|
  document = Plist.parse_xml(File.join(backup_path, 'Info.plist'))
  next if document.nil?
  device_name = "#{document['Display Name']} (#{document['Product Name']})"

  extension = '.db'
  known_filenames.map do |key, value|
    directory = value[0..1]
    import_file("#{backup_path}/#{directory}/#{value}", key,
                destination_filename: "#{device_name}#{extension}")
  end
end
