module CSS
  class StyleSheet < CSS::SAC::DocumentHandler
    attr_reader :rules

    def initialize(sac)
      @sac   = sac
      @rules = []
      @current_rules = []
      @selector_index = 0
    end

    def start_selector(selectors)
      selectors.each { |selector|
        @current_rules << Rule.new(selector, @selector_index)
      }
    end

    def end_selector(selectors)
      @rules += @current_rules
      @current_rules = []
      @selector_index += 1
      reduce!
    end

    def find_rule(rule)
      rule = self.create_rule(rule) if rule.is_a?(String)
      rules.find { |x| x.selector == rule.selector }
    end
    alias :[] :find_rule

    # Find all rules used in +hpricot_document+
    def find_all_rules_matching(hpricot_document)
      used_rules = []
      hpricot_document.search('//').each do |node|
        if matching = (rules_matching(node))
          used_rules += matching
        end
      end
      used_rules.uniq
    end

    # Find all rules that match +node+.  +node+ must quack like an Hpricot
    # node.
    def rules_matching(node)
      rules.find_all { |rule|
        rule.selector =~ node
      }
    end
    alias :=~ :rules_matching

    def create_rule(rule)
      Rule.new(@sac.parse_rule(rule).first, @selector_index += 1)
    end

    def property(name, value, important)
      @current_rules.each { |selector|
        selector.properties << [name, value, important]
      }
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
        rules.map { |rule| rule.selector.to_css }.sort.join(', ') + " {\n" +
          properties.map { |key,value,important|
            # Super annoying.  If the property is font-family, its supposed to
            # be commas
            join_val = ('font-family' == key) ? ', ' : ' '
            values = [value].flatten.join(join_val)
            "#{key}:#{values}#{important ? ' !important' : ''};"
          }.join("\n") + "\n}"
      end.sort.join("\n")
    end

    private
    # Remove duplicate rules
    def reduce!
      unique_rules = {}
      @rules.each do |rule|
        (unique_rules[rule.selector] ||= rule).properties += rule.properties
      end
      @rules = unique_rules.values
      self
    end
  end
end

