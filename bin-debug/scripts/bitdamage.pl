#!/usr/bin/perl
#
# XOR a single byte in a file at a certain location
# greg@kixeye.com
#

use strict;
use POSIX;

	my $FLIP = 255;

	if ( 2 != scalar( @ARGV ) ) {
		die "Usage: bitdamage.pl filename bytelocation";
	}

	my $BYTELOCATION = $ARGV[1];

	if($BYTELOCATION == 0) {
		print "bitdamage disabled\n";
		exit(0);
	}

	sysopen(DATA, $ARGV[0], POSIX::O_RDWR) or die "Could not open $ARGV[0]";
	binmode DATA;

	(seek(DATA, $BYTELOCATION, 0) == 1) or die "Seek failed";

	my $buf;

	(sysread(DATA,$buf,1) == 1) or die "sysread failed";

	my $n = ord($buf);
	$n = $n ^ $FLIP;
	$buf = chr($n);

	(seek(DATA, $BYTELOCATION, 0) == 1) or die "Seek failed";

	(syswrite(DATA,$buf,1) == 1) or die "syswrite failed";

	close(DATA);

