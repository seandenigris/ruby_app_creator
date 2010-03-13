# env.rb
# 
#
# Created by Sean DeNigris on 11/16/09.
# Copyright 2009 Clipper Adams, Inc.. All rights reserved.

$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
require 'ruby_app_creator'
require 'ruby_1_9_functionality'

# Check if two text files are the same
# See Ruby Cookbook, by Lucas Carlson and Leonard Richardson. Copyright 2006 O'Reilly Media, Inc., 0-596-52369-6
#class File
		#def self.contents_equal?(p1, p2)
			#return false if File.exists?(p1) != File.exists?(p2)
			#return true if !File.exists?(p1)
			#return true if File.expand_path(p1) == File.expand_path(p2)
			#return false if File.ftype(p1) != File.ftype(p2) ||
				 #File.size(p1) != File.size(p2)

			#open(p1) do |f1|
				#open(p2) do |f2|
					#blocksize = f1.lstat.blksize
					#same = true
					#while same && !f1.eof? && !f2.eof?
						#same = f1.read(blocksize) == f2.read(blocksize)
					#end
					#return same
				#end
			#end
		#end
#end
