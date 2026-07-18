#!/usr/bin/env perl
use strict;
use warnings;

# ---- Traditional, bless-based OOP (the way Perl OOP has worked since Perl 5) ----
# A "class" is just a package; an "object" is just a blessed reference
# (usually a hashref) whose ref() now reports the package name instead of
# "HASH". Every method is a plain sub taking the invocant as its first @_
# element by convention -- there is no hidden `self`/`this` magic.
package Animal {
    sub new {
        my ($class, %args) = @_;
        my $self = { name => $args{name}, sound => $args{sound} // "..." };
        return bless $self, $class;
    }
    sub name  { return $_[0]->{name}; }
    sub speak {
        my $self = shift;
        return sprintf("%s says %s", $self->{name}, $self->{sound});
    }
}

package Dog {
    our @ISA = ('Animal');    # classic inheritance: populate @ISA directly
    sub new {
        my ($class, %args) = @_;
        $args{sound} = "Woof";
        my $self = Animal::new($class, %args);
        return $self;
    }
    sub fetch { return $_[0]->{name} . " fetches the ball!"; }
}

my $generic = Animal->new(name => "Generic", sound => "...");
my $dog     = Dog->new(name => "Rex");
print $generic->speak(), "\n";
print $dog->speak(), "\n";      # inherited method, works via @ISA
print $dog->fetch(), "\n";
print "isa check: ", ($dog->isa('Animal') ? "Dog IS-A Animal" : "no"), "\n";
print "ref(\$dog): ", ref($dog), "\n";   # confirms bless changed ref() from "HASH" to "Dog"

# ---- Perl 5.38's native `use feature 'class'` ----
# A genuinely newer, cleaner alternative syntax -- but STILL EXPLICITLY
# EXPERIMENTAL in 5.38.2 (perl itself emits a compile-time warning unless
# silenced), confirmed live below rather than assumed.
use feature 'class';
no warnings 'experimental::class';

class Point {
    field $x :param = 0;
    field $y :param = 0;

    method coords { return "($x, $y)"; }
    method move_by($dx, $dy) { $x += $dx; $y += $dy; }
}

my $p = Point->new(x => 3, y => 4);
print "native class point: ", $p->coords, "\n";
$p->move_by(1, 1);
print "after move_by: ", $p->coords, "\n";
