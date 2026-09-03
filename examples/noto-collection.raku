#!/usr/bin/env raku

use v6.d;

use NotoFonts-OT;
#use NotoFonts-OT::FilePaths;

use App::FontSample;
use App::FontSample::FontEntry;

my $debug = 0;

my @codes =
    'NotoSerif-Regular',
    'NotoSerif-Bold',
    'NotoSerif-Italic',
    'NotoSerif-BoldItalic',
    'NotoSans-Regular',
    'NotoSans-Bold',
    'NotoSans-Italic',
    'NotoSans-BoldItalic',
    'NotoSansMono-Regular',
    'NotoSansMono-Bold';

my @entries;

for @codes -> $code {
    note "loading '$code'"
        if $debug;

    my $font =
        get-loaded-font $code;

    my $entry =
        App::FontSample::FontEntry.new(
            :name($code),
            :$font,
            :$debug,
        );

    @entries.push: $entry;
}

note "rendering {@entries.elems} fonts"
    if $debug;

my IO::Path $output =
    create-font-collection-sample(
        @entries,
        :layout<collection>,
        :title("NotoFonts-OT Font Collection"),
        :sample-size(14),
        :leading-ratio(0.20),
        :text(
            'Hamburgefonts 0123456789 Aa Bb Cc'
        ),
        :output<noto-font-collection.pdf>,
        :$debug,
    );

say "Created '$output'";
