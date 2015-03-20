#!/usr/bin/perl -w
	use strict;
	use  Net::Appliance::Session;
	print "Host IP: " ;
	chomp (my $host = <STDIN>);
	print "Username: ";
	chomp (my $login = <STDIN>);
	print "Password: ";
	chomp (my $password = <STDIN>);
	my $ssh = Net::Appliance::Session->new({ 
		personality => 'ios',
		transport => 'SSH',
		host => $host});
	$ssh->connect({
		username => $login, 
		password => $password
		});
	print $ssh->cmd('show errdisable recovery');
	$ssh ->close;
