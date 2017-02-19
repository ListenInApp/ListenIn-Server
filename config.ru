require 'sinatra'

require_relative 'listenin'

enable :logging

$stdout.sync = true

run App
