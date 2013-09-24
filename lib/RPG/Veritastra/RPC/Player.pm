package RPG::Veritastra::RPC::Player;

use Moose;
extends 'RPG::Veritastra::RPC';
use DateTime;

sub is_name_available {
    my ($self, $args) = @_;

    return 1;
}

__PACKAGE__->register_rpc_method_names(
    qw(is_name_available),
);

no Moose;
__PACKAGE__->meta->make_immutable;
