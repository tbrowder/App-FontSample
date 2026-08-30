use v6.d;
use Test;
use PDF::API6;
use App::FontSample;

my Bool $debug = False;

my $pdf = PDF::API6.new;
my $font = $pdf.core-font: :family<Helvetica>;

my IO::Path $dir =
    $*TMPDIR.add(
        "app-fontsample-characters-$*PID"
    );

$dir.mkdir;

my IO::Path $output =
    $dir.add('characters.pdf');

my Str $characters =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    ~ 'abcdefghijklmnopqrstuvwxyz'
    ~ '0123456789';

my IO::Path $path =
    create-font-sample(
        $font,
        :name<Helvetica>,
        :layout<characters>,
        :$characters,
        :columns(8),
        :output($output),
        :$debug,
    );

ok $path.f,
    'characters PDF was created';

ok $path.s > 0,
    'characters PDF is not empty';

LEAVE {
    unless $debug {
        $output.unlink
            if $output.e;

        $dir.rmdir
            if $dir.d;
    }
}

done-testing;
