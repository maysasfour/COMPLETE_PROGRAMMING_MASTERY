package TaskStore;
use strict;
use warnings;
use JSON::PP;
use Fcntl qw(:flock);

# File-based JSON persistence for the Task Tracker.
#
# DBI/DBD::SQLite are confirmed NOT installed in this environment
# (see ../../16-Database-Access/README.md's live environment check),
# so this store uses JSON::PP + file I/O instead -- the same
# core-Perl-only technique established in ../../10-File-Handling
# and already used for the "kv store" style exercises in this course.
# This keeps the mini-project runnable end-to-end, rather than
# depending on a module that fails to load here.

sub new {
    my ($class, %args) = @_;
    my $self = {
        path  => $args{path} // 'tasks.json',
        tasks => [],
        next_id => 1,
    };
    my $self_obj = bless $self, $class;
    $self_obj->_load;
    return $self_obj;
}

sub _load {
    my ($self) = @_;
    return unless -e $self->{path};
    open my $fh, '<', $self->{path} or die "cannot open $self->{path}: $!";
    flock $fh, LOCK_SH;
    local $/;
    my $json = <$fh>;
    close $fh;
    return unless defined $json && length $json;
    my $data = decode_json($json);
    $self->{tasks}   = $data->{tasks}   // [];
    $self->{next_id} = $data->{next_id} // 1;
}

sub _save {
    my ($self) = @_;
    open my $fh, '>', $self->{path} or die "cannot write $self->{path}: $!";
    flock $fh, LOCK_EX;
    print $fh encode_json({ tasks => $self->{tasks}, next_id => $self->{next_id} });
    close $fh;
}

sub add {
    my ($self, $title) = @_;
    die "title must not be empty\n" unless defined $title && length $title;
    my $task = { id => $self->{next_id}++, title => $title, done => 0 };
    push @{ $self->{tasks} }, $task;
    $self->_save;
    return $task;
}

sub list {
    my ($self) = @_;
    return @{ $self->{tasks} };
}

sub complete {
    my ($self, $id) = @_;
    for my $task (@{ $self->{tasks} }) {
        if ($task->{id} == $id) {
            $task->{done} = 1;
            $self->_save;
            return $task;
        }
    }
    die "no task with id $id\n";
}

sub remove {
    my ($self, $id) = @_;
    my $before = scalar @{ $self->{tasks} };
    $self->{tasks} = [ grep { $_->{id} != $id } @{ $self->{tasks} } ];
    die "no task with id $id\n" if @{ $self->{tasks} } == $before;
    $self->_save;
    return 1;
}

1;
