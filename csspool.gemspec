# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "csspool"
  s.version = "3.0.0.20120408213007"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Patterson", "John Barnette"]
  s.date = "2012-04-08"
  s.description = "CSSPool is a CSS parser.  CSSPool provides a SAC interface for parsing CSS as\nwell as a document oriented interface for parsing CSS."
  s.email = ["aaronp@rubyforge.org", "jbarnette@rubyforge.org"]
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "Manifest.txt", "README.rdoc", "CHANGELOG.rdoc", "README.rdoc"]
  s.files = [".autotest", "CHANGELOG.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "lib/csspool.rb", "lib/csspool/collection.rb", "lib/csspool/css.rb", "lib/csspool/css/charset.rb", "lib/csspool/css/declaration.rb", "lib/csspool/css/document.rb", "lib/csspool/css/document_handler.rb", "lib/csspool/css/import_rule.rb", "lib/csspool/css/media.rb", "lib/csspool/css/parser.rb", "lib/csspool/css/parser.y", "lib/csspool/css/rule_set.rb", "lib/csspool/css/tokenizer.rb", "lib/csspool/css/tokenizer.rex", "lib/csspool/node.rb", "lib/csspool/sac.rb", "lib/csspool/sac/document.rb", "lib/csspool/sac/parser.rb", "lib/csspool/selector.rb", "lib/csspool/selectors.rb", "lib/csspool/selectors/additional.rb", "lib/csspool/selectors/attribute.rb", "lib/csspool/selectors/class.rb", "lib/csspool/selectors/id.rb", "lib/csspool/selectors/pseudo_class.rb", "lib/csspool/selectors/simple.rb", "lib/csspool/selectors/type.rb", "lib/csspool/selectors/universal.rb", "lib/csspool/terms.rb", "lib/csspool/terms/function.rb", "lib/csspool/terms/hash.rb", "lib/csspool/terms/ident.rb", "lib/csspool/terms/number.rb", "lib/csspool/terms/rgb.rb", "lib/csspool/terms/string.rb", "lib/csspool/terms/uri.rb", "lib/csspool/visitors.rb", "lib/csspool/visitors/children.rb", "lib/csspool/visitors/comparable.rb", "lib/csspool/visitors/iterator.rb", "lib/csspool/visitors/to_css.rb", "lib/csspool/visitors/visitor.rb", "test/css/test_document.rb", "test/css/test_import_rule.rb", "test/css/test_parser.rb", "test/css/test_tokenizer.rb", "test/helper.rb", "test/sac/test_parser.rb", "test/sac/test_properties.rb", "test/sac/test_terms.rb", "test/test_collection.rb", "test/test_parser.rb", "test/test_selector.rb", "test/visitors/test_children.rb", "test/visitors/test_comparable.rb", "test/visitors/test_each.rb", "test/visitors/test_to_css.rb", ".gemtest"]
  s.homepage = "http://csspool.rubyforge.org"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "csspool"
  s.rubygems_version = "1.8.15"
  s.summary = "CSSPool is a CSS parser"
  s.test_files = ["test/css/test_document.rb", "test/css/test_import_rule.rb", "test/css/test_parser.rb", "test/css/test_tokenizer.rb", "test/sac/test_parser.rb", "test/sac/test_properties.rb", "test/sac/test_terms.rb", "test/test_collection.rb", "test/test_parser.rb", "test/test_selector.rb", "test/visitors/test_children.rb", "test/visitors/test_comparable.rb", "test/visitors/test_each.rb", "test/visitors/test_to_css.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_development_dependency(%q<racc>, [">= 0"])
      s.add_development_dependency(%q<rexical>, [">= 0"])
      s.add_development_dependency(%q<hoe-git>, [">= 0"])
      s.add_development_dependency(%q<hoe-gemspec>, [">= 0"])
      s.add_development_dependency(%q<hoe-bundler>, [">= 0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.0"])
    else
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_dependency(%q<racc>, [">= 0"])
      s.add_dependency(%q<rexical>, [">= 0"])
      s.add_dependency(%q<hoe-git>, [">= 0"])
      s.add_dependency(%q<hoe-gemspec>, [">= 0"])
      s.add_dependency(%q<hoe-bundler>, [">= 0"])
      s.add_dependency(%q<hoe>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
    s.add_dependency(%q<racc>, [">= 0"])
    s.add_dependency(%q<rexical>, [">= 0"])
    s.add_dependency(%q<hoe-git>, [">= 0"])
    s.add_dependency(%q<hoe-gemspec>, [">= 0"])
    s.add_dependency(%q<hoe-bundler>, [">= 0"])
    s.add_dependency(%q<hoe>, ["~> 3.0"])
  end
end
