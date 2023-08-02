#!/usr/bin/ruby

require "xmlrpc/client"
require "uri"

bloguser="xandora"
blogpass="rachel.221.928"

malwarestr      = ARGV[0].to_s

def get_file_as_string(filename)
	data = ''
	f = File.open(filename, "rb") 
	f.each_line do |line|
		data += line.to_s
	end
	return data
end

blogpost = get_file_as_string 'report.txt'



server = XMLRPC::Client.new3( :host=> "report.xandora.net", :path => "/xmlrpc.php")

server.call("metaWeblog.newPost", 0, bloguser, blogpass, { :title => "File Analyzer: " + malwarestr, :description => blogpost, :post_type=>"post", :mt_keywords => ["xandora"], :categories => ["File Analysis"],  :mt_allow_comments => 0, :mt_allow_pings => 1},  true)
