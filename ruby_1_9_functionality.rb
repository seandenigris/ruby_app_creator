require 'rbconfig'

if Config::CONFIG['ruby_version'].to_f >= 1.9
	warn "You are including workarounds for pre-1.9 Ruby with a version of Ruby that doesn't need them"
else
	class Dir
		def self.exist?(path)
			File.directory? path
		end

		class << self
			alias exists? exist?
		end
	end

	def require_relative(relative_feature)
		# From Programming Ruby 1.9, pg. 256
		c = caller.first
		fail "Can't parse #{c}" unless c.rindex(/:\d+(:in `.*')?$/)
		file = $`
		if /\A\((.*)\)/ =~ file # eval, etc.
			raise LoadError, "require_relative is called in #{$1}"
		end
		absolute = File.expand_path(relative_feature, File.dirname(file))
		require absolute
	end
end
