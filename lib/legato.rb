require "legato/version"

require 'json'
require 'oauth2'
require 'cgi'
require 'ostruct'

unless Object.const_defined?("ActiveSupport")
  require "legato/core_ext/string"
end

module Legato
  module Management
  end

  def self.to_ga_string(str)
    "#{$1}ga:#{$2}" if str.to_s.camelize(:lower) =~ /^(-)?(.*)$/
  end
end

require 'legato/user'

require 'legato/management/finder'
require 'legato/management/account'
require 'legato/management/web_property'
require 'legato/management/profile'

require 'legato/model'
