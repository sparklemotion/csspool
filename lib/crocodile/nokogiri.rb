require 'nokogiri'

class Nokogiri::XML::Node
  def selectors
    @selectors ||= []
  end

  def styles
    styles = {}
    selectors.each do |sel|
      sel.declarations.each do |decl|
        styles[decl.property] = decl
      end
    end
    styles
  end
end
