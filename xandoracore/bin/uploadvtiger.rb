#!/usr/bin/ruby

require "getoptlong"
require "enumerator"
require "httpclient"
require "tempfile"

customeremail	= ARGV[0].to_s
malwarestr	= ARGV[1].to_s

#User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.4) Gecko/20091016 Firefox/3.5.4
login_uri       = 'http://support.pandasecurity.com.my/CustomerAuthenticate.php'
new_ticket      = 'http://support.pandasecurity.com.my/index.php?module=&action=&fun=&module=HelpDesk&action=index&fun=saveticket'
agent 		= "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.4) Gecko/20091016 Firefox/3.5.4"


c = HTTPClient.new
c.set_cookie_store("cookie.dat")
c.debug_dev = STDERR
 
        form = {
                'username'              => 'malware@pandasecurity.com.my', 
                'pw'                    => '0x3tyu65',
                'login_language'        => 'en_us'
                }

        createcase = {
                'title'         => 'AFA: ' + customeremail + ' - ' + malwarestr,
                'category'      => 'Support',
                'description'   => 'Hello Support,

		File name : '+ malwarestr +' , in this compressed file. 
		Detailed Report: http://a.pandasecurity.my/?s=' + malwarestr + '

		File: '+ malwarestr +' - the binary
		File: '+ malwarestr +'.pcap - Malware generated traffic
		File: generatedfiles.txt - Comparison for virtual machine image before and after malware runs.
		Folder: screenshots - Screenshot from Sandbox. 
		
		Dump Content: http://ap.pandasecurity.my/download.php?f=' + malwarestr + '
		
		Customer Email: ' + customeremail +'
                
		From PandaSecurity (Malaysia)',
                'button'        => 'Save'
        }


        extheader = {
                'User-Agent'    => agent,
                'Content-Type'  => "application/x-www-form-urlencoded"
                }



c.post(login_uri, form, extheader)
get_ticketid = c.post(new_ticket, createcase, extheader)

get_ticketid.content.scan(/var ticketid = ([0-9]+)\;/).each do |tid|
                @newticketid = "#{tid}".to_s
                                        end
p @newticketid


#submitfileurl   = "http://support.pandasecurity.com.my/index.php"
#submitform      = {
#                'module'        => 'HelpDesk',
#                'action'        => 'index',
#                'fun'           => 'uploadfile',
#                'ticketid'      => @newticketid,
#                'customerfile'  => open(malwarefile)  
#                }
#
#boundary = Array::new(8){ "%2.2d" % rand(42) }.join('__')
#boundary = "#{boundary}".to_s
#submitfileheader = {
#        'content-type' => "multipart/form-data; boundary=___"+boundary+"__"
#        }
#c.post_content (submitfileurl, submitform, submitfileheader)

#p @newticketid
#p @newticketid
