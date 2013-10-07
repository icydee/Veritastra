package RPG::Veritastra::DB::Result::Player;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'RPG::Veritastra::DB::Result';

__PACKAGE__->table('noexist_player');
__PACKAGE__->add_columns(
    name                    => { data_type => 'varchar',    size => 30, is_nullable => 0 },
    password                => { data_type => 'char',       size => 43 },
    password_sitter1        => { data_type => 'varchar',    size => 30 },
    password_sitter2        => { data_type => 'varchar',    size => 30 },
    email                   => { data_type => 'varchar',    size => 512 },
    real_name               => { data_type => 'varchar',    size => 100 },
    level                   => { data_type => 'int',        default_value => 0 },
    password_recovery_key   => { data_type => 'varchar',    size => 36, is_nullable => 1 },
    is_active               => { data_type => 'tinyint',    default_value => 1 },
);

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;
    $sqlt_table->add_index(name => 'idx_name',      fields => ['name']);
    $sqlt_table->add_index(name => 'idx_email',     fields => ['email']);
    $sqlt_table->add_index(name => 'idx_is_active', fields => ['is_active']);
}

# REDIS
#   Look at auto-expansion (see DateTime)
#   Look at freezeColumn (all the redis data in one object)
#   When creating a 'new' item, the ID of the record is undef
#   When a 'get' is performed, read the  Redis value from the database
#   When a 'put' is performed, write the Redis value to the database
#   NOTE
#       REDIS IS THE MASTER WHEN THE RECORD HAS AN ID
#       THE OBJECT IS THE MASTER WHEN THE OBJECT DOES NOT HAVE AN ID.
# CHECK WHAT HAPPENS WHEN YOU CREATE A NEW OBJECT WITH A DATETIME FIELD
# SEE IF IT CREATES A DATETIME VALUE
# IF WE AUTOEXPAND THE OBJECT, WE CAN ONLY PASS IN A DATETIME
# OR CAN WE PASS IN A STRING WHICH IS EXPANDED.
#
# Looking at FreezeColumn, we could put all the redis data into a data field
#   when the object is created, the redis data is given undef, or default values
#   when the object is written to the database, the data is set from the redis data
#   when the object is read from the database, the object data is read from the redis data
#
# Question?
#   Do we want the redis data items to be the 'master' known outside of the object?
#   or, do we want the orm attributes to be the master.
#   if the former, then we have the full range of redis methods
#   if the latter we only have set/get methods.
#   perhaps we don't need to keep separate orm attributes, the redis data could be lumped into a 'redis' attribute
#   with freeze/thaw methods.
#
# Use cases
#   create a new object.
#   
#   my $player = R:V:D:R:new({
#       name        => 'foo',
#       lucre       => 100,
#   });
#   this should create a new object, but it can't create andy redis data yet, because there is no record ID.
#   we should 'freeze' the 'lucre' in the 'data' object.
#
#   my $player = R:V:D:R:create({
#       name        => 'foo',
#       lucre       => 100,
#   });
#   this has created an entry in the database, we can also create redis objects based on the record ID
#   on writing the data to the database we need to also 'freeze' the redis data.
#   We have to wait until after the record has been created in order to get the ID.
#
#   $player->name('bar')->update;
#   this has done a record update, we can read all the redis data and write it to the database
#
#   $player->lucre
#   Read the value of the redis object
#
#   $player->lucre(110);
#   Set the value of the redis object
#
#   $player->as_redis('lucre')
#   Get a redis object on which to do things like 'incrby' etc.
#






has current_session => (
    is              => 'rw',
    predicate       => 'has_current_session',
);

around name => sub {
    my ($orig, $self) = (shift, shift);

    if (@_) {
        my $new_name = $_[0];

        RPG::Veritastra->db->resultset('Log::PlayerNameChange')->create({
            player_id       => $self->id,
            player_name     => $self->$orig,
            new_player_name => $new_name,
        });
    }

    $self->$orig(@_);
};

sub is_correct_password {
    my ($self, $password) = @_;
    return (defined $password && $password ne '' && $self->password eq $self->encrypt_password($password)) ? 1 : 0;
}

sub encrypt_password {
    my ($class, $password) = @_;
    return Digest::SHA::sha256_base64($password);
}

__PACKAGE__->meta->make_immutable;
