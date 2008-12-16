require 'pathname'
require 'rubygems'
require 'rake'
require 'echoe'

# Echo docs: http://blog.evanweaver.com/files/doc/fauna/echoe/classes/Echoe.html
Echoe.new('merb_simple_views', '0.5.0') do |p|

  # descriptive options
  p.description = 'Merb plugin that allows templates (views, css, js) to be defined in the same file as the controller'
  p.url         = 'http://github.com/mynyml/merb_simple_views'
  p.author      = 'Martin Aumont'
  p.email       = 'mynyml@gmail.com'

  # packaging options
  p.runtime_dependencies     = ['merb-core >= 1.0']
  p.ignore_pattern           = ['tmp/*', 'log/*']
  p.development_dependencies = []

  # testing options
  p.clean_pattern = ['tmp/*', 'log/*']
end

Dir[Pathname(__FILE__).join('tasks/*.rake')].sort.each {|file| load file }
