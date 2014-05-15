#!/usr/bin/env ruby
require 'net/smtp'
require 'optparse'

options = {
	:port => 25,
	:ssl => false,
	:helo => "nagios",
	:authtype => "login"
}
OptionParser.new do |opts|
	opts.banner = "Usage: check_smtp_auth.rb [options]"
	opts.on("-s", "--server VALUE", String, "Server hostname") { |value| options[:server] = value }
	opts.on("-P", "--port VALUE", String, "Server port [25]") { |value| options[:port] = value }
	opts.on("-u", "--username VALUE", String, "Username") { |value| options[:username] = value }
	opts.on("-p", "--password VALUE", String, "Password") { |value| options[:password] = value }
	opts.on("-a", "--authtype VALUE", String, "AuhtType [login]") { |value| options[:authtype] = value }
	opts.on("-l", "--helo VALUE", String, "Helo domain [nagios]") { |value| options[:helo] = value }
	opts.on("-h", "--help", "Show this message") { puts opts; exit }
end.parse!

if not (options[:server] and options[:username] and options[:password])
	puts "WARNING: Plugin error"; exit(1)
end

smtp = Net::SMTP.new(options[:server], options[:port])
begin
	smtp_conn = smtp.start(options[:helo], options[:username], options[:password], options[:authtype])
	puts "OK: Login OK"; exit(0)	
rescue => e
	puts "CRITICAL: Login FAILED (#{e.to_s.strip})"; exit(2)
end
