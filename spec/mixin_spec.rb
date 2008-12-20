require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Simple Views" do

  before(:each) do
    class Posts < Merb::Controller
      def index; render; end
    end
    @posts_controller = Posts.new(fake_request)
  end

  it "should be injected in Merb::Controller" do
    Merb::Controller.included_modules.should include(SimpleViews::Mixin)
  end
end
