#!/usr/bin/perl

use strict;
use warnings;

my $host = '192.168.1.1';
my $user = 'root';
my $passwd = 'adminpas';
my ($t, @output);

	## Create a Net::Telnet object.
	use Net::Telnet ();
	$t = new Net::Telnet (Timeout  => 10);

	## Connect and login.
	$t->open($host);
	$t->waitfor('/login: ?$/i');
	$t->print($user);
	$t->waitfor('/password: ?$/i');
	$t->print($passwd);

	## Switch to a known shell, using a known prompt.
	$t->prompt('/<xPROMPTx> $/');
	$t->errmode("return");
	$t->cmd("exec /usr/bin/env 'PS1=<xPROMPTx> ' /bin/sh -i") or die "login failed to remote host $host";
	$t->errmode("die");

	## Now you can do cmd() to your heart's content.
	@output = $t->cmd("uname -a");
	print @output;
	exit;
