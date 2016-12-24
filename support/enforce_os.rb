#!/usr/bin/env ruby
# frozen_string_literal: true

def enforce_os(name)
  raise "Wrong OS" unless `uname`.strip == name
end
