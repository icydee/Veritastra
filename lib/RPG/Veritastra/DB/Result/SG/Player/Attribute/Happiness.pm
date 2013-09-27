package RPG::Veritastra::DB::Result::SG::Player::Attribute::Happiness;

use Moose;
use namespace::autoclean;

extends 'RPG::Veritastra::DB::Result::SG::Player::Attribute';

has 'name' => (
    is      => 'ro',
    default => 'Happiness',
);

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
