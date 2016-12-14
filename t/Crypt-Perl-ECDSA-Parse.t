package t::Crypt::Perl::ECDSA::Parse;

use strict;
use warnings;

BEGIN {
    if ( $^V ge v5.10.1 ) {
        require autodie;
    }
}

use Try::Tiny;

use FindBin;

use lib "$FindBin::Bin/lib";
use OpenSSL_Control ();

use Test::More;
use Test::NoWarnings;
use Test::Deep;
use Test::Exception;

use Crypt::Format ();
use Digest::SHA ();
use File::Slurp ();
use File::Temp ();

use lib "$FindBin::Bin/lib";
use parent qw(
    NeedsOpenSSL
    Test::Class
);

use lib "$FindBin::Bin/../lib";

use Crypt::Perl::ECDSA::Parse ();

if ( !caller ) {
    my $test_obj = __PACKAGE__->new();
    plan tests => $test_obj->expected_tests(+1);
    $test_obj->runtests();
}

#----------------------------------------------------------------------

sub test_pkcs8_private : Tests(1) {
    my ($self) = @_;

    my $openssl_bin = $self->_get_openssl();

    my $key_path = "$FindBin::Bin/assets/prime256v1.key";

    my $plain = File::Slurp::read_file($key_path);
    my $pkcs8 = `$openssl_bin pkey -in $key_path`;
    die if $?;

    $_ = Crypt::Perl::ECDSA::Parse::private($_) for ($pkcs8, $plain);

    is_deeply(
        $pkcs8,
        $plain,
        'PKCS8 key parsed the same as a regular one',
    );

    return;
}

sub test_pkcs8_public : Tests(1) {
    my ($self) = @_;

    my $openssl_bin = $self->_get_openssl();

    my $key_path = "$FindBin::Bin/assets/prime256v1.key.public";

    my $plain = File::Slurp::read_file($key_path);
    my $pkcs8 = `$openssl_bin pkey -pubin -in $key_path`;
    die if $?;

    $_ = Crypt::Perl::ECDSA::Parse::public($_) for ($pkcs8, $plain);

    is_deeply(
        $pkcs8,
        $plain,
        'PKCS8 key parsed the same as a regular one',
    );

    return;
}

1;