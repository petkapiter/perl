#!/usr/bin/perl -w
	use strict;
	use warnings;
	use Net::Appliance::Session;
	use Getopt::Long;
	
	my $host = '';
	my $login = '';
	my $password = '';
	my $secret = '';
	GetOptions('host=s' =>\$host, 'login=s' => \$login, 'password=s' => \$password, 'enable=s' => \$secret);

#	print "Host IP: " ;
#	chomp (my $host = <STDIN>);
#	print "Username: ";
#	chomp (my $login = <STDIN>);
#	print "Password: ";
#	chomp (my $password = <STDIN>);
#	print "Enable Password: ";
#        chomp (my $secret = <STDIN>);
	
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
	print $ssh->cmd('show errdisable recovery');
	$ssh->end_privileged;
	$ssh ->close;

	
	
