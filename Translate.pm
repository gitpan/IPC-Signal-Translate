# $Id: Translate.pm,v 1.1 1997-05-14 22:48:48-04 roderick Exp $
#
# Copyright (c) 1997 Roderick Schertler.  All rights reserved.  This
# program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

package IPC::Signal::Translate;

use strict;
use vars	qw($VERSION @ISA @EXPORT @EXPORT_OK %Sig_num @Sig_name);
BEGIN {
    require 5.002; # prototypes
}

require Exporter;

$VERSION	= 0.01;
@ISA		= qw(Exporter);
@EXPORT		= qw(sig_num sig_name);
@EXPORT_OK	= qw(sig_setup %Sig_num @Sig_name);
%Sig_num	= ();
@Sig_name	= ();

sub sig_setup () {
    return if %Sig_num && @Sig_name;

    require Config;
    my @name	= split ' ', $Config::Config{sig_name};
    my @num	= split ' ', $Config::Config{sig_num};

    @name			or die 'No signals defined';
    @name == @num		or die 'Signal name/number mismatch';

    @Sig_num{@name} = @num;
    keys %Sig_num == @name	or die 'Duplicate signal names present';
    for (@name) {
	$Sig_name[$Sig_num{$_}] ||= $_;
    }
}

sub sig_num ($) {
    my $sig_name = shift;
    sig_setup unless %Sig_num;
    return $Sig_num{$sig_name};
}

sub sig_name ($) {
    my $sig_num = shift;
    sig_setup unless @Sig_name;
    return $Sig_name[$sig_num] || $sig_num;
}

1

__END__

=head1 NAME

IPC::Signal::Translate - Translate signal names to/from numbers

=head1 SYNOPSIS

    $number = sig_num $name;
    $name   = sig_name $number;

    sig_setup;
    $number = $Sig_num{$name};
    $name   = $Sig_name[$number];

=head1 DESCRIPTION

This module contains functions for translating signal numbers to names,
and vice versa.

B<sig_num> and B<sig_name> are exported by default, the other symbols are
available by request.

=over

=item B<sig_num> I<chopped-signal-name>

Returns the signal number of the signal whose name (sans C<SIG>) is
I<chopped-signal-name>, or undef if there is no such signal.

This function is prototyped to take a single scalar argument.

=item B<sig_name> I<signal-number>

Returns the chopped signal name (like C<HUP>) of signal number
I<signal-number>, or undef if there is no such signal.

This function is prototyped to take a single scalar argument.

=item B<sig_setup>

If you want to use the @Sig_name and %Sig_num variables directly you must
call B<sig_setup> to initialize them.  This isn't necessary if you only
use the function interfaces sig_name() and sig_num().

This function is prototyped to take no arguments.

=item B<%Sig_num>

A hash with chopped signal name keys (like C<HUP>) and integer signal
number values.

=item B<@Sig_name>

An array mapping signal numbers to chopped signal names (like C<HUP>).

=back

=head1 AUTHOR

Roderick Schertler <F<roderick@argon.org>>

=head1 SEE ALSO

perl(1).

=cut
