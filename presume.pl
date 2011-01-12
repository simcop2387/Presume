#!/usr/bin/perl

use strict;
use warnings;

use lib './lib'; #make configurable?

use Presume::Gui;

my $gui = Presume::Gui->new();

print "Running...\n";
$gui->run;
print "Thank you for using presume\n";
