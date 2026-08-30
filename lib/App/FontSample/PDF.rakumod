use v6.d;
use PDF::API6;
use PDF::Content::FontObj;
use App::FontSample::Paper;
use App::FontSample::FontEntry;
use App::FontSample::Layout::Specimen;
use App::FontSample::Layout::Collection;
use App::FontSample::Layout::Comparison;
use App::FontSample::Layout::Characters;

unit class App::FontSample::PDF;

has App::FontSample::Paper:D $.paper =
    App::FontSample::Paper.new;

has Str:D $.title = 'Font Samples';
has Str:D $.layout = 'specimen';
has $.debug = 0;

method render(
    App::FontSample::FontEntry:D $entry,
    IO() :$output! where *.so,
    *%options,
    --> IO::Path:D
) {
    my @entries;
    @entries.push: $entry;

    return self.render-collection(
        @entries,
        :$output,
        |%options,
    );
}

method render-font(
    PDF::Content::FontObj:D $font,
    Str:D :$name!,
    IO() :$output! where *.so,
    Str:D :$family = '',
    Str:D :$style = '',
    Str:D :$source = '',
    *%options,
    --> IO::Path:D
) {
    my $entry = App::FontSample::FontEntry.new(
        :$name,
        :$font,
        :$family,
        :$style,
        :$source,
        :debug($!debug),
    );

    return self.render(
        $entry,
        :$output,
        |%options,
    );
}

method render-collection(
    Positional:D $entries where *.elems > 0,
    IO() :$output! where *.so,
    *%options,
    --> IO::Path:D
) {
    note 'render-collection: starting'
        if $!debug;

    my PDF::API6 $pdf .= new;

    my PDF::Content::FontObj $label-font =
        $pdf.core-font: :family<Helvetica>;

    my $layout = self.layout-object;
    my %render-options = %options.Hash;

    %render-options<title> = $!title
        unless %render-options<title>:exists;

    note "render-collection: using {$layout.^name}"
        if $!debug;

    $layout.render-collection(
        :$pdf,
        :$entries,
        :paper($!paper),
        :$label-font,
        :options(%render-options),
    );

    my IO::Path $path = $output.IO;

    note "render-collection: saving '$path'"
        if $!debug;

    $pdf.save-as: $path.Str;

    note 'render-collection: finished'
        if $!debug;

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
        when 'collection' {
            return App::FontSample::Layout::Collection.new;
        }
        when 'comparison' {
            return App::FontSample::Layout::Comparison.new;
        }
        when 'characters' {
            return App::FontSample::Layout::Characters.new;
        }
        default {
            die "Unknown layout '$!layout'";
        }
    }
}
