package RPG::Veritastra::DB::Result::SG::Player::Attribute;

use Moose;
use namespace::autoclean;

extends 'RPG::Veritastra::DB::Result::Player::Attribute';

__PACKAGE__->typecast_map(type => {
    lucre       => 'RPG::Veritastra::DB::Result::SG::Player::Attribute::Lucre',
    happiness   => 'RPG::Veritastra::DB::Result::SG::Player::Attribute::Happiness',
});

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
