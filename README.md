[![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/noto-fonts.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions)

TITLE
=====

App::FontSample

SUBTITLE
========

Create PDF samples of fonts

DESCRIPTION
===========

`App::FontSample` creates PDF font specimens, comparisons, collections, and character charts.

The most important thing to know is that `App::FontSample` does not provide a collection of fonts. The library samples a font supplied as a `PDF::Content::FontObj`.

For a first test, use a PDF core font. No external font file or optional font collection is required.

After that, applications may use OTF or TTF files, `NotoFonts-OT`, or any other source capable of supplying a suitable `PDF::Content::FontObj`.

GETTING STARTED
===============

1. Install App::FontSample
--------------------------

```text
zef install App::FontSample
```

2. Create your first sample
---------------------------

The following example uses the PDF core Times-Roman font. It is a good first test because it does not require an external font file.

```raku
use PDF::API6;
use App::FontSample;

my $pdf = PDF::API6.new;
my $font = $pdf.core-font: :family<Times-Roman>;

create-font-sample(
    $font,
    :name<Times-Roman>,
    :output<sample.pdf>,
);
```

The resulting `sample.pdf` contains a specimen of Times-Roman.

3. Try another font
-------------------

`App::FontSample` is provider-neutral. Once you have a `PDF::Content::FontObj`, the sampling code is the same regardless of where the font came from.

For example, `NotoFonts-OT` is an optional source of ready-to-use Noto font objects:

```text
zef install NotoFonts-OT
```

Then:

```raku
use NotoFonts-OT;
use App::FontSample;

my $font = get-loaded-font('NotoSerif-Regular');

create-font-sample(
    $font,
    :name<NotoSerif-Regular>,
    :output<noto-serif.pdf>,
);
```

`NotoFonts-OT` is not a dependency of `App::FontSample`. It is simply one convenient font source.

Some external font loaders require native system libraries. Install any native prerequisites required by the font provider or loader you choose.

BASIC CONCEPT
=============

The intended relationship is:

```text
font source
    |
    v
PDF::Content::FontObj
    |
    v
App::FontSample
    |
    v
PDF sample
```

Font providers are responsible for locating and loading fonts. `App::FontSample` is responsible for laying them out and creating the PDF.

LIBRARY API
===========

create-font-sample
------------------

Creates a PDF sample from one `PDF::Content::FontObj`.

A typical call is:

```raku
create-font-sample(
    $font,
    :name<MyFont-Regular>,
    :paper<Letter>,
    :layout<specimen>,
    :output<my-font.pdf>,
);
```

Important named options include:

  * `name` - name displayed for the font; required

  * `output` - output PDF pathname; required

  * `paper` - `Letter` or `A4`; defaults to `Letter`

  * `landscape` - use landscape orientation

  * `margin` - page margin in PDF points; defaults to 36

  * `layout` - requested sample layout; defaults to `specimen`

  * `title` - document title

  * `family` - optional font-family description

  * `style` - optional font-style description

  * `language` - optional language code for registered sample text

  * `debug` - enable diagnostic messages

PDF dimensions are expressed in points; 72 points equal one inch.

create-font-collection-sample
-----------------------------

Creates a PDF from a non-empty collection of `App::FontSample::FontEntry` objects.

For example:

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

The default collection layout is `comparison`.

LAYOUTS
=======

specimen
--------

Produces one specimen page per font. The page shows the font name, uppercase and lowercase alphabets, numerals and punctuation, a pangram, and a size waterfall.

waterfall
---------

Currently accepted as a specimen-compatible layout. The specimen renderer includes a size waterfall controlled by the `sizes` option.

comparison
----------

Shows the same sample text in each supplied font. Rows continue onto additional pages when necessary. `comparison-size` controls the sample size and defaults to 18 points.

collection
----------

Places a compact collection of fonts on one page. `sample-size` defaults to 14 points and `leading-ratio` defaults to 0.20.

The layout refuses to overflow the lower page margin. Use `comparison` for a font collection that does not fit on one page.

characters
----------

Shows selected characters in a grid with a `U+XXXX` label beneath each glyph. The grid continues onto additional pages when necessary.

`columns` defaults to 8. Library callers may also supply `glyph-size`.

USING NOTOFONTS-OT FOR A COLLECTION
===================================

`NotoFonts-OT` exports `get-loaded-font`. A Noto collection can therefore be assembled without a provider object:

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

The distribution installs `font-sample`.

For direct use with an OTF or TTF file:

```text
font-sample \
    --font=/path/to/font.otf \
    --output=sample.pdf \
    --layout=specimen \
    --paper=Letter
```

Important command-line options include:

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

A JSON definition makes a set of samples reproducible.

Run a definition with:

```text
font-sample --config=font-samples.json
```

A single sample can be defined as:

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

Values in an individual sample override values in `defaults`. Relative font and output paths are interpreted relative to the JSON definition file rather than the current working directory.

LANGUAGE SAMPLES
================

`App::FontSample::SampleText` provides a small built-in pangram registry.

List the available language codes with:

```text
font-sample --languages
```

Library callers may register additional sample text at runtime.

TESTING
=======

Run the normal test suite with:

```text
zef test .
```

The normal tests do not require `NotoFonts-OT`.

Integration with `NotoFonts-OT` can be tested separately by installing that optional distribution and running the appropriate extended tests. This keeps the core application independent of any particular font collection.

PROJECT STATUS AND FUTURE WORK
==============================

This release is intended to provide a useful working font sampler while keeping the public interface independent of individual font providers.

Planned work is maintained separately in `docs/TODO.rakudoc`.

SOURCE
======

The project source is maintained in the `tbrowder/App-FontSample` repository on GitHub.

AUTHOR
======

Thomas Browder

