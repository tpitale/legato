module Legato
  module ProfileMethods
    def self.add_profile_method(klass)
      # demodulize leaves potential to redefine
      # these methods given different namespaces
      method_name = method_name_from_klass(klass)

      return unless method_name.length > 0

      class_eval <<-CODE
        def #{method_name}(opts={})
          #{klass}.results(self, opts)
        end
      CODE
    end

    def self.method_name_from_klass(klass)
      klass.name.to_s.gsub(":", "_").demodulize.underscore
    end
  end
end
