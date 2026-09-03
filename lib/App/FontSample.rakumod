use v6.d;

use PDF::Content::FontObj;

use App::FontSample::PDF;
use App::FontSample::Paper;
use App::FontSample::FontEntry;
use App::FontSample::SampleText;

unit module App::FontSample;

my $debug = 1;
sub create-font-sample(
    PDF::Content::FontObj:D $font,
    Str:D :$name!,
    IO() :$output! where *.so,
    Str:D :$paper = 'Letter',
    Str :$media,
    Bool:D :$landscape = False,
    Numeric:D :$margin = 36,
    Str:D :$family = '',
    Str:D :$style = '',
    Str:D :$layout = 'specimen',
    Str:D :$title = 'Font Samples',
    Str :$language,
    :$debug,
    *%options,
    --> IO::Path:D
) is export {
    note 'create-font-sample: start' if $debug;
    if $debug {
        note "DEBUG: title = '$title'";
        note "DEBUG: name  = '$name'";
        note "DEBUG: output   = '$output'";
        ; # ok
    }

    my Str $paper-name = $media // $paper;

    if %options<pangram>:exists
        and (not $language.defined) {
        die 'An explicit pangram requires :language<xx> so it can be labeled';
    }

    if $language.defined {
        %options<language> = $language;

        if (not %options<pangram>:exists) {
            %options<pangram> =
                App::FontSample::SampleText.new.pangram(
                    $language,
                );
        }
    }

    my $paper-object = App::FontSample::Paper.new(
        :paper($paper-name),
        :$landscape,
        :$margin,
        :$debug,
    );

    my $sampler = App::FontSample::PDF.new(
        :$title,
        :$layout,
        :$debug,
        :paper($paper-object),
    );

    note 'create-font-sample: rendering' if $debug;

    return $sampler.render-font(
        $font,
        :$name,
        :$family,
        :$style,
        :$output,
        :$debug,
        |%options,
    );
}

sub create-font-collection-sample(
    @entries where *.elems > 0,
    IO() :$output! where *.so,
    Str:D :$paper = 'Letter',
    Str :$media,
    Bool:D :$landscape = False,
    Numeric:D :$margin = 36,
    Str:D :$layout = 'comparison',
    Str:D :$title = 'Font Samples',
    Str :$language,
    :$debug,
    *%options,
    --> IO::Path:D
) is export {
    note 'create-font-collection-sample: start' if $debug;

    my Str $paper-name = $media // $paper;
    my %render-options = %options.Hash;

    if %render-options<pangram>:exists
        and (not $language.defined) {
        die 'An explicit pangram requires :language<xx> so it can be labeled';
    }

    if $language.defined {
        %render-options<language> = $language;

        if (not %render-options<pangram>:exists) {
            %render-options<pangram> =
                App::FontSample::SampleText.new.pangram(
                    $language,
                );
        }
    }

    my $paper-object = App::FontSample::Paper.new(
        :paper($paper-name),
        :$landscape,
        :$margin,
        :$debug,
    );

    my $sampler = App::FontSample::PDF.new(
        :$title,
        :$layout,
        :$debug,
        :paper($paper-object),
    );

    note 'create-font-collection-sample: rendering' if $debug;

    return $sampler.render-collection(
        @entries,
        :$output,
        :$debug,
        |%render-options,
    );
}
