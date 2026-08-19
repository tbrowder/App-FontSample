use v6.d;
use PDF::API6;
use PDF::Content::FontObj;
use App::FontSample::Paper;
use App::FontSample::FontEntry;
use App::FontSample::Layout::Specimen;

unit class App::FontSample::PDF;

has App::FontSample::Paper:D $.paper =
    App::FontSample::Paper.new;

has Str:D $.title = 'Font Samples';
has Str:D $.layout = 'specimen';

has $.debug = 0;

submethod TWEAK {
    if $!debug {
        note "DEBUG 8: generating PDF file '$!title'";
    }
}

method render(
    App::FontSample::FontEntry:D $entry,
    IO() :$output! where *.so,
    :$debug,
    *%options,
    --> IO::Path:D
) {
    my $collection-object = self.render-collection(
        [$entry],
        :$output,
        :$debug,
        |%options,
    );

    return $collection-object;
}

method render-font(
    PDF::Content::FontObj:D $font,
    Str:D :$name!,
    IO() :$output! where *.so,
    Str :$family,
    Str:D :$style = 'Regular',
    Str :$source,
    :$debug,
    *%options,
    --> IO::Path:D
) {
    my $entry-object = App::FontSample::FontEntry.new(
        :$name,
        :$font,
        :family($family // ''),
        :$style,
        :$debug,
        :source($source // ''),
    );

    my $render-object = self.render(
        $entry-object,
        :$output,
        :$debug,
        |%options,
    );

    return $render-object;

}

method render-collection(
    Positional:D $entries where *.elems > 0,
    IO() :$output! where *.so,
    *%options,
    --> IO::Path:D
) {
    my PDF::API6 $pdf .= new;

    my PDF::Content::FontObj $label-font =
        $pdf.core-font: :family<Helvetica>;

    my $layout = self.layout-object;

    for $entries.List -> $entry {
        die 'Every collection item must be an App::FontSample::FontEntry'
            unless $entry ~~ App::FontSample::FontEntry;

        my $page = $pdf.add-page;
        $page.media-box = $!paper.media-box;

        $layout.render-page(
            :$pdf,
            :$page,
            :$entry,
            :paper($!paper),
            :$label-font,
            :options(%options),
        );
    }

    my IO::Path $path = $output.IO;

    $pdf.save-as: $path.Str;

    return $path;
}

method layout-object() {
    given $!layout.lc {
        when 'specimen' {
            return App::FontSample::Layout::Specimen.new;
        }
        when 'waterfall' {
            return App::FontSample::Layout::Specimen.new;
        }
        default {
            die "Unknown layout '$!layout'";
        }
    }
}
