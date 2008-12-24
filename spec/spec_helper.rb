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

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end

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
