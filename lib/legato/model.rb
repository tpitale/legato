module Legato
  module Model
    def self.extended(base)
      ProfileMethods.add_profile_method(base)
    end

    def metrics(*fields)
      @metrics ||= ListParameter.new(:metrics)
      @metrics << fields
    end

    def dimensions(*fields)
      @dimensions ||= ListParameter.new(:dimensions)
      @dimensions << fields
    end

    def filters
      @filters ||= {}
    end

    def filter(name, &block)
      filters[name] = block

      (class << self; self; end).instance_eval do
        define_method(name) {|*args| Query.new(self).apply_filter(*args, &block)}
      end
    end

    def segments
      @segments ||= {}
    end

    def segment(name, &block)
      segments[name] = block

      (class << self; self; end).instance_eval do
        define_method(name) {|*args| Query.new(self).apply_segment_filter(*args, &block)}
      end
    end

    def set_instance_klass(klass)
      @instance_klass = klass
    end

    def instance_klass
      @instance_klass || OpenStruct
    end

    def results(profile, options = {})
      Query.new(self).results(profile, options)
    end

  end
end