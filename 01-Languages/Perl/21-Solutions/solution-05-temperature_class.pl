#!/usr/bin/env perl
use strict;
use warnings;

# Ex5: Using bless-based OOP, write a Temperature class with new(celsius=>N),
# to_fahrenheit method, and to_string method.
package Temperature;

sub new {
    my ($class, %args) = @_;
    my $self = { celsius => $args{celsius} };
    return bless $self, $class;
}

sub to_fahrenheit {
    my ($self) = @_;
    return $self->{celsius} * 9 / 5 + 32;
}

sub to_string {
    my ($self) = @_;
    return sprintf("%.1fC (%.1fF)", $self->{celsius}, $self->to_fahrenheit);
}

package main;

my @samples = (0, 37, 100, -40);
for my $c (@samples) {
    my $t = Temperature->new(celsius => $c);
    print $t->to_string, "\n";
}
