package RPG::Veritastra::DB::Result::Log::PlayerNameChange;

use Moose;
extends 'RPG::Veritastra::DB::Result::Log::Player';

__PACKAGE__->table('log_player_name_change');
__PACKAGE__->add_columns(
    new_player_name             => { data_type => 'varchar', size => 30, is_nullable => 0 },
);

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
