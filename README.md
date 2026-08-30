[![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions)

TITLE
=====

App::FontSample

SUBTITLE
========

Produce PDF font specimens from any `PDF::Content::FontObj`

SYNOPSIS
========

Library use with one already-loaded font:

```raku
use App::FontSample;

create-font-sample(
    $font,
    :name<MyFont-Regular>,
    :paper<Letter>,
    :layout<specimen>,
    :output<my-font.pdf>,
);
```

Command-line use with an OTF or TTF file:

```text
font-sample \
    --font=/path/to/font.otf \
    --output=sample.pdf \
    --layout=specimen \
    --paper=Letter
```

A reproducible JSON definition can contain one sample or several jobs:

```text
font-sample --config=font-samples.json
```

DESCRIPTION
===========

`App::FontSample` separates font acquisition from PDF specimen rendering. Library callers supply one or more already-loaded `PDF::Content::FontObj` objects. The installed `font-sample` program can load OTF or TTF files directly or read JSON job definitions.

The library is provider-neutral. `NotoFonts-OT` is useful with the examples, but it is not a dependency of `App::FontSample`.

Letter and A4 paper are supported in portrait and landscape orientation. Margins are expressed in PDF points; 72 points equal one inch.

LAYOUTS
=======

specimen
--------

One page per font. Shows the font name, uppercase and lowercase alphabets, numerals and punctuation, a pangram, and a size waterfall.

waterfall
---------

Accepted as a specimen-compatible layout. The specimen page includes a size waterfall controlled by the `sizes` option. A dedicated waterfall-only page is listed in the TODO section.

comparison
----------

Shows the same sample text in each supplied font. Rows are automatically continued onto additional pages when necessary. `comparison-size` controls the sample size and defaults to 18 points.

collection
----------

Places a compact font collection on one page. `sample-size` defaults to 14 points and `leading-ratio` defaults to 0.20. The layout refuses to overflow the lower margin; use `comparison` when the font set does not fit.

characters
----------

Shows selected characters in a grid with a `U+XXXX` label beneath each glyph. The grid automatically continues onto additional pages. `columns` defaults to 8. Library callers may also pass `glyph-size`.

LIBRARY API
===========

create-font-sample
------------------

Creates a PDF from one `PDF::Content::FontObj`.

create-font-collection-sample
-----------------------------

Creates a PDF from a non-empty collection of `App::FontSample::FontEntry` objects. The default collection layout is `comparison`.

NOTOFONTS-OT EXAMPLE
====================

`NotoFonts-OT` exports `get-loaded-font`, so it can be used without a provider object:

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

COMMAND-LINE PROGRAM
====================

Direct mode requires `--font` and `--output`. Important options include:

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

JSON INPUT
==========

The original single-job object remains valid:

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

For several related outputs, use `defaults` plus `samples`:

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

Sample values override values in `defaults`. Relative font and output paths are interpreted relative to the JSON definition file, not the current working directory.

LANGUAGE SAMPLES
================

`App::FontSample::SampleText` provides a small built-in pangram registry. List the available language codes with:

```text
font-sample --languages
```

A library caller may register additional sample text at runtime.

TESTING
=======

Run the normal test suite with:

```text
zef test .
```

Visual examples that depend on `NotoFonts-OT` should remain outside the normal dependency path so the application continues to work with any suitable font source.

TODO
====

The current release is intended to be useful as-is. Planned improvements are:

  * Add a dedicated waterfall-only renderer instead of using the specimen renderer for `waterfall`.

  * Add optional character-cell borders, baseline/cap-height guides, and small edge tick marks for font-metric inspection.

  * Extend `characters` input with convenient Unicode range notation such as `0020..007E` and named blocks.

  * Add more tests that emulate the installed command-line examples, including multi-page comparison and character output.

  * Expand the built-in language sample registry and document which fonts cover each sample.

  * Add more polished JSON examples for specimen, comparison, collection, and character-grid jobs.

  * Review whether the obsolete `App::FontSample::Provider` role should be removed in a later API cleanup.

  * Consider a separate helper for discovering or installing additional Noto fonts; keep that functionality outside the provider-neutral core.

AUTHOR
======

Thomas Browder

