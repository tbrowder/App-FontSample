use v6.d;
use Test;

use App::FontSample::PDF;

for <specimen comparison collection characters> -> $name {
    my $pdf = App::FontSample::PDF.new(
        :layout($name),
    );

    lives-ok {
        $pdf.layout-object;
    }, "current layout '$name' is accepted";
}

my $old = App::FontSample::PDF.new(
    :layout<waterfall>,
);

throws-like {
    $old.layout-object;
}, X::AdHoc, 'waterfall is no longer a public layout name';

done-testing;
