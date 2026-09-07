use Test;

use App::FontSample;
use NotoFonts-OT;

my $font-path = get-font-path("NotoSerif-Regular");

ok $font-path.IO.f,
    "Noto Serif Regular font exists";

#done-testing;
#=finish

my $json-file = "data/json-test-generated.json".IO;
my $pdf-file  = "data/json-test.pdf".IO;

my $json = qq:to/END/;
\{
    "output": "json-test.pdf",
    "layout": "specimen",
    "title": "JSON Configuration Test",
    "paper": "Letter",
    "margin": 36,
    "reproducible": true,
    "fonts": [
        \{
            "file": "$font-path",
            "name": "Noto Serif Regular"
        }
    ]
}
END

$json-file.spurt($json);

my $proc = run(
    $*EXECUTABLE,
    "-Ilib",
    "bin/font-sample",
    "--config={$json-file.Str}",
    :out,
    :err,
);

my $stdout = $proc.out.slurp-rest;
my $stderr = $proc.err.slurp-rest;

is $proc.exitcode, 0,
    "JSON configuration exits successfully";

ok $pdf-file.f,
    "JSON configuration creates PDF";

if $proc.exitcode != 0 {
    diag "stdout:\n$stdout" if $stdout.chars;
    diag "stderr:\n$stderr" if $stderr.chars;
}

unlink $json-file if $json-file.f;
unlink $pdf-file  if $pdf-file.f;

done-testing;
