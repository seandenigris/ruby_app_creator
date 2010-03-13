lib_dir = File.join(File.dirname(__FILE__), my_amazing_new_application)
rbfiles = Dir.entries(lib_dir).select { |x| /\.rb\z/ =~ x }

rbfiles.each do |path|
	full_file_path = File.join(lib_dir, path)
	require full_file_path
end
