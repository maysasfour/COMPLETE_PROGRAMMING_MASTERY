#!/usr/bin/env perl
use strict;
use warnings;
use HTTP::Tiny;   # confirmed bundled core module in this Perl (`perl -MHTTP::Tiny -e 1` succeeds)
use JSON::PP;

# GOTCHA found live while writing this lesson: a plain HTTPS request with
# HTTP::Tiny failed here with status 599 "Internal Exception" / "Couldn't
# find a CA bundle with which to verify the SSL certificate" -- IO::Socket::SSL
# IS present, but this environment has no CA bundle configured anywhere
# HTTP::Tiny looks by default. The fix did NOT require installing anything:
# this Git-for-Windows install already ships a real CA bundle at
# mingw64/etc/ssl/certs/ca-bundle.crt; pointing SSL_CERT_FILE at it (an env
# var IO::Socket::SSL/Net::SSLeay respect) was enough.
$ENV{SSL_CERT_FILE} //= 'C:/Program Files/Git/mingw64/etc/ssl/certs/ca-bundle.crt';

my $http = HTTP::Tiny->new(timeout => 10);

# Real, live GET against the shared public test API this repository uses
# throughout its other language courses.
my $response = $http->get('https://jsonplaceholder.typicode.com/todos/1');
if ($response->{success}) {
    my $todo = decode_json($response->{content});
    print "GET /todos/1 -> status $response->{status}\n";
    print "  title: $todo->{title}\n";
    print "  completed: ", ($todo->{completed} ? "true" : "false"), "\n";
} else {
    print "GET failed: $response->{status} $response->{reason}\n";
}

# The "doesn't throw on 404" trap, verified live: HTTP::Tiny (like fetch()
# in JS, Net::HTTP in Ruby, and every other stdlib HTTP client in this
# repository) returns a normal response object for a 404 -- it does NOT
# raise/die automatically. Code that assumes failure always means "an
# exception was thrown" will silently mishandle a 404 unless it explicitly
# checks ->{success} or ->{status}.
my $missing = $http->get('https://jsonplaceholder.typicode.com/todos/99999');
print "GET /todos/99999 -> status $missing->{status}, success=", ($missing->{success} ? "true" : "false"), "\n";

sub safe_get_json {
    my ($url) = @_;
    my $res = $http->get($url);
    die "HTTP $res->{status}: $res->{reason}\n" unless $res->{success};
    return decode_json($res->{content});
}

eval {
    safe_get_json('https://jsonplaceholder.typicode.com/todos/99999');
};
print "safe_get_json correctly raised: ", ($@ ? "yes ($@)" : "no"), "" if $@;

# POST with a JSON body
my $post_response = $http->post(
    'https://jsonplaceholder.typicode.com/posts',
    {
        headers => { 'Content-Type' => 'application/json' },
        content => encode_json({ title => 'Perl course', body => 'hello', userId => 1 }),
    }
);
if ($post_response->{success}) {
    my $created = decode_json($post_response->{content});
    print "POST /posts -> status $post_response->{status}, new id: $created->{id}\n";
}
