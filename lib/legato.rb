require "legato/version"

require 'multi_json'
require 'cgi'
require 'ostruct'

if Object.const_defined?("ActiveSupport")
  require "active_support/core_ext/string"
  require "active_support/core_ext/array"
else
  require "legato/core_ext/string"
  require "legato/core_ext/array"
end

module Legato
  module Management
  end

  def self.to_ga_string(str)
    "#{$1}ga:#{$2}" if str.to_s.camelize(:lower) =~ /^(-)?(.*)$/
  end

  def self.from_ga_string(str)
    str.gsub("ga:", '')
  end

  def self.format_time(t)
    t.strftime('%Y-%m-%d')
  end

  def self.and_join_character
    ';'
  end

  def self.or_join_character
    ','
  end
end

require 'legato/user'
require 'legato/profile_methods'

require 'legato/management/finder'
require 'legato/management/account'
require 'legato/management/web_property'
require 'legato/management/profile'

require 'legato/list_parameter'
require 'legato/response'
require 'legato/filter'
require 'legato/filter_set'
require 'legato/query'
require 'legato/model'
