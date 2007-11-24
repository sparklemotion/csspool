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

    def reduce!
      unique_rules = {}
      @rules.each do |rule|
        (unique_rules[rule.selector] ||= rule).properties += rule.properties
      end
      @rules = unique_rules.values
      self
    end

    def rules_by_property
      rules_by_property = Hash.new { |h,k| h[k] = [] }
      @rules.each { |sel|
        props = sel.properties.to_a.sort_by { |x| x.hash } # HACK?
        rules_by_property[props] << sel
      }
      rules_by_property
    end

    def to_css
      @rules.each do |sel|
      end
    end
  end
end

