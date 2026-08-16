use v6.d;
use PDF::Content::FontObj;
use App::FontSample::PDF;
use App::FontSample::Paper;
use App::FontSample::FontEntry;
use App::FontSample::SampleText;

unit module App::FontSample;

sub create-font-sample(
    PDF::Content::FontObj:D $font,
    Str:D :$name!,
    IO() :$output! where *.so,
    Str:D :$paper = 'Letter',
    Str :$media,
    Bool:D :$landscape = False,
    Numeric:D :$margin = 36,
    Str:D :$family = '',
    Str:D :$style = 'Regular',
    Str:D :$layout = 'specimen',
    Str:D :$title = 'Font Samples',
    Str :$language,
    *%options,
    --> IO::Path:D
) is export {
    my Str $paper-name = $media // $paper;

    if !%options<pangram>:exists
        and $language.defined {
        %options<pangram> =
            App::FontSample::SampleText.new.pangram(
                $language
            );
    }

    my $sampler =
        App::FontSample::PDF.new(
            :$title,
            :$layout,
            :paper(
                App::FontSample::Paper.new(
                    :paper($paper-name),
                    :$landscape,
                    :$margin,
                )
            ),
        );

    return $sampler.render-font(
        $font,
        :$name,
        :$family,
        :$style,
        :$output,
        |%options,
    );
}

sub create-font-collection-sample(
    Positional:D $entries where *.elems > 0,
    IO() :$output! where *.so,
    Str:D :$paper = 'Letter',
    Str :$media,
    Bool:D :$landscape = False,
    Numeric:D :$margin = 36,
    Str:D :$layout = 'specimen',
    Str:D :$title = 'Font Samples',
    Str :$language,
    *%options,
    --> IO::Path:D
) is export {
    my Str $paper-name = $media // $paper;

    if !%options<pangram>:exists
        and $language.defined {
        %options<pangram> =
            App::FontSample::SampleText.new.pangram(
                $language
            );
    }

    my $sampler =
        App::FontSample::PDF.new(
            :$title,
            :$layout,
            :paper(
                App::FontSample::Paper.new(
                    :paper($paper-name),
                    :$landscape,
                    :$margin,
                )
            ),
        );

    return $sampler.render-collection(
        $entries,
        :$output,
        |%options,
    );
}
