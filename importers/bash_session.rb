require_relative '../support/import_file'

source = File.expand_path('~/.bash_sessions')
destination = File.expand_path("#{ENV.fetch("HISTORY_DATA_PATH")}/data/bash_sessions/")
FileUtils.mkdir_p("#{destination}")
FileUtils.cp_r("#{source}/.", destination,
               preserve: true,
               verbose: true)
