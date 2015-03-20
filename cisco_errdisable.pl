#!/usr/bin/perl -w
	use strict;
	use warnings;
	use Net::Appliance::Session;
	use Getopt::Long;
	
	my $help;
	my $host;
	my $login;
	my $password;
	my $secret;
	GetOptions('help' =>\$help, 'ip=s' =>\$host, 'login=s' => \$login, 'password=s' => \$password, 'enable=s' => \$secret);

		if (defined $help){
		print "--ip or -i		Host IP\n--login or -l		Username\n--password or -p	password\n--enable or -e		Secret Password\n";
		exit;
		}

		unless (defined $host){
			print "Host IP: " ;
			chomp ($host = <STDIN>);
		}

		unless (defined $login){
			print "Username: ";
			chomp ($login = <STDIN>);
		}

			unless (defined $password){
			print "Password: ";
			chomp ($password = <STDIN>);
		}

		unless (defined $secret){
			print "Enable Password: ";
		        chomp ($secret = <STDIN>);
		}

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

	
	
