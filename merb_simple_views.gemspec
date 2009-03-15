--- !ruby/object:Gem::Specification 
name: merb_simple_views
version: !ruby/object:Gem::Version 
  version: 0.5.0
platform: ruby
authors: 
- Martin Aumont
autorequire: 
bindir: bin
cert_chain: []

date: 2009-03-15 00:00:00 -04:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: merb-core >= 1.0
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
    version: 
description: Merb plugin that allows defining templates (views, css, js)in the same file as the controller.
email: mynyml@gmail.com
executables: []

extensions: []

extra_rdoc_files: []

files: 
- CHANGELOG
- log
- lib
- lib/merb_simple_views.rb
- lib/merb_simple_views
- lib/merb_simple_views/mixin.bk.rb
- lib/merb_simple_views/cache.rb
- lib/merb_simple_views/cache.bk.rb
- lib/merb_simple_views/merbtasks.rb
- lib/merb_simple_views/merbtasks.bk.rb
- lib/merb_simple_views/mixin.rb
- lib/merb_simple_views/template_parser.rb
- lib/merb_simple_views.bk.rb
- LICENSE
- README
- Rakefile
- MYTODO
- draft
- TODO
- autotest
- autotest/rspec_simpleviews.rb
- autotest/discover.rb
- autotest/rspec_simpleviews.bk.rb
- spec
- spec/spec_helper.rb
- spec/mixin_spec.bk.rb
- spec/mixin_spec.rb
- spec/fixtures
- spec/fixtures/views
- spec/fixtures/controller3.rb
- spec/spec.opts
- spec/template_parser_spec.rb
has_rdoc: true
homepage: ""
post_install_message: 
rdoc_options: []

require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
requirements: []

rubyforge_project: 
rubygems_version: 1.3.1
signing_key: 
specification_version: 2
summary: Merb plugin that allows defining templates (views, css, js)in the same file as the controller.
test_files: []

