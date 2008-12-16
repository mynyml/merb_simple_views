# adaptest from autotest/merb_rspec.rb
require 'autotest'

class RspecCommandError < StandardError; end

class Autotest::RspecSimpleviews < Autotest
  def initialize
    super

    # Ignore any happenings in these directories
    add_exception %r%^\./(?:doc|log|tmp|autotest|bin|\.git|\.autotest)% 

    # Ignore any mappings that Autotest may have already set up
    clear_mappings

    # run all specs if spec_helper is modified
    add_mapping %r%^spec/spec_helper\.rb% do |_,_|
      all_specs
    end

    # run all specs if main lib file is modified
    add_mapping %r%^lib/merb_simple_views\.rb% do |_,_|
      all_specs
    end

    # changing a lib file runs corresponding spec
    add_mapping %r%^lib/merb_simple_views/(.*)\.rb% do |_, m|
      files_matching %r%^spec/.*#{m[1]}_spec\.rb$%
    end

    # Changing a spec will cause it to run itself
    add_mapping %r%^spec/.*_spec\.rb$% do |filename, _|
      filename
    end

  end

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  def failed_results(results)
    results.scan(/^\d+\)\n(?:\e\[\d*m)?(?:.*?Error in )?'([^\n]*)'(?: FAILED)?(?:\e\[\d*m)?\n(.*?)\n\n/m)
  end

  def handle_results(results)
    @failures      = failed_results(results)
    @files_to_test = consolidate_failures(@failures)
    @files_to_test.empty? && !$TESTING ? hook(:green) : hook(:red)
    @tainted = !@files_to_test.empty?
  end

  def consolidate_failures(failed)
    filters = Hash.new { |h,k| h[k] = [] }
    failed.each do |spec, failed_trace|
      if f = test_files_for(failed).find { |f| f =~ /spec\// }
        filters[f] << spec
        break
      end
    end
    filters
  end

  def make_test_cmd(specs_to_runs)
    [
      ruby,
      "-S",
      spec_command,
      add_options_if_present,
      files_to_test.keys.flatten.join(' ')
    ].join(' ')
  end

  def add_options_if_present
    File.exist?("spec/spec.opts") ? "-O spec/spec.opts " : ""
  end

  # Finds the proper spec command to use. Precendence is set in the
  # lazily-evaluated method spec_commands.  Alias + Override that in
  # ~/.autotest to provide a different spec command then the default
  # paths provided.
  def spec_command(separator=File::ALT_SEPARATOR)
    unless defined?(@spec_command)
      @spec_command = spec_commands.find { |cmd| File.exists?(cmd) }

      raise RspecCommandError, "No spec command could be found" unless @spec_command

      @spec_command.gsub!(File::SEPARATOR, separator) if separator
    end
    @spec_command
  end

  # Autotest will look for spec commands in the following
  # locations, in this order:
  #
  #   * default spec bin/loader installed in Rubygems
  #   * any spec command found in PATH
  def spec_commands
    [File.join(Config::CONFIG['bindir'], 'spec'), 'spec']
  end

  private

    # Runs +files_matching+ for all specs
    def all_specs
      files_matching %r%^spec/.*_spec\.rb$%
    end
end
