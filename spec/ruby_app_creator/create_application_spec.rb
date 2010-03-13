require "spec_helper"

module RubyApplicationCreator
	describe CreateApplicationProcedure do

		APPLICATION_NAME = "my_amazing_new_application"
		
		describe "creating the directories and static files - tested in features"

		describe "creating dynamic files (an example, rest checked by features)" do
			let(:template_processor) { double('template processor').as_null_object }
			let(:creator) { CreateApplicationProcedure.new APPLICATION_NAME, template_processor }

			before( :each ) do
				Dir.stub(:mkdir).as_null_object
				Dir.stub(:chdir).and_yield
				File.stub(:new).and_return double('File').as_null_object
				FileUtils.stub :cp
			end

			[
				#['Cucumber env', 'lib/ruby_app_creator/templates/cucumber_support_env.rb.liquid', 'features/support/env.rb'],
				#['Main application lib', 'lib/ruby_app_creator/templates/main_project_require.rb.liquid', "lib/#{APPLICATION_NAME}.rb"],
				#['Spec helper', 'lib/ruby_app_creator/templates/spec_helper.rb.liquid', "spec/spec_helper.rb"],
				['Executable', 'lib/ruby_app_creator/templates/executable.liquid', "bin/#{APPLICATION_NAME}"]
			].each do |file_description, template_path, installation_path|

				it "should call the template processor to create the #{file_description} file" do
					placeholder_values = { 'application_name' => APPLICATION_NAME }

					# The current directory will be the main directory of the application being constructed
					# So we need to pass an an absolute path for the template file and a relative one for the installation path
					template_processor.should_receive(:fill_to).with RubyApplicationCreator.project_directory(template_path), placeholder_values, installation_path
					creator.execute
				end
			end
		end
	end
end
