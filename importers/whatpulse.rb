require 'fileutils'
require_relative '../support/enforce_os'
require_relative '../support/import_file'

enforce_os('Darwin')
import_file('~/Library/Application Support/whatpulse/whatpulse.db', 'whatpulse')
