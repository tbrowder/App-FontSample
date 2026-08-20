use v6.d;

unit class App::FontSample::Paper;

my constant %PAPER = %(
    Letter => [612, 792],
    A4     => [595, 842],
);

has Str:D     $.paper     = 'Letter';
has Bool:D    $.landscape = False;
has Numeric:D $.margin    = 36;
has $.debug;

submethod TWEAK {
    if $!debug {
        note "DEBUG ?: generating a Paper object";
    }
}

method width(--> Int:D) {
    return $!landscape
        ?? %PAPER{$!paper}[1]
        !! %PAPER{$!paper}[0];
}

method height(--> Int:D) {
    return $!landscape
        ?? %PAPER{$!paper}[0]
        !! %PAPER{$!paper}[1];
}

method usable-width(--> Numeric:D) {
    return self.width - 2 * $!margin;
}

method usable-height(--> Numeric:D) {
    return self.height - 2 * $!margin;
}

method media-box(--> List:D) {
    return (0, 0, self.width, self.height);
}
