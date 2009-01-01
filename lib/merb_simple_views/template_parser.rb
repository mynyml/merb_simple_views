module SimpleViews
  class TemplateParser
    # templates as a string, directly extracted from the file.
    attr_accessor :raw_templates
    alias :raw    :raw_templates
    alias :raw=   :raw_templates=

    # templates as a {'name' => 'content'} hash
    attr_accessor  :parsed_templates
    alias :parsed  :raw_templates
    alias :parsed= :raw_templates=

    def initialize
      self.raw_templates    = ''
      self.parsed_templates = {}
    end

    # Read a file and fetch its __END__ section, if any.
    #
    # ==== Parameters
    # file<String,Pathname>:: File to find in-file templates in
    #
    # ==== Returns
    # self
    #
    # :api: public
    def load(file='')
      file = Pathname(file)
      if file.exist?
        parts = file.read.split(/^__END__$/)
        if parts.size > 1
          self.raw_templates = parts[1].lstrip
        end
      end
      self
    end

    # Parse templates string and extract template names and contents.
    #
    # Template names must be preceded with '@@', appear alone on their line,
    # and follow the same conventions regular templates do. They can also be
    # disabled by simply commenting out their name.
    #
    # ==== Parameters
    # file<String,Pathname>:: File to find in-file templates in
    #
    # ==== Returns
    # Hash:: Parsed templates as {'name' => 'content'}
    #
    # ==== Examples
    #
    #   #posts_controller.rb
    #   [...]
    #   __END__
    #   @@ index.html.erb
    #   posts
    #
    #   @@ show.html.erb
    #   post01
    #
    #   #=> {'index.html.erb' => "posts", 'show.html.erb' => "post01"}
    #
    # To disable a template, comment out its name:
    #
    #   __END__
    #   #@@ index.html.erb
    #   posts
    #
    #   #=> {}
    #
    # ==== Notes
    # Also stores the result in self.parsed_templates
    #
    # :api: public
    def parse(file='')
      self.load(file) if file
      templates, current, ignore = {}, nil, false
      self.raw_templates.each_line do |line|
        if matches = line.strip.match(/^\s*(\#)*\s*@@\s*(.*)/)
          ignore = (matches[1] && matches[1].match(/^#/)) and next #skip commented out templates
          templates[current = matches[2]] = ''
        elsif ignore
          next
        elsif current
          templates[current] << line
        end
      end
      # remove trailing witespace off every template body and template name
      self.parsed_templates = templates.each {|key,value| templates[key.chomp.gsub(/[[:blank:]]|\t/,'')] = value.rstrip }
      self.parsed_templates
    end
  end
end
