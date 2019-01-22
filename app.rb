require 'bundler'
Bundler.require


$:.unshift File.expand_path("./../lib/app", __FILE__)
require 'scrapper'

#

scrap = Scrapper.new
scrap.perform
scrap.save_as_JSON
scrap.save_to_spreadsheet
scrap.save_as_csv 