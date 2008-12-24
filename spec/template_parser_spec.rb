require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Parser" do

  before(:each) do
    @parser = SimpleViews::TemplateParser.new(__FILE__)
  end

  it "should load in-file templates" do
    @parser.raw_templates.should match(/ohaie/)
  end

  describe "when parsing template strings" do

    it "should split templates at @@ marks" do
      @parser.raw = %|
        @@ index
        kittehs
        @@ show
        kitteh1
      |.unindent
      @parser.parse.size.should == 2
      @parser.parse['index'].strip.should == 'kittehs'
      @parser.parse['show'].strip.should  == 'kitteh1'
    end

    it "should remove trailing witespace off every template" do
      @parser.raw = %|
        @@ index

        kittehs \t\n
      |.unindent
      @parser.parse['index'].should_not match(/\t\n$/)
      @parser.parse['index'].should     match(/^\n/)
    end

    it "should not be bothered by amount of spaces or tabs between marker and template name" do
      @parser.raw = %|
        @@index
        kittehs
        @@\t\sshow
        kitteh1
      |.unindent
      @parser.parse['index'].should_not be_nil
      @parser.parse['show'].should_not be_nil
      @parser.parse["\t\sshow"].should be_nil
    end
  end
end

__END__
ohaie
