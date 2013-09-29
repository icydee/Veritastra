package RPG::Veritastra::DB::Result::SG::Player;

use Moose;
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


__PACKAGE__->meta->make_immutable(inline_constructor => 0);
