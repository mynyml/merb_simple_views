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
      def show
        obj = Object.new; def obj.to_html() '<b>x</b>' end
        display(obj)
      end
      def new
        obj = Object.new; def obj.to_html() '<b>y</b>' end
        display(obj)
      end
    end
    @posts_controller = Posts.new(fake_request)
    # -----
    clean_view_dir!
  end

  it "should be injected in Merb::Controller" do
    Merb::Controller.included_modules.should include(SimpleViews::Mixin)
  end

  it "should parse in-file templates on render" do
    @posts_controller._dispatch(:index)
    @posts_controller._template_parser.parsed_templates['index.html.erb'].should == "kittehs"
  end

  it "should parse in-file templates on display" do
    @posts_controller._dispatch(:show)
    @posts_controller._template_parser.parsed_templates['show.html.erb'].should == "kitteh-01"
  end

  it "should delegate to regular render control flow when no in-file template exists" do
    write_template('edit.html.erb', "<i>ohaie!</i>", @posts_controller)
    @posts_controller._dispatch(:edit)
    @posts_controller.body.should == "<i>ohaie!</i>"
  end

  it "should delegate to regular display control flow when no in-file template exists" do
    @posts_controller._dispatch(:new)
    @posts_controller.body.should == "<b>y</b>"
  end
end

__END__
@@ index.html.erb
kittehs

@@ show.html.erb
kitteh-01
