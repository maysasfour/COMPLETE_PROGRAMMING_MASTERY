#!/usr/bin/env perl
use strict;
use warnings;
use feature 'try';
no warnings 'experimental::try';
use JSON::PP;

print "=== 1. Word frequency counter ===\n";
{
    my $text = "the quick brown fox the lazy dog the fox runs";
    my %freq;
    $freq{lc $_}++ for split /\s+/, $text;
    for my $word (sort { $freq{$b} <=> $freq{$a} or $a cmp $b } keys %freq) {
        print "$word: $freq{$word}\n";
    }
}

print "\n=== 2. Version comparator ===\n";
{
    sub compare_versions {
        my ($a, $b) = @_;
        my @pa = split /\./, $a;
        my @pb = split /\./, $b;
        for my $i (0 .. (@pa > @pb ? $#pa : $#pb)) {
            my $na = $pa[$i] // 0;
            my $nb = $pb[$i] // 0;
            my $cmp = $na <=> $nb;
            return $cmp if $cmp != 0;
        }
        return 0;
    }
    my @versions = ("1.10.0", "1.9.0", "1.2.0");
    my @sorted = sort { compare_versions($a, $b) } @versions;
    print "sorted correctly (semantic): @sorted\n";
    print "plain string cmp (wrong, for comparison): ", join(" ", sort @versions), "\n";
}

print "\n=== 3. Retry with backoff ===\n";
{
    sub retry_with_backoff {
        my ($fn, $max_attempts) = @_;
        my $delay = 1;
        for my $attempt (1 .. $max_attempts) {
            my $result = eval { $fn->($attempt) };
            return $result unless $@;
            print "  attempt $attempt failed: $@";
            die $@ if $attempt == $max_attempts;
            $delay *= 2;   # (sleep skipped in this demo to keep it fast; real code would `sleep $delay`)
        }
    }
    my $tries = 0;
    my $result = retry_with_backoff(sub {
        my $attempt = shift;
        $tries++;
        die "not yet\n" if $attempt < 3;
        return "succeeded on attempt $attempt";
    }, 5);
    print "$result (total tries: $tries)\n";
}

print "\n=== 4. Custom exception hierarchy ===\n";
{
    package AppError {
        sub new { my ($c, %a) = @_; return bless { message => $a{message} // 'error' }, $c; }
        sub message { return $_[0]->{message}; }
    }
    package NotFoundError   { our @ISA = ('AppError'); }
    package ValidationError { our @ISA = ('AppError'); }

    for my $err (NotFoundError->new(message => "user not found"), ValidationError->new(message => "bad email")) {
        try {
            die $err;
        } catch ($e) {
            if    ($e->isa('NotFoundError'))   { print "handled NotFoundError: ",   $e->message, "\n"; }
            elsif ($e->isa('ValidationError')) { print "handled ValidationError: ", $e->message, "\n"; }
            elsif ($e->isa('AppError'))        { print "handled generic AppError: ", $e->message, "\n"; }
        }
    }
}

print "\n=== 5. Enumerable-style pipeline ===\n";
{
    my @people = (
        { name => "Zoe",   age => 25 },
        { name => "Amir",  age => 16 },
        { name => "Beth",  age => 30 },
        { name => "Cal",   age => 17 },
    );
    my @adult_names = sort map { $_->{name} } grep { $_->{age} >= 18 } @people;
    print "adults (sorted): @adult_names\n";
}

print "\n=== 6. Config validator via hash slice ===\n";
{
    my %config = (host => "localhost", port => 5432, user => undef);
    my @required = qw(host port user password);
    my @missing = grep { !defined $config{$_} } @required;
    print "missing/undefined required keys: ", join(", ", @missing), "\n";
}

print "\n=== 7. File-based key/value store ===\n";
{
    my $path = "kv_store_demo.json";
    sub kv_load { return -e $path ? decode_json(do { open my $fh, '<', $path; local $/; <$fh> }) : {}; }
    sub kv_save { my $h = shift; open my $fh, '>', $path or die $!; print $fh encode_json($h); }
    sub kv_set  { my ($k, $v) = @_; my $h = kv_load(); $h->{$k} = $v; kv_save($h); }
    sub kv_get  { my ($k) = @_; my $h = kv_load(); return $h->{$k}; }

    kv_set("language", "Perl");
    kv_set("version", "5.38.2");
    print "kv_get('language') = ", kv_get("language"), "\n";
    print "kv_get('version')  = ", kv_get("version"), "\n";
    unlink($path);
}
