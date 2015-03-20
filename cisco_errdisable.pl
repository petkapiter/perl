#!/usr/bin/perl -w
	use strict;
	use Net::SSH::Perl;
	print "Host IP: " ;
	chomp (my $host = <STDIN>);
	print "Username: ";
	chomp (my $login = <STDIN>);
	print "Password: ";
	chomp (my $password = <STDIN>);
	my $cmd = "ls -hal";
&connect;
print "Ok\n";
sub connect {
	my $ssh = Net::SSH::Perl->new($host);
	$ssh->login($login, $password);
	my ($out) = $ssh->cmd("$cmd");
	print ("$out\n");
}
