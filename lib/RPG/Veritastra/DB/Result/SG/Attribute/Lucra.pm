package RPG::Veritastra::DB::Result::SG::Attribute::Lucra;

use Moose;
use namespace::autoclean

extends 'RPG::Veritastra::DB::Result::SG::Attribute';

has 'name' => (
    is      => 'ro',
    default => 'Lucra',
);

no Moose;
