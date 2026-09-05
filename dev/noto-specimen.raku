#!/usr/bin/env raku

use v6.d;

use NotoFonts-OT;
#use NotoFonts-OT::FilePaths;

use App::FontSample;

my $debug = 0;
my Str $code = 'NotoSerif-Regular';

my $font = get-loaded-font $code;

my IO::Path $output = create-font-sample(
    $font,
    :name($code),
    :layout<specimen>,
    :output<noto-specimen.pdf>,
    :$debug,
);

say "Created '$output'";
