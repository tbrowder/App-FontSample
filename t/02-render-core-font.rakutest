use v6.d;
use Test;
use PDF::API6;
use App::FontSample;

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

ok $path.f, 'sample PDF was created';
ok $path.s > 0, 'sample PDF is not empty';

LEAVE {
    $output.unlink if $output.e;
    $dir.rmdir if $dir.d;
}

done-testing;
