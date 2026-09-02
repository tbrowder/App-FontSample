use v6.d;
use Test;

my IO::Path $readme =
    'docs/README.rakudoc'.IO;

my IO::Path $todo =
    'docs/TODO.rakudoc'.IO;

ok $readme.f,
    'docs/README.rakudoc exists';

ok $todo.f,
    'docs/TODO.rakudoc exists';

my Str $text = $readme.slurp;

ok $text.contains('Times-Roman'),
    'README first-use documentation mentions Times-Roman';

ok $text.contains('zef install App::FontSample'),
    'README contains installation command';

ok $text.contains('PDF::Content::FontObj'),
    'README explains the font-object interface';

for <specimen comparison collection characters> -> $layout {
    ok $text.contains("=head2 $layout"),
        "README documents current '$layout' layout";
}

ok (not $text.contains('=head2 waterfall')),
    'README does not document waterfall as a current layout';

ok $text.contains('English (en)'),
    'README documents language-name and language-code pangram labeling';

ok $text.contains('NotoFonts-OT'),
    'README documents optional NotoFonts-OT use';

ok $text.contains('docs/TODO.rakudoc'),
    'README points to the separate TODO document';

done-testing;
