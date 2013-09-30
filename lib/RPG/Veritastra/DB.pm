package RPG::Veritastra::DB;

use Moose;
use namespace::autoclean;

extends qw/DBIx::Class::Schema/;

__PACKAGE__->load_namespaces();

sub sqlt_deploy_hook {
    my ($self, $sqlt_schema) = @_;

    foreach my $table (qw(basetable log player map)) {
        $sqlt_schema->drop_table("noexist_$table");
    }
}

__PACKAGE__->meta->make_immutable;
