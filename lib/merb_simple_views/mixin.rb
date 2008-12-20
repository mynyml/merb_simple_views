module SimpleViews
  module Mixin

    # When mixin is included in controller, define aliases to wrap #render and
    # #display
    #
    # ==== Parameters
    # base<Module>:: Merb::Controller object that is including Mixin
    #
    # ==== Notes
    # http://yehudakatz.com/2008/05/22/the-greatest-thing-since-sliced-merb/
    # "We consider cases of people using alias_method_chain on Merb to be a bug in
    # Merb, and try to find ways to expose enough functionality so it will not be
    # required."
    # So could this code be written otherwise, or is it an exception to the above
    # rule? what are the alternatives?
    #_
    # @public
    def self.included(base)
      unless method_defined?(:render_without_simple_views)
        base.class_eval { alias :render_without_simple_views :render    }
        base.class_eval { alias :render :render_with_simple_views       }
        base.class_eval { alias :display_without_simple_views :display  }
        base.class_eval { alias :display :display_with_simple_views     }
      end
    end

    def render_with_simple_views
    end

    def display_with_simple_views
    end
  end
end
