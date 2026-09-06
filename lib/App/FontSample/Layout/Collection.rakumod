use v6.d;

use App::FontSample::Layout;

unit class App::FontSample::Layout::Collection
    does App::FontSample::Layout;

my constant $DEFAULT-TEXT =
    'Aa Bb Cc Dd Ee Ff Gg 0123456789';

method render-collection(
    :$pdf!,
    :$entries!,
    :$paper!,
    :$label-font!,
    :%options!,
    --> Nil
) {
    my Numeric $sample-size =
        %options<sample-size> // 14;

    my Numeric $leading-ratio =
        %options<leading-ratio> // 0.20;

    my Numeric $line-height =
        $sample-size * (1 + $leading-ratio);

    my Numeric $label-height = 14;
    my Numeric $row-gap = 8;

    my Numeric $row-height =
        $label-height + $line-height + $row-gap;

    my Numeric $title-height = 28;

    my Numeric $required-height =
        $title-height + $row-height * $entries.elems;

    die "The collection will not fit on one page at "
        ~ "{$sample-size} pt"
        if $required-height > $paper.usable-height;

    my $page = $pdf.add-page;
    $page.media-box = $paper.media-box;

    my Numeric $left = $paper.margin;
    my Numeric $y =
        $paper.height - $paper.margin;

    my Str $text =
        %options<text> // $DEFAULT-TEXT;

    $page.gfx.graphics: -> $gfx {
        $gfx.text: {
            .font = $label-font, 9;
            .text-position = [$left, $y];
            .say: (%options<title> // 'FONT COLLECTION')
                ~ " — {$sample-size} pt";

            $y -= $title-height;

            for $entries.List -> $entry {
                .font = $label-font, 7;
                .text-position = [$left, $y];
                .say: $entry.display-name;

                $y -= $label-height;

                .font = $entry.font, $sample-size;
                .text-position = [$left, $y];
                .say: $text,
                    :width($paper.usable-width),
                    :height($line-height);

                $y -= $line-height + $row-gap;
            }
        }
    }

    return;
}
