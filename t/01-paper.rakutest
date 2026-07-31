use v6.d;
use Test;
use App::FontSample::Paper;

my $letter = App::FontSample::Paper.new;
is-approx $letter.width, 612, 'Letter width';
is-approx $letter.height, 792, 'Letter height';
is-approx $letter.usable-width, 540, 'Letter usable width';
is-approx $letter.usable-height, 720, 'Letter usable height';

my $a4 = App::FontSample::Paper.new(:name<A4>);
is-approx $a4.width, 595.275590551, 'A4 width';
is-approx $a4.height, 841.88976378, 'A4 height';

my $landscape = App::FontSample::Paper.new(:landscape);
is-approx $landscape.width, 792, 'landscape width';
is-approx $landscape.height, 612, 'landscape height';

throws-like {
    App::FontSample::Paper.new(:name<Legal>);
}, X::AdHoc, 'unsupported paper size is rejected';

done-testing;
