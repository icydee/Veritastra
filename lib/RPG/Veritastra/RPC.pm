package RPG::Veritastra::RPC;

use Moose;
use namespace::autoclean;

extends "JSON::RPC::Dispatcher::App";

__PACKAGE__->meta->make_immutable;

