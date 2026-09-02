TITLE
=====

App::FontSample TODO

SUBTITLE
========

Planned improvements after the current release

PURPOSE
=======

This file contains planned work for `App::FontSample`. These items are not current capabilities and therefore are intentionally kept out of the user documentation in `README.rakudoc`.

LAYOUTS
=======

  * Add a dedicated waterfall-only renderer instead of using the specimen renderer for `waterfall`.

  * Continue improving the comparison and collection layouts for larger font sets and more varied sample text.

  * Consider additional layouts for language samples and font metrics.

CHARACTER AND GLYPH DISPLAY
===========================

  * Add optional character-cell borders.

  * Add optional baseline and cap-height guides.

  * Add small left and right edge tick marks for visual font-metric inspection.

  * Extend `characters` input with convenient Unicode range notation such as `0020..007E`.

  * Investigate named Unicode block selection.

  * Improve handling and presentation of characters not present in the selected font.

LANGUAGE SAMPLES
================

  * Expand the built-in language sample and pangram registry.

  * Document which sample languages are covered by commonly used font families.

  * Continue making it easy for applications to supply additional language samples without modifying `App::FontSample`.

JSON AND COMMAND-LINE USE
=========================

  * Add separate version-controlled JSON example files for each principal layout.

  * Add more tests that exercise the installed `font-sample` command.

  * Add tests that explicitly verify multi-page comparison and character output.

  * Review command-line diagnostics and error messages for missing fonts, bad paths, unsupported layouts, and malformed configuration files.

FONT PROVIDERS
==============

  * Keep `App::FontSample` provider-neutral. Font discovery, installation, and collection-specific behavior should remain outside the core sampler.

  * Continue testing `NotoFonts-OT` as an optional integration rather than making it a required dependency.

  * Consider a separate helper or system tool for discovering and installing additional Noto fonts and font weights.

API AND INTERNAL CLEANUP
========================

  * Review whether `App::FontSample::Provider` is still useful. Remove it in a later API cleanup if the `PDF::Content::FontObj` interface has made it obsolete.

  * Review public option names as the layouts mature and keep common options consistent across layouts.

  * Continue separating font acquisition, page description, and layout rendering so new layouts do not require changes to font-provider code.

DOCUMENTATION
=============

  * Add visual PDF examples to the published documentation when there is a practical way to distribute and maintain them.

  * Keep optional native-library requirements with the documentation for the font loader or provider that requires them rather than presenting them as requirements of the provider-neutral core.

