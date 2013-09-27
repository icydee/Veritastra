package RPG::Veritastra::DB::Result::Player::Attribute;

# A players Attribute.
# This will normally be 'typecast' based on the 'type' attribute
# because a player may have many attributes, e.g. 'happiness','currency', etc.

use Moose;
use namespace::autoclean;

extends 'RPG::Veritastra::DB::Result::Attribute';

__PACKAGE__->table('player_attribute');

__PACKAGE__->belongs_to('player', 'RPG::Veritastra::DB::Result::Player', 'parent_id', { on_delete => 'set null' });

# redis_key : 
#   Get the Key used to store/retrieve this value in the Redis database
#
sub redis_key {
    my ($self) = @_;

    return "sys:player:attribute:".$self->type.":".$self->parent_id;
}


__PACKAGE__->meta->make_immutable;
