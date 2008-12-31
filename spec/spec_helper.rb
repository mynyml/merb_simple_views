$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'spec'
require 'merb-core'
require 'merb_simple_views'

begin
  require 'ruby-debug'
rescue LoadError, RuntimeError
  # i can haz dibugz plz?
end

Merb.start :environment => 'test', :adapter => 'runner'

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Core Extensions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This might cause errors to slip into specs, but it beats using fixtures.
class String
  def unindent
    indent = self.select {|line| !line.strip.empty? }.map {|line| line.index(/[^\s]/) }.compact.min
    self.gsub(/^[[:blank:]]{#{indent}}/, '')
  end
  def unindent!
    self.replace(self.unindent)
  end
end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Helpers
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module Helpers
  def write_template(name, content, controller)
    view_path = Merb.dir_for(:view) / controller.controller_name / name
    view_path.dirname.mkdir
    Kernel.open(view_path, 'w+') {|file| file.write(content) }
  end

  def clean_view_dir!
    FileUtils.rm_rf( Pathname.glob(Merb.dir_for(:view) / "*") )
  end
end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Config
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper
  config.include Helpers
end
