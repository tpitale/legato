require "legato/version"

require 'json'

module Legato
  autoload :User, 'legato/user'

  module Management
    autoload :Finder, 'legato/management/finder'
    autoload :Account, 'legato/management/account'
    autoload :WebProperty, 'legato/management/web_property'
    autoload :Profile, 'legato/management/profile'
  end
end
