use v6.d;
use Test;

use NotoFonts-OT;
use NotoFonts-OT::FontPaths;

use App::FontSample;
use App::FontSample::Layout;

my $debug = 1;

my $code = "NotoSerif-Regular";
my $font = get-loaded-font $code;

my $output = "waterfall-$code.pdf".IO;

my $path = create-font-sample(
    $font,
    :name($code),
    :media<Letter>, 
    :layout<waterfall>,
    :output($output),
    :text("Sphinx of black quartz, judge my vow. 0123456789"),
    :sizes(8, 9, 10, 11, 12, 14, 18, 24, 30, 36, 48, 60),
);

ok $path.f, "waterfall PDF was created";
ok $path.s > 0, "waterfall PDF is not empty";

note "PDF: $path" if $debug;

say "See output file: $path"; 
say "See output file: $output"; 

LEAVE {
    unless $debug {
        $output.unlink if $output.e;
    }
}

done-testing;

