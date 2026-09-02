use v6.d;
use Test;

my IO::Path $readme =
    'docs/README.rakudoc'.IO;

my IO::Path $todo =
    'docs/TODO.rakudoc'.IO;

my IO::Path $example =
    'examples/current-capabilities.raku'.IO;

ok $readme.f,
    'current README exists';

ok $todo.f,
    'TODO exists';

ok $example.f,
    'current-capabilities example exists';

my Str $text = $readme.slurp;

for <
    specimen
    waterfall
    comparison
    collection
    characters
> -> $layout {
    ok $text.contains("=head2 $layout"),
        "README documents current '$layout' layout";
}

ok $text.contains('Times-Roman'),
    'README first example uses Times-Roman';

ok $text.contains('font-sample --languages'),
    'README documents language listing';

ok $text.contains('font-sample --config=font-samples.json'),
    'README documents JSON configuration';

ok $text.contains('docs/TODO.rakudoc'),
    'README sends future work to TODO';

my Str $future = $todo.slurp;

ok $future.contains('dedicated waterfall-only renderer'),
    'future waterfall renderer remains in TODO';

done-testing;
