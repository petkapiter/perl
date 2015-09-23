#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use Term::ANSIColor;

my $id = 26063;
my $url = "http://export.yandex.ru/weather-ng/forecasts/$id.xml";
my $xml = get("$url");
our $var;
#print "$xml\n\n\n\n";

if ($xml =~ /<fact>/){
	if ($' =~ /\<\/fact>/){
	$var = "$`";
#	print "$var\n";
	}
}
if ($var =~ /(\<weather_condition code=")(\w+)/){
	print "Weather condition - $2\n";
}
if ($var =~ /(\d+)(\<\/temperature\>)/){
	print "temperature  - $1C\n";
}
if ($var =~ /(\w+)(\<\/wind_direction\>)/){
	print "wind direction - $1\n";
}
if ($var =~ /([+-]?\d+\.?\d*)(\<\/wind_speed\>)/){
	print "Wind speed - $1KpH\n";
}
if ($var =~ /(\d+)(\<\/pressure\>)/){
	print "pressure - $1\n";
}
if ($var =~ /(\d+)(\<\/water_temperature\>)/){
	print "wather temperature - $1\n";
}
