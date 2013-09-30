package RPG::Veritastra::DB::Result::SG::Player;

use Moose;
use RPG::Veritastra;
use namespace::autoclean;

extends 'RPG::Veritastra::DB::Result::Player';

__PACKAGE__->table('player');
__PACKAGE__->add_columns(
    lucre           => { redis => 1, data_type => 'int',    size => 11, is_nullable => 0, default => 0 },
    happiness       => { redis => 1, data_type => 'int',    size => 11, is_nullable => 0, default => 0 },
);

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;
}

has redis => (
    is      => 'ro',
    lazy    => 1,
    builder => '_build_redis',
);

sub _build_redis {
    my ($self) = @_;

    return RPG::Veritastra->redis;
}

# Namespace to identify in the Redis database
#
sub namespace {
    my ($self, $part) = @_;

    return "sg:player:$part";
}

# Get/Set lucre in the Redis database
#
around lucre  => sub {
    my ($orig, $self) = (shift, shift);

    my $namespace   = $self->namespace('lucre');

    if (@_) {
        $self->redis->set($namespace, $self->id, $_[0]);
        return $self->$orig(@_);
    }
    else {
        my $val = $self->redis->get($namespace, $self->id);
        return $self->$orig($val);
    }
};

# Get/Set happiness in the Redis database
#
around happiness => sub {
    my ($orig, $self) = (shift, shift);

    my $namespace   = $self->namespace('happiness');

    if (@_) {
        $self->redis->set($namespace, $self->id, $_[0]);
        return $self->$orig(@_);
    }
    else {
        my $val = $self->redis->get($namespace, $self->id);
        return $self->$orig($val);
    }
};

# Handle deletion of Redis when object is deleted
#
before delete => sub {
    my ($self) = @_;

    foreach my $arg (qw(redis happiness)) {
        my $namespace = $self->namespace($arg);
        $self->redis->delete($namespace);
    }
};

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
