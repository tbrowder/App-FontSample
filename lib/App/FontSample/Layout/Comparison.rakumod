use v6.d;
use App::FontSample::Layout;

unit class App::FontSample::Layout::Comparison
    does App::FontSample::Layout;

my constant $DEFAULT-TEXT =
    'The quick brown fox jumps over the lazy dog. 0123456789';

my constant $DEFAULT-SIZE = 18;
my constant $TITLE-HEIGHT = 28;
my constant $LABEL-HEIGHT = 10;
my constant $ROW-GAP = 8;

method render-collection(
    :$pdf!,
    :$entries!,
    :$paper!,
    :$label-font!,
    :%options!,
    --> Nil
) {
    my Numeric $sample-size =
        %options<comparison-size> // $DEFAULT-SIZE;

    die 'comparison-size must be greater than zero'
        unless $sample-size > 0;

    my Numeric $sample-height =
        $sample-size * 1.30;

    my Numeric $row-height =
        $LABEL-HEIGHT + $sample-height + $ROW-GAP;

    my Numeric $available-height =
        $paper.usable-height - $TITLE-HEIGHT;

    my Int $rows-per-page =
        ($available-height / $row-height).floor.Int;

    die 'The paper margins leave no room for comparison rows'
        if $rows-per-page < 1;

    my Str $text =
        %options<text>
        // %options<pangram>
        // $DEFAULT-TEXT;

    my Int $offset = 0;

    while $offset < $entries.elems {
        my $page = $pdf.add-page;
        $page.media-box = $paper.media-box;

        my Numeric $left = $paper.margin;
        my Numeric $y =
            $paper.height - $paper.margin;

        my Int $limit =
            $offset + $rows-per-page;

        $limit = $entries.elems
            if $limit > $entries.elems;

        $page.gfx.graphics: -> $gfx {
            $gfx.text: {
                .font = $label-font, 9;
                .text-position = [$left, $y];
                .say: (%options<title> // 'FONT COMPARISON')
                    ~ " — {$sample-size} pt";

                $y -= $TITLE-HEIGHT;

                my Int $index = $offset;

                while $index < $limit {
                    my $entry = $entries[$index];

                    .font = $label-font, 7;
                    .text-position = [$left, $y];
                    .say: $entry.display-name;

                    $y -= $LABEL-HEIGHT;

                    .font = $entry.font, $sample-size;
                    .text-position = [$left, $y];
                    .say: $text,
                        :width($paper.usable-width),
                        :height($sample-height);

                    $y -= $sample-height + $ROW-GAP;
                    ++$index;
                }
            }
        }

        $offset = $limit;
    }

    return;
}
