require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Simple Views" do

  before(:all) do
    Merb.root.should == Pathname(__FILE__).dirname.parent.expand_path.to_s
    views_dir = Pathname(Merb.root / "spec/fixtures/views")
    views_dir.mkdir unless views_dir.directory?
    Merb.push_path(:view, views_dir, "**/*")
  end

  before(:each) do
    class Posts < Merb::Controller
      def index() render  end
      def edit()  render  end
      def quote() render  end
      def show
        obj = Object.new; def obj.to_html() '<b>x</b>' end
        display(obj)
      end
      def new
        obj = Object.new; def obj.to_html() '<b>y</b>' end
        display(obj)
      end
    end
    @posts = Posts.new(fake_request)
    # -----
    clean_view_dir!
  end

  it "should be injected in Merb::Controller" do
    Merb::Controller.included_modules.should include(SimpleViews::Mixin)
  end

  describe "parsing templates" do

    it "should parse in-file templates on render" do
      @posts._dispatch(:index)
      @posts._template_parser.parsed_templates['index.html.erb'].should == "kittehs"
      @posts.body.should == "kittehs"
    end

    it "should parse in-file templates on display" do
      @posts._dispatch(:show)
      @posts._template_parser.parsed_templates['show.html.erb'].should == "kitteh-01"
      @posts.body.should == "kitteh-01"
    end

    it "should parse absolute paths" do
      @posts._dispatch(:quote)
      @posts._template_parser.parsed_templates['/posts/quote.html.erb'].should == "<i>kitteh-01</i>"
      @posts.body.should == "<i>kitteh-01</i>"
    end

    describe "falling back to default behaviour" do

      it "should delegate to regular render control flow when no in-file template exists" do
        write_template('edit.html.erb', "<i>ohaie!</i>", @posts)
        @posts._dispatch(:edit)
        @posts.body.should == "<i>ohaie!</i>"
      end

      it "should delegate to regular display control flow when no in-file template exists" do
        @posts._dispatch(:new)
        @posts.body.should == "<b>y</b>"
      end
    end
  end
end

__END__
@@ index.html.erb
kittehs

@@ show.html.erb
kitteh-01

@@ /posts/quote.html.erb
<i>kitteh-01</i>
