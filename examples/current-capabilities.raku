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
    :output<example-specimen.pdf>,
);

create-font-sample(
    $times,
    :name<Times-Roman>,
    :layout<waterfall>,
    :text(
        'Sphinx of black quartz, judge my vow. 0123456789'
    ),
    :sizes(
        8, 9, 10, 11, 12, 14,
        18, 24, 30, 36, 48, 60
    ),
    :output<example-waterfall.pdf>,
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
    :comparison-size(18),
    :output<example-comparison.pdf>,
);

create-font-collection-sample(
    @entries,
    :layout<collection>,
    :sample-size(14),
    :leading-ratio(0.20),
    :output<example-collection.pdf>,
);

create-font-sample(
    $times,
    :name<Times-Roman>,
    :layout<characters>,
    :characters(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    ),
    :columns(8),
    :glyph-size(30),
    :output<example-characters.pdf>,
);

say 'Created:';
say '  example-specimen.pdf';
say '  example-waterfall.pdf';
say '  example-comparison.pdf';
say '  example-collection.pdf';
say '  example-characters.pdf';
