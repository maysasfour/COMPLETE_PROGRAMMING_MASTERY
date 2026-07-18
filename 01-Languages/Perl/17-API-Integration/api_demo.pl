#!/usr/bin/env perl
use strict;
use warnings;
use HTTP::Tiny;
use JSON::PP;

# NOTE: this msys2 Perl build has no CA bundle configured, so default SSL
# verification fails with "Couldn't find a CA bundle..." (verified below).
# verify_SSL => 0 works around that for this demo; a production script
# should install Mozilla::CA (from CPAN) instead of disabling verification.
my $http = HTTP::Tiny->new(timeout => 10, verify_SSL => 0);

# GET
my $get_resp = $http->get('https://jsonplaceholder.typicode.com/todos/1');
print "GET status: $get_resp->{status} $get_resp->{reason}\n";
if ($get_resp->{success}) {
    my $data = decode_json($get_resp->{content});
    print "userId=$data->{userId} id=$data->{id} title=$data->{title} completed=$data->{completed}\n";
}

# POST
my $payload = encode_json({ title => 'perl test', body => 'hello from perl', userId => 1 });
my $post_resp = $http->post('https://jsonplaceholder.typicode.com/posts', {
    headers => { 'Content-Type' => 'application/json' },
    content => $payload,
});
print "\nPOST status: $post_resp->{status} $post_resp->{reason}\n";
if ($post_resp->{success}) {
    my $created = decode_json($post_resp->{content});
    print "created id=$created->{id} title=$created->{title}\n";
}
