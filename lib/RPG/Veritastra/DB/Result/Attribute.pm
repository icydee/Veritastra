package RPG::Veritastra::DB::Result::Attribute;

use Moose;
use namespace::autoclean;

extends 'RPG::Veritastra::DB::Result';

#with 'RPG::Veritastra::TraitFor::Redis::DB';

__PACKAGE__->table('xxx_attribute');
__PACKAGE__->add_columns(
    parent_id               => { data_type => 'int',        size => 11, is_nullable => 0 },
    type                    => { data_type => 'char',       size => 20, is_nullable => 0 },
    value                   => { data_type => 'varchar',    size => 512 },
    last_changed            => { data_type => 'datetime',   size => 12 },
);

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;
    $sqlt_table->add_index(name => 'idx_type',      fields => ['type']);
    $sqlt_table->add_index(name => 'idx_player_id', fields => ['parent_id']);
}

sub redis_key {
    croak "You need to define a 'redis_key' method";
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
