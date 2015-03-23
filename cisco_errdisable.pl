#!/usr/bin/perl
	use strict;
	use warnings;
	use Net::Appliance::Session;
	use Getopt::Long;
	use Term::ANSIColor;

	
	my $version = "0.2";
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
			print "Cisco_errdisable - (C) 2015 version $version\n";
			exit;
	}

	if (defined $opt{'ip'} && $opt{'ip'} eq 0){
			print "Host IP: " ;
			chomp ($opt{'ip'} = <STDIN>);
	}
	 if (defined $opt{'login'} && $opt{'login'} eq 0){
	 		print "Username: " ;
	 		chomp ($opt{'login'} = <STDIN>);
	}

	if (defined $opt{'password'} && $opt{'password'} eq 0){
			print "Password: ";
			chomp ($opt{'password'} = <STDIN>);
	}
	if (defined $opt{'enable'} && $opt{'enable'} eq 0){
			print "Enable Password: ";
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
		}) ;
	$ssh->begin_privileged({ password => $opt{enable}});
	print my $errdisable = $ssh->cmd( 'show errdisable recovery' );
	if ($errdisable =~ m/Gi\w+\/\w+\/\w+/i){ #Вычленяем строку вида gi91/0/1
		print color 'red';
		print "Found $&\n";
		print color 'reset';
	}else {
		print "Not found\n";
		$ssh->end_privileged;
		$ssh ->close;
		exit;
	}
	

	
	$ssh->end_privileged;
	$ssh ->close;
