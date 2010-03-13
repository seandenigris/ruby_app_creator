#def let(variable_name, &block)
	#p self
	#def 
	#class << self; attr_accessor :application_name; end

	#let(:var) {}
#end

Given /^I want to create a new application named "([^\"]*)"$/ do |app_name|
	class << self; attr_accessor :projects_directory, :application_name, :application_directory; end
	self.application_name = app_name
	self.projects_directory = RubyApplicationCreator.project_directory "tmp/projects"
	self.application_directory = File.join projects_directory, application_name
end

Given /^I am in my projects directory$/ do
	Dir.chdir(projects_directory)
end

Given /^a sub\-directory with the name of my application does not exist$/ do
	`rm -R #{application_directory}` if Dir.exists? application_directory
end

When /^I type "ruby_app \[my application's name\]"$/ do
	# In production, ruby_app would be installed under the system path
	# but here we fudge and find it drectly
	`../../bin/ruby_app #{application_name}`
end

Then /^there should be a directory in my projects directory with my application's name$/ do
	Dir.should exist(application_name)
end

def replace_application_name_placeholders(directory_name_template)
		directory_name_template.gsub /\{\{application_name\}\}/, application_name
end

def application_sub_directory(directory_table_row)
		directory_name_template = directory_table_row[0]
		replace_application_name_placeholders directory_name_template
end

Then /^the following directories should exist under the application directory:$/ do |directory_table|
  # table is a Cucumber::Ast::Table
	directory_table.rows.each do |directory_row|
		directory = application_sub_directory directory_row
		Dir.should(exist(File.join(application_directory, directory)), "#{directory} sub-directory doesn't exist!'")
	end
end

Then /^there should be an* "([^\"]*)" file with:$/ do |relative_path, expected_contents_template|
	destination_path = File.join(Dir.pwd, File.join(application_name, replace_application_name_placeholders(relative_path)))
	File.should exist(destination_path), "#{destination_path} file doesn't exist!"
	IO.read(destination_path).rstrip.should == replace_application_name_placeholders(expected_contents_template)
end

Then /^there should be an* empty "([^\"]*)" file$/ do |relative_path|
	destination_path = File.join(Dir.pwd, File.join(application_name, replace_application_name_placeholders(relative_path)))
	File.should exist(destination_path), "#{destination_path} file doesn't exist!"
end
