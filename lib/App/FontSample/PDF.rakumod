use v6.d;
use PDF::API6;
use PDF::Content::FontObj;
use App::FontSample::Paper;
use App::FontSample::FontEntry;
use App::FontSample::Layout::Specimen;

unit class App::FontSample::PDF;

has App::FontSample::Paper:D $.paper = App::FontSample::Paper.new;
has Str:D $.title = 'Font Samples';
has Str $.layout  = 'specimen';

method render(
    App::FontSample::FontEntry:D $entry,
    IO() :$output! where *.so,
    Str :$text,
    Str :$pangram,
    Positional :$sizes,
    --> IO::Path:D
) {
    return self.render-collection(
        $entry,
        :$output,
        :$text,
        :$pangram,
        :$sizes,
    );
}

method render-font(
    PDF::Content::FontObj:D $font,
    Str:D :$name!,
    IO() :$output! where *.so,
    Str   :$family,
    Str:D :$style = 'Regular',
    Str   :$source,
    Str :$text,
    Str :$pangram,
    Positional :$sizes,
    --> IO::Path:D
) {
    my $entry = App::FontSample::FontEntry.new(
        :$name,
        :$font,
        :$family,
        :$style,
        :$source,
    );

    return self.render(
        $entry,
        :$output,
        :$text,
        :$pangram,
        :$sizes,
    );
}

method render-collection(
    Positional:D $entries where *.elems > 0,
    IO() :$output! where *.so,
    Str :$text,
    Str :$pangram,
    Positional :$sizes,
    --> IO::Path:D
) {
    my PDF::API6 $pdf .= new;
    my PDF::Content::FontObj $label-font =
        $pdf.core-font: :family<Helvetica>;

    my %options;
    %options<text>    = $text if $text.defined;
    %options<pangram> = $pangram if $pangram.defined;
    %options<sizes>   = $sizes.List if $sizes.defined;

    my $layout = self.layout-object;

    for $entries.List -> $entry {
        die 'Every collection item must be an App::FontSample::FontEntry'
            unless $entry ~~ App::FontSample::FontEntry;

        my $page = $pdf.add-page;
        $page.media-box = $!paper.media-box;


        $!layout.render-page(
            :$pdf,
            :$page,
            :$entry,
            :paper($!paper),
            :$label-font,
            :%options,
        );
    }

    my IO::Path $path = $output.IO; #.absolute;
    $pdf.save-as: $path.Str;

    return $path;
}

method layout-object() {
    given $!layout.lc {
        when 'specimen' {
            return App::FontSample::Layout::Specimen.new;
        }
        default {
            die "Unknown layout '$!layout'";
        }
    }
}

