#!/usr/bin/env perl

use strict;

use FindBin::libs;
use Test::More;

use RPG::Veritastra;

my $db      = RPG::Veritastra->db;
my $redis   = RPG::Veritastra->redis;

my $player = $db->resultset('SG::Player')->create({
    name                => 'icydee',
    password            => 'secret',
    password_sitter1    => 'secret',
    password_sitter2    => 'secret',
    email               => 'me@iain-docherty.com',
    real_name           => 'Iain C Docherty',
    lucre               => '100',
    happiness           => '20',
});

diag $player;

my $lucre = $redis->get('sg:player:redis:'.$player->id);
is($lucre, 100, 'We have 100 lucre');



done_testing();
