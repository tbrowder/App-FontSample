use v6.d;
use App::FontSample::Layout;

unit class App::FontSample::Layout::Characters
    does App::FontSample::Layout;

my constant $DEFAULT-COLUMNS = 8;
my constant $DEFAULT-GLYPH-SIZE = 30;
my constant $TITLE-HEIGHT = 28;
my constant $CELL-HEIGHT = 72;
my constant $LABEL-HEIGHT = 16;
my constant $OUTER-LINE-WIDTH = 0.6;
my constant $GUIDE-LINE-WIDTH = 0.2;

method render-collection(
    :$pdf!,
    :$entries!,
    :$paper!,
    :$label-font!,
    :%options!,
    --> Nil
) {
    die "The characters layout requires a 'characters' option"
        unless %options<characters>:exists;

    my @characters = self.character-list(
        %options<characters>
    );

    die "The characters layout received no characters"
        unless @characters.elems;

    my Int $columns =
        (%options<columns> // $DEFAULT-COLUMNS).Int;

    die "The characters column count must be positive"
        if $columns < 1;

    my Numeric $glyph-size =
        %options<glyph-size> // $DEFAULT-GLYPH-SIZE;

    die "The character glyph size must be positive"
        if $glyph-size <= 0;

    my Numeric $available-height =
        $paper.usable-height - $TITLE-HEIGHT;

    my Int $rows-per-page =
        ($available-height / $CELL-HEIGHT).floor.Int;

    die "The paper margins leave no room for character rows"
        if $rows-per-page < 1;

    my Int $characters-per-page =
        $rows-per-page * $columns;

    my Numeric $cell-width =
        $paper.usable-width / $columns;

    for $entries.List -> $entry {
        my Int $offset = 0;

        while $offset < @characters.elems {
            my Int $limit =
                $offset + $characters-per-page;

            $limit = @characters.elems
                if $limit > @characters.elems;

            my $page = $pdf.add-page;
            $page.media-box = $paper.media-box;

            my Numeric $left = $paper.margin;
            my Numeric $top =
                $paper.height - $paper.margin;

            my Str $title =
                %options<title>
                // 'CHARACTERS';

            my Str $display-name =
                $entry.display-name;

            $page.gfx.graphics: -> $gfx {
                $gfx.text: {
                    .font = $label-font, 9;
                    .text-position = [$left, $top];
                    .say: "$title — $display-name — {$glyph-size} pt";
                }

                my Numeric $grid-top =
                    $top - $TITLE-HEIGHT;

                my Int $index = $offset;
                my Int $slot = 0;

                while $index < $limit {
                    my Str $character =
                        @characters[$index];

                    my Int $row =
                        $slot div $columns;

                    my Int $column =
                        $slot % $columns;

                    my Numeric $cell-left =
                        $left + $column * $cell-width;

                    my Numeric $cell-top =
                        $grid-top - $row * $CELL-HEIGHT;

                    my Numeric $cell-bottom =
                        $cell-top - $CELL-HEIGHT;

                    my Numeric $cell-center =
                        $cell-left + $cell-width / 2;

                    my Numeric $baseline =
                        $cell-bottom + $LABEL-HEIGHT + 8;

                    # This first pass uses a half-em x-height guide.
                    # It keeps the layout independent of font-provider
                    # implementation details.
                    my Numeric $x-height =
                        $glyph-size * 0.50;

                    my Numeric $x-height-y =
                        $baseline + $x-height;

                    $gfx.graphics: {
                        .LineWidth = $OUTER-LINE-WIDTH;
                        .Rectangle(
                            $cell-left,
                            $cell-bottom,
                            $cell-width,
                            $CELL-HEIGHT,
                        );
                        .Stroke;

                        .LineWidth = $GUIDE-LINE-WIDTH;

                        .MoveTo($cell-left, $baseline);
                        .LineTo(
                            $cell-left + $cell-width,
                            $baseline,
                        );
                        .Stroke;

                        .MoveTo($cell-left, $x-height-y);
                        .LineTo(
                            $cell-left + $cell-width,
                            $x-height-y,
                        );
                        .Stroke;
                    }

                    $gfx.text: {
                        .font = $entry.font, $glyph-size;
                        .text-position = [$cell-center, $baseline];
                        .say: $character,
                            :align<center>,
                            :baseline-shift<alphabetic>;

                        my Str $code = sprintf(
                            'U+%04X',
                            $character.ord,
                        );

                        my Numeric $label-y =
                            $cell-bottom + 4;

                        .font = $label-font, 7;
                        .text-position = [$cell-center, $label-y];
                        .say: $code,
                            :align<center>;
                    }

                    ++$index;
                    ++$slot;
                }
            }

            $offset = $limit;
        }
    }

    return;
}

method character-list(
    $value
    --> Array
) {
    my @characters;

    if $value ~~ Str {
        for $value.comb -> $character {
            @characters.push: $character;
        }

        return @characters;
    }

    if $value ~~ Positional {
        for $value.List -> $item {
            if $item ~~ Int {
                @characters.push: $item.chr;
                next;
            }

            my Str $text = $item.Str;

            if $text.starts-with('U+') {
                my Str $hex = $text.substr(2);
                my Int $codepoint = $hex.parse-base(16);
                @characters.push: $codepoint.chr;
                next;
            }

            die "Character item '$text' must contain one character, "
                ~ "an integer code point, or U+XXXX"
                unless $text.chars == 1;

            @characters.push: $text;
        }

        return @characters;
    }

    die "The characters option must be a Str or Positional value";
}
