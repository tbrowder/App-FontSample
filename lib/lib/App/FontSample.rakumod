use v6.d;
use PDF::Content::FontObj;
use App::FontSample::PDF;
use App::FontSample::Paper;

unit module App::FontSample;

sub create-font-sample(
    PDF::Content::FontObj:D $font,
    Str:D :$name!,
    IO() :$output! where *.so,
    Str:D :$paper = 'Letter',
    Bool:D :$landscape = False,
    Numeric:D :$margin = 36e0,
    Str:D :$family = '',
    Str:D :$style = 'Regular',
    Str :$text,
    Str :$pangram,
    Positional :$sizes,
    --> IO::Path:D
) is export {
    my $sampler = App::FontSample::PDF.new(
        :paper(App::FontSample::Paper.new(
            :name($paper),
            :$landscape,
            :$margin,
        )),
    );

    return $sampler.render-font(
        $font,
        :$name,
        :$family,
        :$style,
        :$output,
        :$text,
        :$pangram,
        :$sizes,
    );
}
