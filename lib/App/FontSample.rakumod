use v6.d;
use PDF::Content::FontObj;
use App::FontSample::PDF;
use App::FontSample::Paper;

unit module App::FontSample;

sub create-font-sample(
    PDF::Content::FontObj:D $font,
    Str:D :$name!,
    IO() :$output!, #  where *.so,
    Str:D :$layout = "specimen",
    Str :$text,
    :@sizes,
    Str:D :$media = 'Letter',
    Bool:D :$landscape = False,
    Numeric:D :$margin = 36,
    --> IO::Path:D
) is export {

    return App::FontSample::PDF.new(
        :$media,
        :$landscape,
        :$margin,
    ).render-font(
        $font,
        :$name,
        :$output,
        :$layout,
        :$text,
        :@sizes,
    );
}
