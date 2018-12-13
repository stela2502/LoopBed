#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
BEGIN { use_ok 'LoopBed::AddCols' }

use FindBin;
my $plugin_path = "$FindBin::Bin";

my ( $value, @values, $exp );
my $OBJ = LoopBed::AddCols -> new({'debug' => 1});
is_deeply ( ref($OBJ) , 'LoopBed::AddCols', 'simple test of function LoopBed::AddCols -> new() ');

#print "\$exp = ".root->print_perl_var_def($value ).";\n";


