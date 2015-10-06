use FindBin;
use lib "$FindBin::Bin/local/lib/perl5";
use lib "$FindBin::Bin/lib";
use File::Basename;
use Plack::Builder;
use Isucon5::Web;
use Cache::Memcached::Fast;
use Sereal;

my $root_dir = File::Basename::dirname(__FILE__);
my $decoder = Sereal::Decoder->new();
my $encoder = Sereal::Encoder->new();
my $app = Isucon5::Web->psgi($root_dir);

builder {
    enable 'ReverseProxy';
    enable 'Session::Simple',
      store => Cache::Memcached::Fast->new({
        servers => [ { address => "localhost:11211",noreply=>0} ],
        serialize_methods => [ sub { $encoder->encode($_[0])}, 
                               sub { $decoder->decode($_[0])} ],
      }),
      httponly => 1,
      cookie_name => 'isuxi_session',
      keep_empty;
    $app;
};
