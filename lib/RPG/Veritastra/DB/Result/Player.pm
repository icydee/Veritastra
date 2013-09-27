package RPG::Veritastra::DB::Result::Player;

use Moose;
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

__PACKAGE__->has_many('attributes', 'RPG::Veritastra::DB::Result::Attribute', 'parent_id');

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

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
