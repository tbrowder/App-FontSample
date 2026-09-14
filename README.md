[![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions) [![Actions Status](https://github.com/tbrowder/App-FontSample/actions/workflows/noto-fonts.yml/badge.svg)](https://github.com/tbrowder/App-FontSample/actions)

TITLE
=====

App::FontSample

SUBTITLE
========

Create PDF font samples from `PDF::Content::FontObj` objects

DESCRIPTION
===========

`App::FontSample` can create four font sample types (click each link to view on GitHub):

  * [specimen](./examples/pdf/example-specimen.pdf)

  * [comparison](./examples/pdf/example-comparison.pdf)

  * [collection](./examples/pdf/example-collection.pdf)

  * [characters](./examples/pdf/example-characters.pdf)

`App::FontSample` does not provide fonts other the built-in core fonts which are limited to 256 glyphs. Library callers can supply one or more `PDF::Content::FontObj` objects. The installed `font-sample` program can load an OTF (or TTF) file directly.

The current release supports Letter and A4 paper, portrait and landscape orientation, configurable margins, JSON job files, registered language pangrams, and the four layouts shown above.

INSTALLATION
============

Install `App::FontSample` from the Raku ecosystem with:

```text
zef install App::FontSample
```

EXAMPLE USE
===========

The subroutine exposed for public use is shown here:

    sub create-font-sample(
        PDF::Content::FontObj:D $font,
        Str:D :$name!,
        IO() :$output! where *.so,
        Str:D :$paper = 'Letter',
        Str :$media,
        Bool:D :$landscape = False,
        Numeric:D :$margin = 36,
        Str:D :$family = '',
        Str:D :$style  = '',
        Str:D :$layout = 'specimen',
        Str:D :$title  = 'Font Samples',
        Str :$language = 'en',
        :$debug,
        *%options,
        --> IO::Path:D
    ) is export {...}

The easiest first test uses the standard PDF core font Times-Roman, so no external font file is required.

```raku
use PDF::API6;
use App::FontSample;

my $pdf = PDF::API6.new;
my $font = $pdf.core-font: :family<Times-Roman>;

create-font-sample(
    $font,
    :name<Times-Roman>,
    :title<Font Specimen>, # the default type is 'specimen'
    :language<en>,
    :output<sample.pdf>,
);
```

The **specimen** identifies the font, labels the alphabet and punctuation sizes, labels the pangram as `English (en)`, and includes a size waterfall with each point size shown at the left.

CURRENT OUTPUT LAYOUTS
======================

specimen
--------

The `specimen` layout produces one specimen page per font. It shows the font name, alphabet, numerals and punctuation, a labeled language pangram, and a size waterfall.

See an example at [click here](documents/example-specimen.pdf).

An explicit pangram must also identify its language so the PDF can label it:

NOTE
----

The **collection** and **comparison** sections below render each font at the same nominal point size. Visible character heights may differ because each typeface has its own font metrics.

comparison
----------

The **comparison** layout displays the same text in several fonts at one stated point size. The font name is shown above each sample. The layout continues onto additional pages when needed.

collection
----------

The **collection** layout is a compact one-page inventory of fonts. Each font name is followed by a short typographic identification string. The page title states the sample point size.

If the requested collection cannot fit within the page margins, the layout reports an error rather than overflowing the page.

characters
----------

The **characters** layout displays selected characters in a grid. The page heading identifies the font and glyph point size, and each cell labels the glyph with its Unicode code point.

Library callers may supply **characters** as a string or as a positional collection containing one-character strings, integer Unicode code points, or strings such as `U+0041`.

FONT COLLECTIONS
================

A comparison or collection uses **App::FontSample::FontEntry** objects.

```raku
use App::FontSample;
use App::FontSample::FontEntry;

my @entries;

@entries.push: App::FontSample::FontEntry.new(
    :name<Times-Roman>,
    :font($times),
);

@entries.push: App::FontSample::FontEntry.new(
    :name<Helvetica>,
    :font($helvetica),
);

create-font-collection-sample(
    @entries,
    :layout<comparison>,
    :comparison-size(18),
    :output<comparison.pdf>,
);
```

PAPER AND PAGE OPTIONS
======================

Both `Letter` and `A4` are supported. Pages may be portrait or landscape, and the margin may be set in PostScript points (72 per inch)..

LANGUAGE PANGRAMS
=================

The current built-in pangram registry includes English under the two-letter code `en`.

The resulting specimen labels the text `English (en) pangram`.

List the currently registered language codes with:

```text
font-sample --languages
# OUTPUT:
de - German 
en - English 
es - Spanish 
fr - French 
id - Indonesian 
it - Italian 
nb - Norwegian (Bokmål) 
nl - Dutch 
nn - Norwegian (Nynorsk) 
pl - Polish 
ro - Romanian 
ru - Russian 
uk - Ukrainian
```

Applications may register additional pangrams and language names at runtime.

OTF AND TTF FILES
=================

The installed `font-sample` program loads an OTF or TTF file directly and uses one of the same layout names as shown above.

```text
font-sample \
    --font=/path/to/font.otf \
    --output=sample.pdf \
    --layout=specimen \
    --language=en
```

JSON INPUT
==========

`font-sample` can read one or more jobs from a JSON definition file:

```text
font-sample --config=font-samples.json
```

For example:

```json
{
    "output": "output/sample.pdf",
    "layout": "specimen",
    "language": "en",
    "fonts": [
        {
            "file": "fonts/MyFont.otf",
            "name": "My Font"
        }
    ]
}
```

REPRODUCIBLE PDF OUTPUT
=======================

The normal PDF production process creates a unique document identification number and other metadata that may be different. This program by default does not do that so identical visual documents should compare identifally byte for byte. There is an option to allow the normal process to prevail.

The defaut PDF output is modified so normal unique document identification and other metadata changes are turned off. As a result they should be byte-for-byte reproducible.

use `:reproducible` from Raku or `--reproducible` in direct command-line mode. JSON jobs may use `"reproducible": true`. Normal PDF generation retains the default unique document identification and metadata behavior.

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
    :comparison-size(18),
    :output<noto-comparison.pdf>,
);
```

EXAMPLES
========

`examples/current-capabilities.raku` uses PDF core fonts and creates four PDFs, one for each current layout:

  * `example-specimen.pdf`

  * `example-comparison.pdf`

  * `example-collection.pdf`

  * `example-characters.pdf`

Run the examples like this:

    raku -Ilib examples/current-capabilities.raku

TESTING
=======

Run the normal test suite with `mi6 test` (for modules under `App::Mi6` management) or `zef .`.

```text
mi6 test
```

The normal test suite does not require `NotoFonts-OT`.

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

