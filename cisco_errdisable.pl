#!/usr/bin/perl -w
	use strict;
	use  Net::Appliance::Session;
	print "Host IP: " ;
	chomp (my $host = <STDIN>);
	print "Username: ";
	chomp (my $login = <STDIN>);
	print "Password: ";
	chomp (my $password = <STDIN>);
	print "Enable Password: ";
        chomp (my $secret = <STDIN>);
	my $ssh = Net::Appliance::Session->new({ 
		personality => 'ios',
		transport => 'SSH',
		host => $host});
	$ssh->connect({
		username => $login, 
		password => $password,
		privileged_password => $secret
		});
	$ssh->begin_privileged;
	print $ssh->cmd('show logging');
	$ssh->end_privileged;
	$ssh ->close;
