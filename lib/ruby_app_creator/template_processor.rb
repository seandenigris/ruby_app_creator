require "rubygems"
require "liquid"

class TemplateProcessor
	def fill_to template_path, placeholder_values, installation_path
		template_contents = IO.read template_path
		File.new(installation_path, "w") << Liquid::Template.parse(template_contents).render(placeholder_values)
	end
end
