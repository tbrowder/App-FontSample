use v6.d;
use App::FontSample::Layout;

unit class App::FontSample::Layout::Specimen
    does App::FontSample::Layout;

my constant @DEFAULT-SIZES =
    8, 10, 12, 16, 20, 28, 36;

my constant $DEFAULT-PANGRAM =
    'The quick brown fox jumps over the lazy dog.';

my constant $DEFAULT-ALPHABET =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ  abcdefghijklmnopqrstuvwxyz';

my constant $DEFAULT-NUMBERS =
    '0123456789  ! ? & @ # $ % ( ) [ ] { } / \\ + − × =';

method render-page(
    :$pdf!,
    :$page!,
    :$entry!,
    :$paper!,
    :$label-font!,
    :%options!,
    --> Nil
) {
    my Numeric $left = $paper.margin;
    my Numeric $right =
        $paper.width - $paper.margin;

    my Numeric $y =
        $paper.height - $paper.margin;

    my Str $pangram =
        %options<pangram> // $DEFAULT-PANGRAM;

    my Str $sample-text =
        %options<text> // $pangram;

    my @sizes = %options<sizes>:exists
        ?? %options<sizes>.List
        !! @DEFAULT-SIZES.List;

    my Str $display-name =
        $entry.display-name;

    $page.gfx.graphics: -> $gfx {
        $gfx.text: {
            .font = $label-font, 9;
            .text-position = [$left, $y];
            .say: %options<title>
                // 'APP::FONTSAMPLE';

            $y -= 28;

            .font = $entry.font, 28;
            .text-position = [$left, $y];
            .say: $display-name,
                :width($paper.usable-width);

            $y -= 28;

            if $display-name ne $entry.name {
                .font = $label-font, 8;
                .text-position = [$left, $y];
                .say: $entry.name;

                $y -= 20;
            }

            .font = $entry.font, 15;
            .text-position = [$left, $y];
            .say: $DEFAULT-ALPHABET,
                :width($paper.usable-width);

            $y -= 24;

            .font = $entry.font, 14;
            .text-position = [$left, $y];
            .say: $DEFAULT-NUMBERS,
                :width($paper.usable-width);

            $y -= 34;

            .font = $label-font, 8;
            .text-position = [$left, $y];
            .say: 'PANGRAM';

            $y -= 20;

            .font = $entry.font, 18;
            .text-position = [$left, $y];
            .say: $pangram,
                :width($paper.usable-width);

            $y -= 38;

            .font = $label-font, 8;
            .text-position = [$left, $y];
            .say: 'SIZE WATERFALL';

            $y -= 18;

            for @sizes -> $size {
                my Numeric $line-height =
                    $size * 1.35;

                last
                    if $y - $line-height
                    < $paper.margin;

                .font = $label-font, 7;
                .text-position = [$left, $y];
                .print: $size.Str ~ ' pt';

                my Numeric $sample-left =
                    $left + 34;

                .font = $entry.font, $size;
                .text-position = [$sample-left, $y];
                .say: $sample-text,
                    :width(
                        $right - $sample-left
                    ),
                    :height($line-height);

                $y -= $line-height;
            }
        }
    }

    return;
}
