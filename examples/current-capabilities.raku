#!/usr/bin/env raku

use v6.d;

use PDF::API6;

use App::FontSample;
use App::FontSample::FontEntry;

my $pdf = PDF::API6.new;

my $times =
    $pdf.core-font: :family<Times-Roman>;

my $helvetica =
    $pdf.core-font: :family<Helvetica>;

my $courier =
    $pdf.core-font: :family<Courier>;

create-font-sample(
    $times,
    :name<Times-Roman>,
    :layout<specimen>,
    :title("Font Specimen"),
    :language<en>,
    :output<example-specimen.pdf>,
);

my @entries;

@entries.push: App::FontSample::FontEntry.new(
    :name<Times-Roman>,
    :font($times),
);

@entries.push: App::FontSample::FontEntry.new(
    :name<Helvetica>,
    :font($helvetica),
);

@entries.push: App::FontSample::FontEntry.new(
    :name<Courier>,
    :font($courier),
);

create-font-collection-sample(
    @entries,
    :layout<comparison>,
    :title("Font Comparison"),
    :comparison-size(18),
    :text(
        'The quick brown fox jumps over the lazy dog. 0123456789'
    ),
    :output<example-comparison.pdf>,
);

create-font-collection-sample(
    @entries,
    :layout<collection>,
    :title("Font Collection"),
    :sample-size(14),
    :leading-ratio(0.20),
    :text(
        'Hamburgefonts 0123456789 Aa Bb Cc'
    ),
    :output<example-collection.pdf>,
);

create-font-sample(
    $times,
    :name<Times-Roman>,
    :layout<characters>,
    :title("Character Sample"),
    :characters(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    ),
    :columns(8),
    :glyph-size(30),
    :output<example-characters.pdf>,
);

say 'Created:';
say '  example-specimen.pdf';
say '  example-comparison.pdf';
say '  example-collection.pdf';
say '  example-characters.pdf';
