use v6.d;
use Test;
use App::FontSample::ConfigFile;

my Bool $debug = False;
my IO::Path $dir =
    $*TMPDIR.add("app-fontsample-config-file-$*PID");

$dir.mkdir;

my IO::Path $file =
    $dir.add('samples.json');

$file.spurt: q:to/JSON/;
{
    "defaults": {
        "paper": "A4",
        "margin": 40,
        "language": "en",
        "fonts": [
            {
                "file": "fonts/Test.otf",
                "name": "Test Regular"
            }
        ]
    },
    "samples": [
        {
            "output": "out/one.pdf",
            "layout": "waterfall",
            "sizes": [10, 20]
        },
        {
            "output": "out/two.pdf",
            "paper": "Letter",
            "layout": "collection",
            "sample-size": 14
        }
    ]
}
JSON

my $definition =
    App::FontSample::ConfigFile.from-file($file);

is $definition.samples.elems, 2,
    'two sample jobs were read';

my $first = $definition.samples[0];

is $first.paper, 'A4',
    'first job inherits paper default';

is $first.margin, 40,
    'first job inherits margin default';

is $first.language, 'en',
    'first job inherits language default';

is $first.pangram,
    'The quick brown fox jumps over the lazy dog.',
    'language selects the registered pangram';

is $first.fonts.elems, 1,
    'first job inherits font list';

my $second = $definition.samples[1];

is $second.paper, 'Letter',
    'sample value overrides paper default';

is $second.sample-size, 14,
    'sample-specific option was read';

my IO::Path $expected =
    $dir.add('out/two.pdf');

is $second.output.Str, $expected.Str,
    'sample output is relative to definition file';

LEAVE {
    unless $debug {
        $file.unlink if $file.e;
        $dir.rmdir if $dir.d;
    }
}

done-testing;
