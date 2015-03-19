#!/usr/bin/perl -w
use Net::Telnet::Cisco;
print "Введите IP устройства: " ;
chomp (my $cdevice = <STDIN>);
print "Имя пользователя: ";
chomp (my $clogin = <STDIN>);
print "Введите пароль: ";
chomp (my $cpassword = <STDIN>);
print "Введите пароль enable: ";
chomp (my $enapassword = <STDIN>);
my $log = "srn.log";
warn "Файл $log уже существует" if -e $log;
&emts;
&go_file;
sub emts {
         my $session = Net::Telnet::Cisco->new(Host => $cdevice,
                                               Timeout => 20,
                                               Input_log => $log,
                                               );
        $session->login ($clogin, $cpassword);
        unless ($session->is_enabled) {
                $session->enable($enapassword);
        }
        $session->cmd("show inventory\n");
	$session->close;
}
sub go_file {
	open LOG, $log;
	open SRN, ">>srn";
	print SRN "=================================================================================\n";
	print SRN "$cdevice - \n";
	while (<LOG>) {
		if (/NAME|PID/) {
			print SRN $_;
		}
	}
	print SRN "=================================================================================\n";
	close SRN;
	close LOG;
}
