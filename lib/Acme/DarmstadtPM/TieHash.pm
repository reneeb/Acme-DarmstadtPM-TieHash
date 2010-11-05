package Acme::DarmstadtPM::TieHash;

use strict;
use warnings;

use Tie::ListKeyedHash;

our $VERSION = '0.3';

sub TIEHASH{
    my ($class,$code) = @_;
    
    
    my $self = {};
    my %hash;
    bless $self,$class;
    
    tie %hash,'Tie::ListKeyedHash';
    $self->{HASH} = \%hash;
    $self->{CODE} = $code;
    
    return $self;
}

sub FETCH{
    my ($self,$key) = @_;
    
    if (not ref $key) {
        $key = [split(/$;/,$key)];
    }
    
    unless(exists $self->{HASH}->{$key}){
        $self->{HASH}->{$key} = $self->{CODE}->(@$key);
    }
    
    return $self->{HASH}->{$key};
}

sub STORE{
    my ($self,$key,$value) = @_;
    
    if (not ref $key) {
        $key = [split(/$;/,$key)];
    }
    
    $self->{HASH}->{$key} = $value;
}

sub DELETE{
    my ($self,$key) = @_;

    if (not ref $key) {
        $key = [split(/$;/,$key)];
    }
    
    delete $self->{HASH}->{$key};
}

sub EXISTS{
    my ($self,$key) = @_;

    if (not ref $key) {
        $key = [split(/$;/,$key)];
    }

    return exists $self->{HASH}->{$key} ? 1 : 0;
}

sub CLEAR{
    my ($self) = @_;
    $self->{HASH} = ();
}

sub FIRSTKEY{
	my ($self) = @_;
	
	my $a = keys %{$self->{HASH}}; 
	my $key = scalar each %{$self->{HASH}};
	return if (not defined $key);
	return [$key];
}

sub NEXTKEY {
	my ($self,$last_key) = @_;
	my $key = scalar each %{$self->{HASH}};
	return if (not defined $key);
	return [$key];
}

1;

__END__

=pod

=head1 NAME

Acme::DarmstadtPM::TieHash - a module that shows that Perl can do all the Ruby things ;-)

=head1 SYNOPSIS

   1 #!/usr/bin/perl
   2
   3 use strict;
   4 use warnings;
   5 use Test::More tests => 2;
   6
   7 use constant ADT => 'Acme::DarmstadtPM::TieHash';
   8 
   9 use_ok(ADT);
  10 
  11 tie my %hash,ADT,sub{$_[0] + $_[-1]};
  12 
  13 is($hash{[1,5]},6,'Check [1,5]');
  14 
  15 untie %hash;

=head1 ABSTRACT

Test

=head1 DESCRIPTION

Ronnie Neumann sent a mail to the mailinglist with some good Ruby stuff. I said, that all these
things can be done in Perl, too. So this module is a proof how smart Perl is...

=head1 AUTHOR AND LICENSE

copyright 2006 (c)
Renee Baecker E<lt>module@renee-baecker.deE<gt>


This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.

=cut
