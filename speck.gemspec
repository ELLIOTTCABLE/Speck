# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{speck}
  s.version = "0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["elliottcable"]
  s.date = %q{2009-08-03}
  s.description = %q{Supah-light 'n sexy specking!}
  s.email = ["Speck@elliottcable.com"]
  s.extra_rdoc_files = ["lib/speck/check.rb", "lib/speck/core_ext/check_mixins.rb", "lib/speck/core_ext.rb", "lib/speck.rake", "lib/speck.rb", "README.markdown"]
  s.files = ["lib/speck/check.rb", "lib/speck/core_ext/check_mixins.rb", "lib/speck/core_ext.rb", "lib/speck.rake", "lib/speck.rb", "Rakefile.rb", "README.markdown", ".manifest", "speck.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/elliottcable/speck}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Speck", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{speck}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Supah-light 'n sexy specking!}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<echoe>, [">= 0", "= 3.0.2"])
    else
      s.add_dependency(%q<echoe>, [">= 0", "= 3.0.2"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0", "= 3.0.2"])
  end
end
