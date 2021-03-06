package RPG::Veritastra::DB::Result::Log::Player;

use Moose;
use namespace::autoclean;

extends 'RPG::Veritastra::DB::Result::Log';

__PACKAGE__->table('log_player');
__PACKAGE__->add_columns(
    player_id               => { data_type => 'int', size => 11, is_nullable => 0 },
    player_name             => { data_type => 'varchar', size => 30, is_nullable => 0 },
);

after 'sqlt_deploy_hook' => sub {
    my ($self, $sqlt_table) = @_;
    $sqlt_table->add_index(name => 'idx_player_id',     fields => ['player_id']);
    $sqlt_table->add_index(name => 'idx_player_name',   fields => ['player_name']);
};


__PACKAGE__->meta->make_immutable(inline_constructor => 0);
