require 'fileutils'

module RubyApplicationCreator
	class CreateApplicationProcedure
		def initialize(application_name, template_processor)
			@application_name = application_name
			@template_processor = template_processor
		end

		def execute
			create_application_directory

			in_application_directory do
				create_sub_directories

				[
					["autotest/discover.rb", 'autotest_discover.rb'],
					['spec/spec.opts', 'spec.opts']
				].each do |installation_path, template_name|
					create_file_from_static_template installation_path, template_name
				end

				[
					['rakefile', 'rakefile'],
					['features/support/env.rb', 'cucumber_support_env.rb.liquid'],
					["lib/#{application_name}.rb", 'main_project_require.rb.liquid'],
					["spec/spec_helper.rb", 'spec_helper.rb.liquid'],
					["bin/#{application_name}", 'executable.liquid']
				].each do |installation_path, template_name|
					create_file_from_dynamic_template installation_path, template_name
				end

				FileUtils.touch 'User Stories.txt'
			end
		end

		private
		attr_reader :application_name, :template_processor

		def create_application_directory
			Dir.mkdir application_name
		end

		def in_application_directory(&block)
			p Dir.pwd
			Dir.chdir application_name do
				yield
			end
			p Dir.pwd
		end

		def create_sub_directories
			%W{
					autotest
					bin
					config
					features
					features/step_definitions
					features/support
					lib
					lib/#{application_name}
					spec
					spec/cucumber
					spec/#{application_name}
			}.each { |directory| Dir.mkdir(directory) }
		end

		def create_file_from_static_template(installation_path, template_name)
			FileUtils.cp RubyApplicationCreator.project_directory("lib/ruby_app_creator/templates/#{template_name}"), installation_path
		end

		def create_file_from_dynamic_template(installation_path, template_name)
			template_path = RubyApplicationCreator.project_directory "lib/ruby_app_creator/templates/#{template_name}"
			placeholder_values = { 'application_name' => application_name }
			template_processor.fill_to template_path, placeholder_values, installation_path
		end
	end
end
