module CSS
  class StyleSheet < CSS::SAC::DocumentHandler
    attr_reader :rules

    def initialize
      @rules = []
      @current_rules = []
    end

    def start_selector(selectors)
      selectors.each { |selector|
        @current_rules << Rule.new(selector)
      }
    end

    def end_selector(selectors)
      @rules += @current_rules
      @current_rules = []
    end

    def property(name, value, important)
      @current_rules.each { |selector|
        selector.properties << [name, value, important]
      }
    end

    # Remove duplicate rules
    def reduce!
      unique_rules = {}
      @rules.each do |rule|
        (unique_rules[rule.selector] ||= rule).properties += rule.properties
      end
      @rules = unique_rules.values
      self
    end

    # Get a hash of rules by property
    def rules_by_property
      rules_by_property = Hash.new { |h,k| h[k] = [] }
      @rules.each { |sel|
        props = sel.properties.to_a.sort_by { |x| x.hash } # HACK?
        rules_by_property[props] << sel
      }
      rules_by_property
    end

    def to_css
      rules_by_property.map do |properties, rules|
        rules.map { |rule| rule.selector.to_css }.join(', ') + " {\n" +
          properties.map { |key,value,important|
            # Super annoying.  If the property is font-family, its supposed to
            # be commas
            join_val = ('font-family' == key) ? ', ' : ' '
            values = [value].flatten.join(join_val)
            "#{key}: #{values}#{important ? ' !important' : ''};"
          }.join("\n") + "\n}"
      end.join("\n")
    end
  end
end

