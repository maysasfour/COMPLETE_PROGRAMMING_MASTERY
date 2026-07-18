#!/usr/bin/env perl
use strict;
use warnings;

package Animal;
sub new {
    my ($class, %args) = @_;
    my $self = { name => $args{name} // 'Unknown', sound => $args{sound} // '...' };
    return bless $self, $class;
}
sub speak {
    my $self = shift;
    return "$self->{name} says $self->{sound}";
}

package Dog;
our @ISA = ('Animal');   # classic inheritance mechanism
sub new {
    my ($class, %args) = @_;
    $args{sound} //= 'Woof';
    my $self = Animal::new($class, %args);
    return $self;
}
sub fetch { my $self = shift; return "$self->{name} fetches the ball"; }

package main;

my $generic = Animal->new(name => 'Creature', sound => 'Grr');
my $dog     = Dog->new(name => 'Rex');

print $generic->speak, "\n";
print $dog->speak, "\n";      # inherited
print $dog->fetch, "\n";
print "dog isa Animal? ", ($dog->isa('Animal') ? "yes" : "no"), "\n";
print "ref(\$dog) = ", ref($dog), "\n";
