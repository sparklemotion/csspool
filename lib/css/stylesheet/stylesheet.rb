module CSS
  class StyleSheet < CSS::SAC::DocumentHandler
    attr_reader :selectors

    def initialize
      @selectors = []
      @current_selectors = []
    end

    def start_selector(selectors)
      selectors.each { |ast|
        @current_selectors << Selector.new(ast)
      }
    end

    def end_selector(selectors)
      @selectors += @current_selectors
      @current_selectors = []
    end

    def property(name, value, important)
      @current_selectors.each { |selector|
        selector.properties << [name, value, important]
      }
    end

    def reduce!
      unique_selectors = {}
      @selectors.each do |sel|
        (unique_selectors[sel] ||= sel).properties += sel.properties
      end
      @selectors = unique_selectors.keys
      self
    end

    def to_css
      @selectors.each do |sel|
      end
    end
  end
end

