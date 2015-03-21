#!/usr/bin/perl
	use strict;
	use warnings;
	use Net::Appliance::Session;
	use Getopt::Long;
	
	my $version = "0.2";
	my %opt = (
			"version"	=> 0,
			"help"		=> 0,
			"ip"		=> 0,
			"login"		=> 0,
			"password"	=> 0,
			"secret"	=> 0,
	);

	GetOptions(\%opt,
			'version',
			'help',
			'ip=s',
			'login=s',
			'password=s',
			'secret=s',
	);
	if (defined $opt{'help'} && $opt{'help'} == 1) { 
			&usage;
	}

	sub usage {
			 print "-i, --ip		Host IP\n".
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
	if (defined $opt{'secret'} && $opt{'secret'} eq 0){
			print "Enable Password: ";
			chomp ($opt{'secret'} = <STDIN>);
	}


	my $ssh = Net::Appliance::Session->new({ 
		personality => 'ios',
		transport => 'SSH',
		host => $opt{ip}
	});
	$ssh->connect({
		username => $opt{login}, 
		password => $opt{password},
		privileged_password => $opt{secret}
		});
	$ssh->begin_privileged;
	print $ssh->cmd('show errdisable recovery');
	$ssh->end_privileged;
	$ssh ->close;
