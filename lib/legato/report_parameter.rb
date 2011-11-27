# module Legato
#   class ReportParameter
# 
#     attr_reader :name, :elements
# 
#     def initialize(name, elements=[])
#       @name = name
#       @elements = [elements].flatten.compact
#     end
# 
#     def name
#       @name.to_s
#     end
# 
#     def <<(element)
#       (@elements += [element].flatten).compact!
#       self
#     end
# 
#     def to_params
#       value = self.elements.map{|param| Legato.to_google_analytics(param)}.join(',')
#       value.empty? ? {} : {self.name => value}
#     end
# 
#     def ==(other)
#       name == other.name && elements == other.elements
#     end
#   end
# end
