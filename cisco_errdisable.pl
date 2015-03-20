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
#	print "Password enable mode: ";
#	chomp (my $enapassword = <STDIN>);

&connect;
print "Ok\n";
#print "$cmd"
sub connect {
	my $ssh = Net::SSH::Perl->new($host);
	$ssh->login($login, $password);
	my ($out, $err, $exit) = $ssh->cmd("$cmd");
	print ("$out\n");
}
