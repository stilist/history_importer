require 'fileutils'
require_relative '../support/enforce_os'
require_relative '../support/import_file'

enforce_os('Darwin')
import_file('~/Library/Time Sink/Configurations/Default.plist', 'time_sink')
