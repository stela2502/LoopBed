#! /usr/bin/perl
use strict;
use warnings;
use stefans_libs::root;
use File::Path;
use Test::More tests => 3;
use stefans_libs::flexible_data_structures::data_table;

use FindBin;
my $plugin_path = "$FindBin::Bin";

my ( $value, @values, $exp, $path, $name, $git_server, $git_user, $debug );

my $exec = $plugin_path . "/../bin/merge2Dbed_mod.pl";
ok( -f $exec, 'the script has been found' );
my $outpath = "$plugin_path/data/output/merge2Dbed_mod";
@values = ( 'error.out', 'std.out' );

if ( -d $outpath ) {
	map { unlink("$outpath/$_") if ( -f "$outpath/$_" ) } @values;
}
else {
	File::Path::make_path($outpath);
}

$path = "$plugin_path/data/output/merge2Dbed_mod";

$debug = "";
if (0) {
	$debug = " -debug";
}

my $cmd = "perl -I $plugin_path/../lib  $exec "

  #   . " -res 0"
  . " $plugin_path/data/EBF1.tiny.headerless.bed" . " $plugin_path/data/IKZF1.tiny.headerless.bed"

  #. " -git_server " . $git_server
  #. " -git_user " . $git_user
  . "$debug" . " 2>$outpath/error.out 1>$outpath/std.out"
;
my $start = time;
print( $cmd. "\n" );
system($cmd );
my $duration = time - $start;
print "Execution time: $duration s\n";

my $err = slurpFile("$outpath/error.out");

$exp = [
	[ 'Features', "$plugin_path/data/EBF1.tiny.headerless.bed", "$plugin_path/data/IKZF1.tiny.headerless.bed", 'Name' ],
	[ '1', '',  'X', "$plugin_path/data/IKZF1.tiny.headerless.bed" ],
	[ '3', 'X', '',  "$plugin_path/data/EBF1.tiny.headerless.bed" ],
	[
		'4', 'X', 'X',
		"$plugin_path/data/EBF1.tiny.headerless.bed|$plugin_path/data/IKZF1.tiny.headerless.bed"
	]
];

is_deeply( [ @$err[ 13 .. 16 ] ], $exp, "error file correct" );

my $out = slurpFile("$outpath/std.out");

#print "\$exp = " . root->print_perl_var_def($out) . ";\n";
$exp = [ 
[ '#merged=8', 'chr1', 'start1', 'end1', '#chr2', 'start2', 'end2', 'EBF1.tiny.headerless.bed [n]', 'IKZF1.tiny.headerless.bed [n]', 'EBF1.tiny.headerless.bed: info 1', 'EBF1.tiny.headerless.bed: info 2', 'IKZF1.tiny.headerless.bed: info 1', 'IKZF1.tiny.headerless.bed: info 2' ], [ 'chr1', '755000', '760000', 'chr1', '778420', '778642', '0', '1', '0', '0', '0', '0' ], [ 'chr1', '15025000', '15030000', 'chr1', '15251335', '15251553', '1', '0', '1', '0', '0', '0' ], [ 'chr10', '91175237', '91175455', 'chr10', '91400000', '91405000', '1', '0', '10', '0', '0', '0' ], [ 'chr10', '92863644', '92863862', 'chr10', '92920000', '92925000', '1', '0', '0', '10', '0', '0' ], [ 'chr1', '1092861', '1093183', 'chr1', '1165000', '1170000', '1', '1', '1', '0', '1', '1' ], [ 'chr1', '15025000', '15030000', 'chr1', '15062470', '15062696', '1', '1', '0', '1', '0', '1' ], [ 'chr10', '91055000', '91065000', 'chr10', '91088008', '91120000', '2', '4', '0', '2', '2', '2' ], [ 'chr10', '91088008', '91095000', 'chr10', '91125000', '91175000', '3', '3', '1', '1', '1', '2' ] ];



is_deeply( $out, $exp, "error file correct" );

sub slurpFile {
	my $file = shift;
	open( my $in, "<$file" ) or die $!;
	my @r;
	while (<$in>) {
		chomp();
		push( @r, [ split( "\t", $_ ) ] );
	}
	close($in);
	return \@r;
}

#print "\$exp = ".root->print_perl_var_def($value ).";\n";
