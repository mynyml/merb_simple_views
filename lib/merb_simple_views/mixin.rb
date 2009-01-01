module SimpleViews

  TEMPLATES = {}

  module Mixin
    attr_accessor :_template_parser

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

    def display(*args)
      @__caller_info__ = __caller_info__
      super
    end

    def _template_parser
      @_template_parser ||= SimpleViews::TemplateParser.new
    end
  end
end

module Merb::Template
  def self.load_template_io(path)
    super || template_extensions.map {|ext| SimpleViews::TEMPLATES["#{path}.#{ext}"] }.compact.first
  end
end
