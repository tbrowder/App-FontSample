#!/usr/bin/env raku

use v6.d;

use NotoFonts-OT;
use NotoFonts-OT::FilePaths;

use App::FontSample;

my Bool $debug = False;
my Str $code = 'NotoSerif-Regular';

my $font = get-loaded-font $code;

my @sizes = 8, 10, 12, 16, 20, 28, 36;

my IO::Path $output = create-font-sample(
    $font,
    :name($code),
    :layout<waterfall>,
    :sizes(@sizes),
    :output<noto-waterfall.pdf>,
    :$debug,
);

say "Created '$output'";
