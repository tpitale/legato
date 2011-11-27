module Legato
  module Model
    MONTH = 2592000
    URL = "https://www.google.com/analytics/feeds/data"

    # def self.extended(base)
    #   ProfileReports.add_report_method(base)
    # end

    def metrics(*fields)
      @metrics ||= []
      @metrics << fields
    end

    # def metrics(*fields)
    #   @metrics ||= ReportParameter.new(:metrics)
    #   @metrics << fields
    # end

    def dimensions(*fields)
      @dimensions ||= []
      @dimensions << fields
    end

    # def dimensions(*fields)
    #   @dimensions ||= ReportParameter.new(:dimensions)
    #   @dimensions << fields
    # end

    # def filter_definitions
    #   @filter_definitions ||= {}
    # end

    # def filter(name, block)
    #   filter_definitions[name] = block
    #   (class << self; self; end).instance_eval do
    #     define_method(name) {|*args| Query.new(self).apply_filter(*args, block)}
    #   end
    # end

    # def set_instance_klass(klass)
    #   @instance_klass = klass
    # end

    # def instance_klass
    #   @instance_klass || OpenStruct
    # end

    def results(profile)
      url = "https://www.google.com/analytics/feeds/data"
      dimension_params = dimensions.map {|d| Legato.to_ga_string(d)}.join(',')
      metric_params = metrics.map {|m| Legato.to_ga_string(m)}.join(',')

      begin
        profile.user.access_token.get(url, :params => {
          'ids' => Legato.to_ga_string(profile.id),
          # 'dimensions' => dimension_params,
          'metrics' => metric_params
        })
      rescue => e
        puts e.backtrace
      end
    end

    # def results(profile, options = {})
    #   Query.new(self).results(profile, options)
    # end

  end
end