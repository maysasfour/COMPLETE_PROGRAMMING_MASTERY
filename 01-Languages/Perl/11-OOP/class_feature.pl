#!/usr/bin/env perl
use v5.38;
use feature 'class';
no warnings 'experimental::class';

class Point {
    field $x :param = 0;
    field $y :param = 0;

    method show {
        return "($x, $y)";
    }

    method move ($dx, $dy) {
        $x += $dx;
        $y += $dy;
    }
}

my $p = Point->new(x => 3, y => 4);
print $p->show, "\n";
$p->move(1, -1);
print $p->show, "\n";

class Point3D :isa(Point) {
    field $z :param = 0;
    method show {
        my $base = $self->SUPER::show;
        return "${base} z=$z";
    }
}
my $p3 = Point3D->new(x => 1, y => 2, z => 9);
print $p3->show, "\n";
