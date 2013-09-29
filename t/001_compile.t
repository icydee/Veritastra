#!/usr/bin/env perl

use strict;

use FindBin::libs;
use Test::More;
use Module::List qw(list_modules);

my $modules_ref = list_modules("RPG::Veritastra::", {list_modules => 1, recurse => 1});

foreach my $module (sort keys %$modules_ref) {
    use_ok($module);
}



done_testing();
