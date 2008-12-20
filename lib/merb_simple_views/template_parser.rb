module SimpleViews
  class TemplateParser
    attr_accessor :raw_templates

    # Read a file and fetch its __END__ section, if any
    #
    # === Parameters
    # file<String,Pathname>:: File to find in-file templates in
    #
    # :api: public
    def initialize(file)
      parts = Pathname(file).read.split('__END__')
      self.raw_templates = parts.size > 1 ? parts.last : nil
    end
  end
end
