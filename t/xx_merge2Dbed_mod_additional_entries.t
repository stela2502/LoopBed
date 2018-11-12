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
my $outpath = "$plugin_path/data/output/MoreCols";
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


my $cmd = "(cd $outpath && perl -I $plugin_path/../lib  $exec "

  #   . " -res 0"
  . join(" ", map{"$plugin_path/data/$_.bed" } qw(A B C D) )

  #. " -git_server " . $git_server
  #. " -git_user " . $git_user
  . "$debug" 
  #. " 2>$outpath/error.out 1>$outpath/std.out"
  . ")"
;
my $start = time;
print( $cmd. "\n" );
system($cmd );
my $duration = time - $start;
print "Execution time: $duration s\n";

#my $err = slurpFile("$outpath/error.out");
my $out;

ok ( -f "$outpath/debug.bed", "debug outfile existing" );

$exp = slurpFile("$plugin_path/data/additional_debug.bed.csv" );

$value = slurpFile("$outpath/debug.bed" );

is_deeply( $value, $exp, "debug file contains right data" );


sub slurpFile {
	my $file = shift;
	open( my $in, "<$file" ) or die "I could not open the infile '$file'\n$!\n";
	my @r;
	while (<$in>) {
		chomp();
		push( @r, [ split( "\t", $_ ) ] );
	}
	close($in);
	return \@r;
}

#print "\$exp = ".root->print_perl_var_def($value ).";\n";
