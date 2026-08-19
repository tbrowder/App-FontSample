#!/usr/bin/env raku

use v6.d;

use NotoFonts-OT;
use NotoFonts-OT::FontPaths;

use App::FontSample;
use App::FontSample::PDF;
use App::FontSample::FontEntry;


# Adjust these calls if the provider's final public API uses different names.
my @entries;

my $debug = 1;
for <NotoSerif-Regular NotoSerif-Bold NotoSans-Regular> -> $code {
    # code is a font name or alias, get the loaded font
    my $font = get-loaded-font $code;
    note "DEBUG 1: using font code '$code'" if $debug;
    @entries.push: App::FontSample::FontEntry.new(
        :name($code),
        :$font,
        :$debug,
    );
}

# the called sub is in file App/FontSample.rakumod
note "DEBUG 3: calling for the collection" if $debug;
my $output = create-font-collection-sample(
    @entries,
    :layout<collections>,
    :title<NotoFonts-OT Font Collection>,
    :sample-size(14),
    :leading-ratio(0.20),
    :output<noto-font-collection.pdf>,
    :$debug,
);

say "Created '$output'";
