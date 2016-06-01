# encoding: utf-8
require './config/initializer'

require "sinatra"
Dir["./app/helper/*.rb"].each {|file| require file }
require './app/api'
