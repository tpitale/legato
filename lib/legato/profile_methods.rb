module Legato
  module ProfileMethods
    def self.add_profile_method(klass)
      # demodulize leaves potential to redefine
      # these methods given different namespaces
      method_name = klass.name.to_s.demodulize.underscore
      return unless method_name.length > 0

      class_eval <<-CODE
        def #{method_name}(opts={})
          #{klass}.results(self, opts)
        end
      CODE
    end
  end
end
