use v6.d;
use App::FontSample::Layout;

unit class App::FontSample::Layout::Characters
    does App::FontSample::Layout;

my constant $DEFAULT-COLUMNS = 8;
my constant $DEFAULT-GLYPH-SIZE = 30;
my constant $TITLE-HEIGHT = 28;
my constant $CELL-HEIGHT = 58;

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

                        my Numeric $glyph-left =
                            $cell-left + $cell-width * 0.28;

                        my Numeric $glyph-y =
                            $cell-top - 28;

                        .font = $entry.font, $glyph-size;
                        .text-position = [$glyph-left, $glyph-y];
                        .say: $character;

                        my Str $code = sprintf(
                            'U+%04X',
                            $character.ord,
                        );

                        my Numeric $label-left =
                            $cell-left + 4;

                        my Numeric $label-y =
                            $cell-top - 48;

                        .font = $label-font, 7;
                        .text-position = [$label-left, $label-y];
                        .say: $code;

                        ++$index;
                        ++$slot;
                    }
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
