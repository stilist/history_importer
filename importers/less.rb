require_relative '../support/import_file'

source_file = ENV.fetch('LESSHISTFILE') { "#{ENV['HOME']}/.lesshst" }
import_file(source_file, 'less_history')
