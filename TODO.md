TITLE
=====

App::FontSample TODO

SUBTITLE
========

Planned improvements after the current release

PURPOSE
=======

This file contains planned work for `App::FontSample`. The README documents current capability only.

LAYOUTS
=======

  * Consider adding a dedicated `waterfall` layout if a waterfall-only sample proves useful. The current `specimen` layout already contains a clearly labeled size waterfall.

  * Continue improving comparison and collection layouts for larger font sets and more varied sample text.

  * Consider additional layouts for language samples and font metrics.

CHARACTER AND GLYPH DISPLAY
===========================

  * Add optional character-cell borders.

  * Add optional baseline and cap-height guides.

  * Add left and right edge tick marks for visual font-metric inspection.

  * Add convenient Unicode range notation such as `0020..007E`.

  * Investigate named Unicode block selection.

  * Improve handling and presentation of characters not present in the selected font.

LANGUAGE SAMPLES
================

  * Expand the built-in language pangram registry beyond English.

  * Keep each registered pangram associated with both a language name and its two-letter language code so specimen labels remain self-identifying.

  * Document which sample languages are covered by commonly used font families.

JSON AND COMMAND-LINE USE
=========================

  * Add separate version-controlled JSON examples for each principal layout.

  * Add more tests that exercise the installed `font-sample` command.

  * Add tests that explicitly verify multi-page comparison and character output.

  * Review command-line diagnostics and error messages for missing fonts, bad paths, unsupported layouts, and malformed configuration files.

FONT PROVIDERS
==============

  * Keep `App::FontSample` provider-neutral.

  * Continue testing `NotoFonts-OT` as an optional integration rather than making it a required dependency.

  * Consider a separate helper or system tool for discovering and installing additional Noto fonts and font weights.

API AND INTERNAL CLEANUP
========================

  * Review whether `App::FontSample::Provider` is still useful.

  * Review public option names as the layouts mature and keep common options consistent across layouts.

  * Continue separating font acquisition, page description, and layout rendering.

DOCUMENTATION
=============

  * Add visual PDF examples to the published documentation when practical.

