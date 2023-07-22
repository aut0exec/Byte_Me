#!/usr/bin/perl 

use strict;
use warnings;
use Getopt::Long 'HelpMessage';

my $VERSION = 'v0.1';
my $FORMAT = 'DEFAULT';
my $Seq_Start = 0;
my $Seq_Stop = 255;
my %Bad_Bytes = ();

GetOptions (
	'f=s' => sub { if ( uc($_[1]) =~ 'RAW' ) { $FORMAT = 'RAW'} ;},
	'b=s' => \&Check_Badbytes,
	'e=s' => \&Check_Badbytes,
	's=s' => \&Check_Badbytes,
	'o=s' => \my $OUTFILE,
	'help|h'  => sub { HelpMessage(0) }, 
	'version|v'  => sub { print ("Version: $VERSION\n"); exit 0; },
) or HelpMessage(1);

sub Check_Badbytes {
	my $user_chars = lc($_[1]);
	my @bad_chars = split(/x/, $user_chars);

	foreach (@bad_chars) {
		if ( $_ eq "" ) { next; }
		elsif( not $_ =~ /^[0-9a-f][0-9a-f]$/ ) {
			print ( $_ . " : is an invalid hexadecmial byte!\n");
			HelpMessage(1);
		}
		elsif ( $_[0] eq 's' ) { $Seq_Start = hex($_); last;}
		elsif ( $_[0] eq 'e' ) { $Seq_Stop = hex($_);  last;}
		else { $Bad_Bytes{hex($_)} = 1;}
	}

	if ( $Seq_Start >= $Seq_Stop ) {
		print ("Start byte can't be equal to or greater than Stop byte!\n");
		HelpMessage(1);
	}
}

sub Byte_Gen {
	my %hex_hash = %{$_[0]};
	my $fh;

	if ( defined $OUTFILE) {
		print ("Opening file: $OUTFILE \n");
		open ($fh, '>:raw', "$OUTFILE") or die "Unable to open: $!";
		print ("Writing bytes to file: $OUTFILE ");
	}
	else { print ("Bytes: \n\n"); }

	foreach my $i ($Seq_Start..$Seq_Stop) {
		if (exists($hex_hash{$i})) { next; }
		elsif ( defined $fh && $FORMAT eq 'RAW') { print $fh pack('C', $i); }
		elsif ( defined $fh && $FORMAT eq 'DEFAULT') { print $fh ( "\\x" . sprintf("%02x", $i)); }
		else { print ( "\\x" . sprintf("%02x", $i)); }
	}
	
	print ("\nDone creating byte array!\n");
	
	if (defined $fh) {
		print ("Closing file $OUTFILE \n");
		close($fh);
	}
}


############## MAIN ###############

Byte_Gen(\%Bad_Bytes);

#### POD DATA #####
=head1 DESCRIPTION
 
 Byte_Me is a custom tool for generating bytes for testing in shellcode

=head1 SYNOPSIS
 
 Byte_Me.pl [[-b | -e | -s ] HEX]  [-f FORMAT] [-o FILE]
 -b HEX         Known bad bytes in \x00 form. Multiple can be used (ex. \x00\x01)
 -o FILE        Output bytes to FILE
 -f FORMAT      Output format; RAW (only useful with -o) or DEFAULT ( \x00\x01 Format)
 -s BYTE        Start byte array at BYTE (ex. -s \x20 )
 -e BYTE        End byte array at BYTE (ex -e \xab)
 --version,-v   Print Version information
 --help,-h      Print this help

=head1 VERSION

 0.2

=head1 HISTORY

 Version 0.1
	Initial creation
 Version 0.2
	Added ability to specify start and stop bytes

=cut
