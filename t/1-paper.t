use v6.d;
use Test;

use App::FontSample::Paper;

# dimens in PS points
my $letter = App::FontSample::Paper.new;
is $letter.width, 612, 'Letter width';
is $letter.height, 792, 'Letter height';
is $letter.usable-width, 540, 'Letter usable width';
is $letter.usable-height, 720, 'Letter usable height';

# 
my $a4 = App::FontSample::Paper.new(:paper<A4>);
is $a4.width, 595, 'A4 width';
is $a4.height, 842, 'A4 height';

my $landscape = App::FontSample::Paper.new(:landscape);
is $landscape.width, 792, 'landscape width';
is $landscape.height, 612, 'landscape height';

=begin comment
throws-like {
    App::FontSample::Paper.new(:name<Legal>);
}, X::AdHoc, 'unsupported paper size is rejected';
=end comment

done-testing;
