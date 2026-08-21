use v6.d;
use Test;
use PDF::API6;
use App::FontSample;
use App::FontSample::FontEntry;

my Bool $debug = False;

my $pdf = PDF::API6.new;
my @entries;

for 1 .. 10 -> $number {
    my $font =
        $pdf.core-font:
            :family<Helvetica>;

    my $entry =
        App::FontSample::FontEntry.new(
            :name("Helvetica $number"),
            :$font,
        );

    @entries.push: $entry;
}

my IO::Path $dir =
    $*TMPDIR.add(
        "app-fontsample-collection-$*PID"
    );

$dir.mkdir;

my IO::Path $output =
    $dir.add('collection.pdf');

my IO::Path $path =
    create-font-collection-sample(
        @entries,
        :layout<collection>,
        :sample-size(14),
        :output($output),
        :$debug,
    );

ok $path.f,
    'collection PDF was created';

ok $path.s > 0,
    'collection PDF is not empty';

LEAVE {
    unless $debug {
        $output.unlink
            if $output.e;

        $dir.rmdir
            if $dir.d;
    }
}

done-testing;
