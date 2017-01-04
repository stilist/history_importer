#!/usr/bin/env ruby
# frozen_string_literal: true

# @param name [String] the kernel name the user is expected to be running
#
# @todo +raise+ may cause scripts to stop running; it might be better to return
#   a boolean
def enforce_os(name)
  raise "Wrong OS" unless `uname -s`.strip == name
end
