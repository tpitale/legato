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

  def self.to_ga_string(str, tracking_scope = "ga")
    "#{$1}#{tracking_scope}:#{$2}" if str.to_s.camelize(:lower) =~ /^(-)?(.*)$/
  end

  def self.from_ga_string(str)
    str.gsub(/ga:|mcf:|rt:/, '')
  end

  def self.format_time(t)
    if t.is_a?(String)
      t
    else
      t.strftime('%Y-%m-%d')
    end
  end

  def self.and_join_character
    ';'
  end

  def self.or_join_character
    ','
  end
end

require 'legato/request'
require 'legato/user'
require 'legato/profile_methods'

require 'legato/management/model'
require 'legato/management/query'
require 'legato/management/finder'
require 'legato/management/segment'
require 'legato/management/account'
require 'legato/management/account_summary'
require 'legato/management/web_property'
require 'legato/management/profile'
require 'legato/management/goal'

require 'legato/list_parameter'
require 'legato/response'
require 'legato/filter'
require 'legato/filter_set'
require 'legato/query'
require 'legato/model'
