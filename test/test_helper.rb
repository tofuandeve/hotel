require 'simplecov'
SimpleCov.start

require "minitest"
require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative "../lib/hotel_system"
require_relative "../lib/date_range"
require_relative "../lib/reservation"
