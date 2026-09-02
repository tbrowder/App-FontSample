[![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/noto-fonts.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions)

TITLE
=====

App::FontSample

SUBTITLE
========

Create PDF font samples from `PDF::Content::FontObj` objects

DESCRIPTION
===========

`App::FontSample` creates PDF font specimens, comparisons, compact font collections, and character charts.

`App::FontSample` does not provide a font collection. Library callers supply one or more `PDF::Content::FontObj` objects. The installed `font-sample` program can load an OTF or TTF file directly.

The current release supports Letter and A4 paper, portrait and landscape orientation, configurable margins, several sample layouts, JSON job files, and registered language pangrams.

INSTALLATION
============

```text
zef install App::FontSample
```

FIRST SAMPLE
============

The easiest first test uses a standard PDF core font, so no external font file is required.

```raku
use PDF::API6;
use App::FontSample;

my $pdf  = PDF::API6.new;
my $font = $pdf.core-font: :family<Times-Roman>;

create-font-sample(
    $font,
    :name<Times-Roman>,
    :output<sample.pdf>,
);
```

This creates `sample.pdf` using the default `specimen` layout.

LIBRARY INTERFACE
=================

create-font-sample
------------------

`create-font-sample` creates a sample from one `PDF::Content::FontObj`.

```raku
create-font-sample(
    $font,
    :name<MyFont-Regular>,
    :paper<Letter>,
    :layout<specimen>,
    :output<my-font.pdf>,
);
```

Current common named options are:

  * `name` - displayed font name; required

  * `output` - output PDF pathname; required

  * `paper` - `Letter` or `A4`; default `Letter`

  * `media` - alternate name for `paper`

  * `landscape` - use landscape orientation

  * `margin` - page margin in PDF points; default 36

  * `layout` - layout name; default `specimen`

  * `title` - document title

  * `family` - optional family description

  * `style` - optional style description

  * `language` - registered language code used to select a pangram

  * `debug` - enable diagnostic messages

PDF dimensions are expressed in points; 72 points equal one inch.

create-font-collection-sample
-----------------------------

`create-font-collection-sample` accepts a non-empty collection of `App::FontSample::FontEntry` objects. Its default layout is `comparison`.

```raku
use App::FontSample;
use App::FontSample::FontEntry;

my @entries;

@entries.push: App::FontSample::FontEntry.new(
    :name<Font-One>,
    :font($font-one),
);

@entries.push: App::FontSample::FontEntry.new(
    :name<Font-Two>,
    :font($font-two),
);

create-font-collection-sample(
    @entries,
    :layout<comparison>,
    :output<comparison.pdf>,
);
```

CURRENT LAYOUTS
===============

specimen
--------

The `specimen` layout produces one specimen page per font. It shows the font name, uppercase and lowercase alphabets, numerals and punctuation, a pangram, and a size waterfall.

```raku
create-font-sample(
    $font,
    :name<Times-Roman>,
    :layout<specimen>,
    :output<specimen.pdf>,
);
```

The pangram and waterfall text may be replaced:

```raku
create-font-sample(
    $font,
    :name<Times-Roman>,
    :layout<specimen>,
    :pangram('Pack my box with five dozen liquor jugs.'),
    :text('Sphinx of black quartz, judge my vow.'),
    :sizes(8, 10, 12, 14, 18, 24, 36),
    :output<specimen-custom.pdf>,
);
```

waterfall
---------

`waterfall` is currently an alternate layout name for the specimen renderer. Consequently it produces the specimen information as well as the size waterfall. `sizes` controls the waterfall sizes.

```raku
create-font-sample(
    $font,
    :name<Times-Roman>,
    :layout<waterfall>,
    :text('Sphinx of black quartz, judge my vow. 0123456789'),
    :sizes(8, 9, 10, 11, 12, 14, 18, 24, 30, 36, 48, 60),
    :output<waterfall.pdf>,
);
```

comparison
----------

`comparison` displays the same sample text in each supplied font. `comparison-size` defaults to 18 points. The layout automatically continues onto additional pages when the rows do not fit on one page.

```raku
create-font-collection-sample(
    @entries,
    :layout<comparison>,
    :comparison-size(18),
    :text('Hamburgefonts 0123456789 Aa Bb Cc'),
    :output<comparison.pdf>,
);
```

collection
----------

`collection` places a compact collection of fonts on one page. `sample-size` defaults to 14 points and `leading-ratio` defaults to 0.20.

```raku
create-font-collection-sample(
    @entries,
    :layout<collection>,
    :sample-size(14),
    :leading-ratio(0.20),
    :text('Hamburgefonts 0123456789 Aa Bb Cc'),
    :output<collection.pdf>,
);
```

The collection layout reports an error rather than allowing the rows to overflow the lower page margin. Use `comparison` when the collection is too large for one page.

characters
----------

`characters` displays selected characters in a grid with a `U+XXXX` label beneath each glyph. `columns` defaults to 8 and the library `glyph-size` option defaults to 30 points. The layout automatically creates additional pages when necessary.

```raku
create-font-sample(
    $font,
    :name<Times-Roman>,
    :layout<characters>,
    :characters('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'),
    :columns(8),
    :glyph-size(30),
    :output<characters.pdf>,
);
```

Library callers may supply `characters` as a string or as a positional collection containing individual characters, integer Unicode code points, or strings of the form `U+XXXX`.

```raku
my @characters =
    'A',
    'B',
    0x43,
    'U+0044';

create-font-sample(
    $font,
    :name<Times-Roman>,
    :layout<characters>,
    :characters(@characters),
    :output<selected-characters.pdf>,
);
```

PAPER AND PAGE OPTIONS
======================

Both `Letter` and `A4` are supported.

```raku
create-font-sample(
    $font,
    :name<Times-Roman>,
    :paper<A4>,
    :landscape,
    :margin(36),
    :output<a4-landscape.pdf>,
);
```

LANGUAGE PANGRAMS
=================

`App::FontSample::SampleText` contains a small registry of language pangrams. A registered language code can supply the specimen pangram:

```raku
create-font-sample(
    $font,
    :name<Times-Roman>,
    :language<en>,
    :output<english.pdf>,
);
```

The installed program lists the currently registered language codes:

```text
font-sample --languages
```

A library caller may also register additional sample text at runtime.

USING AN OTF OR TTF FILE
========================

The installed `font-sample` program loads an OTF or TTF file directly.

```text
font-sample \
    --font=/path/to/font.otf \
    --output=sample.pdf \
    --layout=specimen \
    --paper=Letter
```

Current direct-mode options are:

  * `--name=TEXT`

  * `--family=TEXT`

  * `--style=TEXT`

  * `--layout=specimen|waterfall|comparison|characters|collection`

  * `--paper=Letter|A4`

  * `--landscape`

  * `--margin=POINTS`

  * `--language=CODE`

  * `--text=TEXT`

  * `--pangram=TEXT`

  * `--sizes=N,N,...`

  * `--characters=TEXT`

  * `--columns=N`

  * `--comparison-size=N`

  * `--sample-size=N`

  * `--leading-ratio=N`

  * `--languages`

  * `--help`

For example:

```text
font-sample \
    --font=/path/to/font.otf \
    --output=characters.pdf \
    --layout=characters \
    --characters=ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 \
    --columns=8
```

JSON INPUT
==========

`font-sample` can read one or more jobs from a JSON definition file:

```text
font-sample --config=font-samples.json
```

A single job can be defined as:

```json
{
    "output": "output/sample.pdf",
    "layout": "specimen",
    "fonts": [
        {
            "file": "fonts/MyFont.otf",
            "name": "My Font"
        }
    ]
}
```

Several related jobs may share defaults:

```json
{
    "defaults": {
        "paper": "Letter",
        "margin": 36,
        "fonts": [
            {
                "file": "fonts/MyFont-Regular.otf",
                "name": "MyFont Regular"
            },
            {
                "file": "fonts/MyFont-Bold.otf",
                "name": "MyFont Bold"
            }
        ]
    },
    "samples": [
        {
            "output": "output/comparison.pdf",
            "layout": "comparison",
            "comparison-size": 18
        },
        {
            "output": "output/characters.pdf",
            "layout": "characters",
            "characters": "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
            "columns": 8
        }
    ]
}
```

Values in an individual sample override values in `defaults`. Relative font and output paths are interpreted relative to the JSON definition file.

OPTIONAL NOTOFONTS-OT USE
=========================

`NotoFonts-OT` is not a dependency of `App::FontSample`. It is one optional source of `PDF::Content::FontObj` objects.

```raku
use NotoFonts-OT;
use App::FontSample;
use App::FontSample::FontEntry;

my @entries;

for <
    NotoSerif-Regular
    NotoSerif-Bold
    NotoSans-Regular
    NotoSans-Bold
> -> $code {
    my $font = get-loaded-font($code);

    @entries.push: App::FontSample::FontEntry.new(
        :name($code),
        :$font,
    );
}

create-font-collection-sample(
    @entries,
    :layout<comparison>,
    :output<noto-comparison.pdf>,
);
```

EXAMPLES
========

The `examples` directory contains programs demonstrating current capabilities. `examples/current-capabilities.raku` uses PDF core fonts and creates examples of every current layout.

Create the samples this way:

    raku -Ilib examples/current-capabilities.raku

The Noto examples demonstrate optional integration with `NotoFonts-OT` and their large glyph collections.

TESTING
=======

Run the normal test suite with:

```text
zef test .
```

The normal test suite does not require `NotoFonts-OT`. Noto integration is tested separately so the core application remains independent of a particular font collection.

FUTURE WORK
===========

This README describes current capability only. Planned additions and changes are maintained in `docs/TODO.rakudoc`.

SOURCE
======

The project source is maintained in the `tbrowder/App-FontSample` repository on GitHub.

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2026 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

