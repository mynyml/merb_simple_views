module SimpleViews

  TEMPLATES = {}

  # Adds SimpleViews functionality to a Merb controller, allowing templates
  # defined in the controller's file to serve as views. See README for more.
  module Mixin
    attr_reader :_template_parser

    def initialize
      @_template_parser = SimpleViews::TemplateParser.new
      super
    end

    # In addition to default #render behaviour, parse simple views defined in
    # controller's file and render them when requested, or render external
    # templates otherwise.
    #
    # ==== Notes
    # 1. Turned into a chainable method in merb_simple_views.rb
    # 2. Uses a VirtualFile to trick template engines.
    #
    # ==== Parameters
    # See Merb::RenderMixin#render
    #
    # ==== Options
    # See Merb::RenderMixin#render
    #
    # ==== Returns
    # See Merb::RenderMixin#render
    #
    # ==== Raises
    # See Merb::RenderMixin#render
    #
    # ==== Alternatives
    # See Merb::RenderMixin#render
    #
    # :api: public
    def render(*args)
      tpls_file = (@__caller_info__ || __caller_info__).first.first
      self._template_parser.load(tpls_file).parse.each do |template_name, raw_content|
        # no controller name if absolute view path
        ctrl_name = template_name.match(/^\//) ? nil : self.controller_name
        path = Merb.dir_for(:view) / self._template_location(template_name.gsub(/^\//,''), nil, ctrl_name)
        file = VirtualFile.new(raw_content, path)
        TEMPLATES[path.to_s] = file
      end
      super
    end

    # Wrap #display and store caller info so that #render (called internally by
    # #display) knows what file to fetch template data from.
    #
    # ==== Notes
    # Turned into a chainable method in merb_simple_views.rb
    #
    # ==== Parameters
    # See Merb::RenderMixin#display
    #
    # ==== Options
    # See Merb::RenderMixin#display
    #
    # ==== Returns
    # See Merb::RenderMixin#display
    #
    # ==== Raises
    # See Merb::RenderMixin#display
    #
    # ==== Alternatives
    # See Merb::RenderMixin#display
    #
    # :api: public
    def display(*args)
      @__caller_info__ = __caller_info__
      super
    end
  end
end

module Merb::Template
  def self.load_template_io(path)
    super || template_extensions.map {|ext| SimpleViews::TEMPLATES["#{path}.#{ext}"] }.compact.first
  end
end
