package RPG::Veritastra::DB::Result::SG::Player::Attribute::Lucre;

use Moose;
use namespace::autoclean;

extends 'RPG::Veritastra::DB::Result::SG::Player::Attribute';

has 'name' => (
    is      => 'ro',
    default => 'Lucre',
);

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
