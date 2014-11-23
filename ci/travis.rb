#!/usr/bin/env ruby
require 'fileutils'
include FileUtils

commands = [
  'mysql -e "create database activerecord_unittest;"',
  'mysql -e "create database activerecord_unittest2;"',
]

commands.each do |command|
  system("#{command} > /dev/null 2>&1")
end
