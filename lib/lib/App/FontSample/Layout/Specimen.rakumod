use v6.d;
use App::FontSample::Layout;

unit class App::FontSample::Layout::Specimen does App::FontSample::Layout;

my constant @DEFAULT-SIZES = 8, 10, 12, 16, 20, 28, 36;
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
    my Numeric $top = $paper.height - $paper.margin;
    my Numeric $y = $top;
    my Str $pangram = %options<pangram> // $DEFAULT-PANGRAM;
    my Str $sample-text = %options<text> // $pangram;
    my @sizes = %options<sizes>:exists
        ?? %options<sizes>.List
        !! @DEFAULT-SIZES.List;

    $page.gfx.graphics: -> $gfx {
        $gfx.text: {
            .font = $label-font, 9;
            .text-position = [$left, $y];
            .say: 'APP::FONTSAMPLE';
            $y -= 28;

            .font = $entry.font, 28;
            .text-position = [$left, $y];
            .say: $entry.display-name;
            $y -= 24;

            .font = $label-font, 8;
            .text-position = [$left, $y];
            .say: $entry.name;
            $y -= 30;

            .font = $entry.font, 15;
            .text-position = [$left, $y];
            .say: $DEFAULT-ALPHABET;
            $y -= 24;

            .font = $entry.font, 14;
            .text-position = [$left, $y];
            .say: $DEFAULT-NUMBERS;
            $y -= 34;

            .font = $label-font, 8;
            .text-position = [$left, $y];
            .say: 'PANGRAM';
            $y -= 20;

            .font = $entry.font, 18;
            .text-position = [$left, $y];
            .say: $pangram;
            $y -= 38;

            .font = $label-font, 8;
            .text-position = [$left, $y];
            .say: 'SIZE WATERFALL';
            $y -= 18;

            for @sizes -> $size {
                last if $y - $size < $paper.margin;

                .font = $label-font, 7;
                .text-position = [$left, $y];
                .print: $size.Str ~ ' pt';

                .font = $entry.font, $size;
                .text-position = [$left + 34, $y];
                .say: $sample-text;

                $y -= $size * 1.35;
            }
        }
    }
}
