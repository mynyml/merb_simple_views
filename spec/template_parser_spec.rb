require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Parser" do

  it "should load in-file templates" do
    parser = SimpleViews::TemplateParser.new(__FILE__)
    parser.raw_templates.should match(/ohaie/)
  end
end

__END__
ohaie
