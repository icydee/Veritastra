package RPG::Veritastra;

use strict;
use lib '/data/Veritastra/lib';
use Module::Find qw(useall);
use RPG::Veritastra::DB;
use RPG::Veritastra::Queue;
use Config::JSON;

useall __PACKAGE__;

our $VERSION = 0.0001;

my $config = Config::JSON->new('/data/Veritastra/etc/veritastra.conf');
my $db = RPG::Veritastra::DB->connect(
    $config->get('db/dsn'),
    $config->get('db/username'),
    $config->get('db/password'), 
    { mysql_enable_utf8 => 1},
);

my $cache = RPG::Veritastra::Cache->new(servers => $config->get('memcached'));
my $queue;

if ($config->get('beanstalk')) {
    $queue = RPG::Veritastra::Queue->new({
        server      => $config->get('beanstalk/server'),
        ttr         => $config->get('beanstalk/ttr'),
        debug       => $config->get('beanstalk/debug'),
    });
}

sub version {
    return $VERSION;
}

sub config {
    return $config;
}

sub db {
    return $db;
}

sub cache {
    return $cache;
}

sub queue {
    return $queue;
}

1;
