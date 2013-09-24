use strict;
use lib ('/data/Veritastra/lib');
use 5.010;
use Config::JSON;
use Plack::App::URLMap;
use Log::Log4perl;
use Log::Any::Adapter;
use RPG::Veritastra;
use Plack::Builder;
use JSON qw(encode_json);

$|=1;

my $config = Config::JSON->new('/data/Veritastra/etc/veritastra.conf');
my $cache = RPG::Veritastra->cache;

Log::Log4perl::init('/data/Veritastra/etc/log4perl.conf');
Log::Any::Adapter->set('Log::Log4perl');

my $offline = [ 500,
    [ 'Content-Type' => 'application/json-rpc' ],
    [ encode_json( {
        jsonrpc => '2.0',
        error   => {
            code    => -32000,
            message => 'The server is currently offline for maintenance.',
        }
    })],
];

my $ping = [ 200,
    [ 'Content-Type' => 'application/json-rpc' ],
    [ 'pong' ],
];

my $app = builder {
    enable 'CrossOrigin',
        origins => '*', 
        methods => ['GET', 'POST'], 
        max_age => 60*60*24*30, 
        headers => '*';

    enable sub {
        my ($env) = @_;
        my $status = $cache->get('server','status');
        if ($status eq 'offline') {
            return $offline;
        }
    };

    mount '/starman_ping' => sub {
        return $ping;
    };
    mount '/player' => RPG::Veritastra::RPC::Player->to_app;
};

say "Server Started";

$app;

