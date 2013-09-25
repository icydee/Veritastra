package RPG::Veritastra::DB::Result::SG::Player;

use Moose;
use namespace::autoclean;

extends 'RPG::Veritastra::DB::Result::Player';

__PACKAGE__->table('player');
__PACKAGE__->add_columns(
);

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;
}


__PACKAGE__->meta->make_immutable(inline_constructor => 0);
