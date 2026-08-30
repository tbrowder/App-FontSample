#!/usr/bin/env raku

use v6.d;

use NotoFonts-OT;
use App::FontSample;

my Bool $debug = False;
my Str $code = 'NotoSerif-Regular';

my $font = get-loaded-font $code;

my @characters;

for 0x20 .. 0x7E -> $codepoint {
    @characters.push: $codepoint;
}

my IO::Path $output = create-font-sample(
    $font,
    :name($code),
    :layout<characters>,
    :characters(@characters),
    :columns(8),
    :output<noto-characters.pdf>,
    :$debug,
);

say "Created '$output'";
