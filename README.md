[![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions)

TITLE
=====

App::FontSample

SUBTITLE
========

Produce PDF font specimens from any PDF::Content::FontObj

SYNOPSIS
========

Library use with one already-loaded font:

```raku
use App::FontSample;

my $font = $provider.get-font('NotoSerif-Regular');

create-font-sample(
    $font,
    :name<NotoSerif-Regular>,
    :paper<Letter>,
    :layout<specimen>,
    :output<noto-serif-regular.pdf>,
);
```

Command-line use with an OTF or TTF file:

```text
font-sample \
    --font=/path/to/font.otf \
    --output=sample.pdf \
    --layout=waterfall \
    --paper=Letter
```

Command-line use with a reproducible JSON job:

```text
font-sample --config=font-sample.json
```

DESCRIPTION
===========

`App::FontSample` separates font acquisition from specimen rendering. A library caller supplies one or more objects that do `PDF::Content::FontObj`. The command-line program loads OTF or TTF files directly or reads a JSON job.

The application does not require a particular font collection module. `NotoFonts-OT`, core PDF fonts, and other font providers can all supply the font objects used by the library API.

Letter and A4 paper are supported in portrait and landscape orientation.

LAYOUTS
=======

specimen
--------

One page per font. Shows the font name, uppercase and lowercase alphabets, numerals and punctuation, a pangram, and a size waterfall.

waterfall
---------

One page per font devoted to the same sample string at several point sizes.

comparison
----------

Shows the same sample text in each supplied font. Multiple pages are created when necessary. This layout is especially useful for a font collection.

characters
----------

Shows selected characters in a grid with their Unicode code points. The `characters` option determines which characters are shown.

JSON INPUT
==========

The JSON root must contain `output` and a non-empty `fonts` array. Other keys are optional.

```json
{
    "output": "output/font-samples.pdf",
    "paper": "Letter",
    "landscape": false,
    "margin": 36,
    "layout": "comparison",
    "title": "Font Comparison",
    "language": "en",
    "comparison-size": 18,
    "fonts": [
        {
            "file": "fonts/NotoSerif-Regular.otf",
            "name": "Noto Serif Regular",
            "family": "Noto Serif",
            "style": "Regular"
        },
        {
            "file": "fonts/NotoSans-Regular.otf",
            "name": "Noto Sans Regular",
            "family": "Noto Sans",
            "style": "Regular"
        }
    ]
}
```

Relative `output` and font `file` paths are resolved from the directory containing the JSON file.

Top-level JSON keys
-------------------

  * `output`

Required output PDF path.

  * `fonts`

Required array containing one or more font-entry objects.

  * `layout`

`specimen`, `waterfall`, `comparison`, or `characters`. The default is `specimen`.

  * `paper`

`Letter` or `A4`. The default is `Letter`.

  * `landscape`

Boolean. The default is `false`.

  * `margin`

Margin in PDF points. The default is 36 points, or one-half inch.

  * `title`

Heading printed on the generated pages.

  * `language`

ISO language code for a built-in pangram. An explicit `pangram` overrides this value.

  * `text`

Main sample text. Layouts use the pangram when this is absent.

  * `pangram`

Explicit pangram or sample sentence.

  * `sizes`

Array of positive point sizes used by waterfall rendering.

  * `characters`

Characters displayed by the `characters` layout.

  * `columns`

Number of columns used by the `characters` layout.

  * `comparison-size`

Point size used by the `comparison` layout.

Font-entry keys
---------------

  * `file`

Required OTF or TTF file path.

  * `name`

Display and identifying name. The filename is used when absent.

  * `family`

Optional family metadata.

  * `style`

Optional style metadata. The default is `Regular`.

  * `source`

Optional source description.

LIBRARY API
===========

create-font-sample
------------------

Creates a PDF from one `PDF::Content::FontObj`.

create-font-collection-sample
-----------------------------

Creates a PDF from a positional collection of `App::FontSample::FontEntry` objects. The default layout for this routine is `comparison`.

NOTOFONTS-OT
============

The published `NotoFonts-OT` module directly supplies suitable font objects through its `get-font` method. It is intentionally not a required dependency of this application.

```raku
use NotoFonts-OT;
use App::FontSample;
use App::FontSample::FontEntry;

my $noto = NotoFonts-OT.new;
my @entries;

for 1..10 -> $code {
    my $font = $noto.get-font($code);

    @entries.push: App::FontSample::FontEntry.new(
        :name("Noto font $code"),
        :$font,
    );
}

create-font-collection-sample(
    @entries,
    :layout<comparison>,
    :output<noto-comparison.pdf>,
);
```

See `examples/noto-provider.raku` for an example using all ten published font names.

LANGUAGE SAMPLES
================

`App::FontSample::SampleText` provides a small built-in registry. The CLI lists the currently registered codes with:

```text
font-sample --languages
```

A library caller can register another pangram at runtime.

TESTING
=======

```text
zef test .
```

The rendering test creates its PDF under `$*TMPDIR/` and removes it at scope exit. Set its local `$debug` flag when retaining output is useful during development.

AUTHOR
======

Thomas Browder

