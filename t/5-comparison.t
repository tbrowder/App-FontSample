use v6.d;
use Test;
use PDF::API6;
use App::FontSample;
use App::FontSample::FontEntry;

my Bool $debug = False;

my $pdf = PDF::API6.new;
my $font = $pdf.core-font: :family<Helvetica>;

my @entries;

for 1..12 -> $number {
    @entries.push: App::FontSample::FontEntry.new(
        :name("Helvetica $number"),
        :$font,
    );
}

my IO::Path $dir =
    $*TMPDIR.add(
        "app-fontsample-comparison-$*PID"
    );

$dir.mkdir;

my IO::Path $output =
    $dir.add('comparison.pdf');

my IO::Path $path =
    create-font-collection-sample(
        @entries,
        :layout<comparison>,
        :comparison-size(18),
        :output($output),
        :$debug,
    );

ok $path.f,
    'comparison PDF was created';

ok $path.s > 0,
    'comparison PDF is not empty';

LEAVE {
    unless $debug {
        $output.unlink
            if $output.e;

        $dir.rmdir
            if $dir.d;
    }
}

done-testing;
