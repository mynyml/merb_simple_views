if defined?(Merb::Plugins)
  dir = Pathname(__FILE__).dirname / 'merb_simple_views'

  # Make Merb::RenderMixin's #render and #display methods chainable
  #
  # ==== Notes
  # This is used as a (arguably) more elegant workaround to
  # alias_method_chaining them.
  #
  # "We consider cases of people using alias_method_chain on Merb to be a bug in
  # Merb, and try to find ways to expose enough functionality so it will not be
  # required."
  # -- http://yehudakatz.com/2008/05/22/the-greatest-thing-since-sliced-merb/
  #
  # Ideally those methods would be declared chainable within the RenderMixin
  # itself and this monkey patch wouldn't be needed.
  Merb::RenderMixin.module_eval do
    [:render, :display].each do |name|
      method = instance_method(name)
      self.class.chainable { send(:define_method, name, method) }
    end
  end

  require dir / 'template_parser'
  require dir / 'mixin'

  # config options
  Merb::Plugins.config[:simple_views] = {}

  Merb::BootLoader.after_app_loads do
    Merb::Controller.class_eval { include SimpleViews::Mixin }
  end
end
