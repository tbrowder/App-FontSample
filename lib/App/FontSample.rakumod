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
    Numeric:D :$margin = 36e0,
    Str:D :$family = '',
    Str:D :$style = 'Regular',
    Str:D :$layout = 'specimen',
    Str:D :$title = 'Font Samples',
    Str :$language,
    Str :$text,
    Str :$pangram,
    Positional :$sizes,
    Str :$characters,
    Numeric :$comparison-size,
    Int :$columns,
    Numeric :$sample-size,
    Numeric :$leading-ratio,
    --> IO::Path:D
) is export {
    my Str $paper-name = $media // $paper;

    my Str $selected-pangram = $pangram;

    if !$selected-pangram.defined and $language.defined {
        $selected-pangram = App::FontSample::SampleText.new.pangram($language);
    }

    my $sampler = App::FontSample::PDF.new(
        :$title,
        :$layout,
        :paper(App::FontSample::Paper.new(
            :paper($paper-name),
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
        :pangram($selected-pangram),
        :$sizes,
        :$characters,
        :$comparison-size,
        :$columns,
        :$sample-size,
        :$leading-ratio,
    );
}

sub create-font-collection-sample(
    Positional:D $entries where *.elems > 0,
    IO() :$output! where *.so,
    Str:D :$paper = 'Letter',
    Str :$media,
    Bool:D :$landscape = False,
    Numeric:D :$margin = 36e0,
    Str:D :$layout = 'comparison',
    Str:D :$title = 'Font Samples',
    Str :$language,
    Str :$text,
    Str :$pangram,
    Positional :$sizes,
    Str :$characters,
    Numeric :$comparison-size,
    Int :$columns,
    Numeric :$sample-size,
    Numeric :$leading-ratio,
    --> IO::Path:D
) is export {
    my Str $paper-name = $media // $paper;
    my Str $selected-pangram = $pangram;

    if !$selected-pangram.defined and $language.defined {
        $selected-pangram = App::FontSample::SampleText.new.pangram($language);
    }

    my $sampler = App::FontSample::PDF.new(
        :$title,
        :$layout,
        :paper(App::FontSample::Paper.new(
            :paper($paper-name),
            :$landscape,
            :$margin,
        )),
    );

    return $sampler.render-collection(
        $entries,
        :$output,
        :$text,
        :pangram($selected-pangram),
        :$sizes,
        :$characters,
        :$comparison-size,
        :$columns,
        :$sample-size,
        :$leading-ratio,
    );
}
