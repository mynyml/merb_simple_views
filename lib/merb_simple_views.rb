if defined?(Merb::Plugins)
  dir = Pathname(__FILE__).dirname / 'merb_simple_views'

  require dir / 'mixin'

  # config options
  Merb::Plugins.config[:simple_views] = {}

  Merb::BootLoader.after_app_loads do
    Merb::Controller.class_eval { include SimpleViews::Mixin }
  end
end
