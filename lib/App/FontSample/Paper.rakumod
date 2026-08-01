use v6.d;

unit class App::FontSample::Paper;

my constant %PAPER-SIZES =
    Letter => [612e0, 792e0],
    A4     => [595.275590551e0, 841.88976378e0];

has Str:D     $.name = 'Letter';
has Bool:D    $.landscape = False;
has Numeric:D $.margin = 36e0;

submethod TWEAK() {
    die "Unsupported paper size '$!name'; use Letter or A4"
        unless %PAPER-SIZES{$!name}:exists;

    die 'The page margin must be zero or greater'
        if $!margin < 0;

    die 'The page margin is too large for the selected paper'
        if 2 * $!margin >= self.width
        or 2 * $!margin >= self.height;
}

method width(--> Numeric:D) {
    my ($width, $height) = %PAPER-SIZES{$!name}.List;
    return $!landscape ?? $height !! $width;
}

method height(--> Numeric:D) {
    my ($width, $height) = %PAPER-SIZES{$!name}.List;
    return $!landscape ?? $width !! $height;
}

method media-box(--> List:D) {
    return (0e0, 0e0, self.width, self.height);
}

method usable-width(--> Numeric:D) {
    return self.width - 2 * $!margin;
}

method usable-height(--> Numeric:D) {
    return self.height - 2 * $!margin;
}
