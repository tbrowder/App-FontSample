use v6.d; 
use Test; 
use PDF::API6; 
use App::FontSample;

my $debug = 1;
note "\$debug is on" if $debug;

my $pdf = PDF::API6.new;
my $font = $pdf.core-font: :family<Helvetica>;
my $dir = $*TMPDIR.add("app-fontsample-$*PID");
$dir.mkdir;
my $output = $dir.add('sample.pdf');

my $path = create-font-sample(
    $font,
    :name<Helvetica>,
    :output($output),
);

if $debug {
    say "DEBUG: See PDF file '$path'";
}

ok $path.f, 'sample PDF was created';
ok $path.s > 0, 'sample PDF is not empty';

LEAVE {
    unless $debug {
        $output.unlink if $output.e;
        $dir.rmdir if $dir.d;
    }
}


done-testing;
