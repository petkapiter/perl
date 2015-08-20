#!/usr/bin/perl

use strict;
use warnings;
use Net::Appliance::Session;
use Getopt::Long;

my $version = "0.1";
my %opt = (
			"version"	=> 0,
			"help"		=> 0,
			"ip"		=> 0,
			"login"		=> 0,
			"password"	=> 0,
			"enable"	=> 0,
			"bank"		=> 0,
			"group"		=> 0,
);

GetOptions(\%opt,
				'version',
				'help',
				'ip=s',
				'login=s',
				'password=s',
				'enable=s',
				'bank=s',
				'group=s'
);
if (defined $opt{'help'} && $opt{'help'} == 1) { 
&usage;
}
sub usage {
			print 
			"-i, --ip		Host IP\n".
			"-l, --login		Username\n".
			"-p, --password		Password\n".
			"-e, --enable		Secret Password\n".
			"-b, --bank		Bank's IP\n".
			"-h, --help		Display this help and exit\n".
			"-v, --version		Print version info\n";
			"-g, --group	ciso asa group\n";
			exit;
}

if (defined $opt{'version'} && $opt{'version'} == 1) {
print ( "Add to WS-Users group - (C) 2015 version $version\n" );
exit;
}

if (defined $opt{'ip'} && $opt{'ip'} eq 0){
print ( "Host IP: " );
chomp ($opt{'ip'} = <STDIN>);
}
if (defined $opt{'login'} && $opt{'login'} eq 0){
print ( "Username: " );
chomp ($opt{'login'} = <STDIN>);
}
if (defined $opt{'password'} && $opt{'password'} eq 0){
print ( "Password: " );
chomp ($opt{'password'} = <STDIN>);
}
if (defined $opt{'enable'} && $opt{'enable'} eq 0){
print ( "Enable Password: " );
chomp ($opt{'enable'} = <STDIN>);
}
if (defined $opt{'bank'} && $opt{'bank'} eq 0){
print ( "Bank's IP address: " );
chomp ($opt{'bank'} = <STDIN>);
}
if (defined $opt{'group'} && $opt{'group'} eq 0){
print ( "Group: " );
chomp ($opt{'group'} = <STDIN>);
}



my $ssh = Net::Appliance::Session->new({ 
										personality => 'ios',
										transport => 'SSH',
										timeout => '4',
										host => $opt{ip}
});

$ssh->connect({
				username => $opt{login},
				password => $opt{password}
});
				
$ssh->begin_privileged({ password => $opt{enable}});
$ssh->begin_configure;
$ssh->cmd( "object-group network $opt{group}" );
$ssh->cmd( "network-object host $opt{bank}" );
$ssh->cmd( "write memory" );
$ssh->end_configure;
$ssh->end_privileged;
$ssh ->close;
