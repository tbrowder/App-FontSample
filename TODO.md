TITLE
=====

App::FontSample TODO

SUBTITLE
========

Planned improvements after the first usable release

PURPOSE
=======

This file contains planned work for `App::FontSample`. Keeping future work here allows `README.rakudoc` to concentrate on helping a new user install and use the current release.

The items below are plans, not promises about a particular release.

LAYOUTS
=======

  * Add a dedicated waterfall-only renderer instead of using the specimen renderer for `waterfall`.

  * Continue improving the comparison and collection layouts for larger font sets and more varied sample text.

  * Consider additional layouts such as language samples, font metrics, and Unicode-oriented glyph charts where they add capabilities beyond the current layouts.

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

  * Make it easy for applications to supply additional language samples without modifying `App::FontSample`.

JSON AND COMMAND-LINE USE
=========================

  * Add polished, version-controlled JSON examples for specimen, comparison, collection, and character-grid output.

  * Add more tests that exercise the installed `font-sample` command.

  * Add tests for multi-page comparison and character output.

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

  * Keep the README focused on the shortest path from installation to a successful PDF.

  * Add visual examples of the principal layouts when stable examples are available.

  * Keep optional native-library requirements with the documentation for the font loader or provider that requires them rather than presenting them as requirements of the provider-neutral core.

