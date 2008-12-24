module SimpleViews
  class TemplateParser
    attr_accessor :raw_templates
    alias :raw  :raw_templates
    alias :raw= :raw_templates=

    def initialize
      self.raw_templates = ''
    end

    # Read a file and fetch its __END__ section, if any
    #
    # === Parameters
    # file<String,Pathname>:: File to find in-file templates in
    #
    # === Returns
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
      templates.each {|key,value| templates[key.chomp.gsub(/[[:blank:]]|\t/,'')] = value.rstrip }
    end
  end
end
