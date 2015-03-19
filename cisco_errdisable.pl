#!/usr/bin/perl -w
	use strict;
	use Net::SSH::Perl;
	print "Host IP: " ;
	chomp (my $host = <STDIN>);
	print "Username: ";
	chomp (my $login = <STDIN>);
	print "Password: ";
	chomp (my $password = <STDIN>);
#	print "Password enable mode: ";
#	chomp (my $enapassword = <STDIN>);

&connect;
print "Ok\n";
sub connect {
	my $ssh = Net::SSH::Perl->new($host);
	$ssh->login($host, $password);
	$ssh->cmd("touch lalala");	
}
