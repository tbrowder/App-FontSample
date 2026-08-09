use v6.d;

unit class App::FontSample::Paper;

my constant %PAPER = %(
   Letter => [612, 792],
   A4     => [595, 842],
);

has Str:D  $.paper     = 'Letter';
has Bool:D $.landscape = False;
has Int:D  $.margin    = 36;

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

method usable-width(--> Int:D) {
    return self.width - 2 * $!margin;
}

method usable-height(--> Int:D) {
    return self.height - 2 * $!margin;
}

method media-box(--> List:D) {
    return (0, 0, self.width, self.height);
}
