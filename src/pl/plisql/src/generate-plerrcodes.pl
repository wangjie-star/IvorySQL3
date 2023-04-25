#!/usr/bin/perl
#
# Generate the plerrcodes.h header from ora_errcodes.txt
# Copyright (c) 2023, IvorySQL-2.0 Global Development Group

use strict;
use warnings;

print
  "/* autogenerated from src/backend/utils/ora_errcodes.txt, do not edit */\n";
print "/* there is deliberately not an #ifndef PLERRCODES_H here */\n";

open my $errcodes, '<', $ARGV[0] or die;

while (<$errcodes>)
{
	chomp;

	# Skip comments
	next if /^#/;
	next if /^\s*$/;

	# Skip section headers
	next if /^Section:/;

	die unless /^([^\s]{5})\s+([EWS])\s+([^\s]+)(?:\s+)?([^\s]+)?/;

	(my $sqlstate, my $type, my $errcode_macro, my $condition_name) =
	  ($1, $2, $3, $4);

	# Skip non-errors
	next unless $type eq 'E';

	# Skip lines without PL/iSQL condition names
	next unless defined($condition_name);

	print "\n{\n\t\"$condition_name\", $errcode_macro\n},\n";
}

close $errcodes;
