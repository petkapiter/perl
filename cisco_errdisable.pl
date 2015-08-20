#!/usr/bin/perl

use strict;
use warnings;
use Net::Appliance::Session; #Cisco ssh
use Getopt::Long; #add help
	
my $version = "0.3.2";
my $port;
my $mac;
our $question;
my %opt = (
		"version"	=> 0,
		"help"		=> 0,
		"ip"		=> 0,
		"login"		=> 0,
		"password"	=> 0,
		"enable"	=> 0,
);

GetOptions(\%opt,
		'version',
		'help',
		'ip=s',
		'login=s',
		'password=s',
		'enable=s',
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
		 "-h, --help		Display this help and exit\n".
		 "-v, --version		Print version info\n";
		 exit;
}
	if (defined $opt{'version'} && $opt{'version'} == 1) {
		print ( "Cisco_errdisable - (C) 2015 version $version\n" );
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
my $errdisable = $ssh->cmd( 'show errdisable recovery' );
print ( "$errdisable\n" );

if ($errdisable =~ m/Gi\w+\/\w+\/\w+/i){ #Вычленяем строку вида gi91/0/1
		$port = $&;
		$ssh->begin_privileged({ password => $opt{enable}});
		my $port_sec = $ssh->cmd( "show port-security interface $port | include Last" ); 
			if ($port_sec =~ m/(\w+.\w+.\w+):\d/i){
				$mac = $1;
				print ( "Bad mac adress $mac.\n" );
			}else{
				print ( "Not found mac address.\n" );
				$ssh->end_privileged;
				$ssh ->close;
				exit;
			}
		$question = yanq();
		print ( "$question\n" );

}else {
		print ( "Not found errdisable port.\n" );
		$ssh ->close; 
		exit;
}
if ($question =~ /y/i){
		$ssh->begin_privileged({ password => $opt{enable}});
		$ssh->cmd( "clear port-security sticky interface $port" );
		$ssh->cmd( "clear port-security sticky address $mac." );
		$ssh->begin_configure;
		$ssh->cmd ( "interface $port" );
		$ssh->cmd ( "shutdown" );
		$ssh->cmd ( "no shutdown" );
		$ssh->end_configure;
		$ssh->end_privileged;
		$ssh ->close;
		print ( "Interface - $port cleared.\n" );
		print ( "MAC address - $mac cleared\n" );
}else {
		print ( "Cancel\n" );
}
sub yanq {
		use Term::ReadKey;
		ReadMode 4;
		my $key = '';
		while ($key !~ /(Y|N)/i){
			1 while defined ReadKey -1; # discard any previous input
			print ( "Do you wont clear $port (Y/N): " );
			$key = ReadKey 0; # read a single character
		}
		ReadMode 0;
		return $key;
}
