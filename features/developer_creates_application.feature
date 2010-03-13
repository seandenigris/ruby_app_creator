Feature: developer creates a skeleton Ruby application

	In order to get to the beach more quickly
	As a developer
	I want to instantly create a basic Ruby application skeleton

		Scenario: create a new application
			Given I want to create a new application named "my_amazing_new_application"
			And I am in my projects directory
			And a sub-directory with the name of my application does not exist
			When I type "ruby_app [my application's name]"
			Then there should be a directory in my projects directory with my application's name
			And the following directories should exist under the application directory:
				|	sub-directory							|
				|	autotest									|
				|	bin												|
				|	config										|
				|	features									|
				|	features/step_definitions	|
				|	features/support					|
				|	lib												|
				|	lib/{{application_name}}	|
				|	spec											|
				|	spec/cucumber							|
				|	spec/{{application_name}}	|
			And there should be an "autotest/discover.rb" file with:
      """
      # Include features in autotest
      ENV['AUTOFEATURE'] = 'true'

      # Uncomment to enable 'example' naming convention (instead of spec/*_spec)
      #Autotest.add_discovery { "rspec" }
      """

			And there should be a "bin/{{application_name}}" file with:
      """
      #!/usr/bin/env ruby

      $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
      require "{{application_name}}"
      """

			And there should be a "features/support/env.rb" file with:
      """
      $LOAD_PATH << File.expand_path('../../../lib', __FILE__)
      require '{{application_name}}'
      """

			And there should be a "lib/{{application_name}}.rb" file with:
      """
      lib_dir = File.join(File.dirname(__FILE__), {{application_name}})
      rbfiles = Dir.entries(lib_dir).select { |x| /\.rb\z/ =~ x }

      rbfiles.each do |path|
      	full_file_path = File.join(lib_dir, path)
      	require full_file_path
      end
      """

			And there should be a "rakefile" file with:
      """
      task :default => [:features, :examples]

      # Cucumber dependencies
      require 'cucumber'
      require 'cucumber/rake/task'

      # Rspec dependencies
      require 'rake'
      require 'spec/rake/spectask'

      desc "Run Features"
      Cucumber::Rake::Task.new(:features) do |t|
        #t.cucumber_opts = "features --format pretty"
      end

      desc "Run Feature-support Examples"
      Spec::Rake::SpecTask.new('support_examples') do |t|
        t.spec_files = FileList['spec/cucumber/**/*spec.rb']
      end

      desc "Run Examples"
      Spec::Rake::SpecTask.new('examples') do |t|
        t.spec_files = FileList['spec/{{application_name}}/**/*spec.rb']
      end

      desc "Explain and verify how third-party libraries work"
      Spec::Rake::SpecTask.new('contracts') do |t|
        t.spec_files = FileList['spec/third_party/**/*spec.rb']
      	t.spec_opts = ["--format", "nested"]
      end
      """

			And there should be a "spec/spec_helper.rb" file with:
      """
      require '{{application_name}}'
      """

			And there should be a "spec/spec.opts" file with:
      """
      --color
      """

			And there should be an empty "User Stories.txt" file
