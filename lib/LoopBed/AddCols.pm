package LoopBed::AddCols;

#use FindBin;
#use lib "$FindBin::Bin/../lib/";
#created by bib_create.pl from  commit 
use strict;
use warnings;

=head1 LICENCE

  Copyright (C) 2018-11-12 Stefan Lang

  This program is free software; you can redistribute it 
  and/or modify it under the terms of the GNU General Public License 
  as published by the Free Software Foundation; 
  either version 3 of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful, 
  but WITHOUT ANY WARRANTY; without even the implied warranty of 
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
  See the GNU General Public License for more details.

  You should have received a copy of the GNU General Public License 
  along with this program; if not, see <http://www.gnu.org/licenses/>.


=for comment

This document is in Pod format.  To read this, use a Pod formatter,
like 'perldoc perlpod'.

=head1 NAME

LoopBed::AddCols

=head1 DESCRIPTION

A class to keep track about the additional columns and how to merge them.

A AddCols object only contains data for one summary bed file line.
It is part of a DoublePeak entry and should not be used on its own.
Its main use is to keep track of all additional columns and merge them in the correct way.

=head2 depends on


=cut


=head1 METHODS

=head2 new ( $filename, $data )

new returns a new object reference of the class LoopBed::AddCols.

The filename should be a filename and the data a reference to an array of integers.

=cut

sub new{

	my ( $class, $filename, $data ) = @_;

	my ( $self );

	$self = {
		data => {},
		counts => undef,
  	};
  	
  	if ( defined $data) {
		$self->{'data'}->{$filename} = [map{ if ( $_ ) { $_} else { 0 } } @$data];
  	}
  	
  	bless $self, $class  if ( $class eq "LoopBed::AddCols" );

  	return $self;

}

sub add {
	my ( $self, $other ) = @_;
	
	#warn "add using fnames". join(" ", $self->unique( keys %{$self->{'data'}}, keys %{$other->{'data'}}))."\n";
	foreach my $fname ( $self->unique( keys %{$self->{'data'}}, keys %{$other->{'data'}})) {
		unless ( defined $self->{'data'}->{$fname} ){
			$self->{'data'}->{$fname} = $other->{'data'}->{$fname};
		}elsif ( defined $self->{'data'}->{$fname} and defined $other->{'data'}->{$fname} ) {
			for (my $i = 0; $i <@{$self->{'data'}->{$fname}}; $i++ ){
				@{$self->{'data'}->{$fname}}[$i] += @{$other->{'data'}->{$fname}}[$i]
			}
		}
	}
	return $self;
}

sub unique{
	my ( $self, @d) = @_;
	my $t = { map { $_ => 1} @d };
	return sort ( keys %$t );
}

sub asArray{
	my $self = shift;
	my @r;
	#warn ref($self)."::asArray() was called";
	foreach  my $fname( sort keys %{$self->{'counts'}} ){
		if ( ref($self->{'data'}->{$fname}) eq 'ARRAY'  ){
			push( @r,@{$self->{'data'}->{$fname}})
		}else { ## hmm - I need to add 0 values in the right amount
			push( @r, map{ '0' } 1..$self->{'counts'}->{$fname} );
		}
	}
	#warn ref($self)."::asArray() was called - returning an array of length ".$#r." and enties: ". join(",",@r);
	return @r;
}


1;
