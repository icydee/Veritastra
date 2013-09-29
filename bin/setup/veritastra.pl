use lib '../../lib';
use strict;
use warnings;
use 5.010;

use RPG::Veritastra;

my $db = RPG::Veritastra->db;

create_database();

sub create_database {
    $db->deploy({ add_drop_table => 1 });
}

1;

