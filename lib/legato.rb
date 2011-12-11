require "legato/version"

require 'json'
require 'oauth2'
require 'cgi'
require 'ostruct'

unless Object.const_defined?("ActiveSupport")
  require "legato/core_ext/string"
  require "legato/core_ext/array"
end

module Legato
  module Management
  end

  def self.to_ga_string(str)
    "#{$1}ga:#{$2}" if str.to_s.camelize(:lower) =~ /^(-)?(.*)$/
  end

  def self.format_time(t)
    t.strftime('%Y-%m-%d')
  end

  def self.collect_params(set)
    set.map {|param| Legato.to_ga_string(param)}.join(',')
  end
end

require 'legato/user'

require 'legato/management/finder'
require 'legato/management/account'
require 'legato/management/web_property'
require 'legato/management/profile'

require 'legato/request'
require 'legato/filter'
require 'legato/query'
require 'legato/model'
