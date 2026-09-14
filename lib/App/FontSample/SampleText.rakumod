use v6.d;

unit class App::FontSample::SampleText;

has $.debug;

submethod TWEAK {
    if $!debug {
        note "DEBUG: generating SampleText object";
    }
}

my %pangrams =
    nl => q[Pa's wijze lynx bezag vroom het fikse aquaduct te IJburg.],
    en => 'The quick brown fox jumps over the lazy dog.',
    fr => 'Portez ce vieux whisky au juge blond qui fume.',
    de => 'Zwölf Boxkämpfer jagen Viktor quer über den großen Sylter Deich.',
    id => 'Muharjo seorang xenofobia universal yang takut pada warga jazirah, contohnya Qatar.',
    it => 'Quel vituperabile xenofobo zelante assaggia il whisky ed esclama: alleluja!',
    nb => 'Vår sære Zulu fra badeøya spilte jo whist og quickstep i min taxi.',
    nn => 'Quisling var ein kløppar til å spela jazz på xylofon, men lærte seg aldri å spela cembalo før han drog til Washington.',
    pl => 'Pchnąć w tę łódź jeża lub ośm skrzyń fig.',
    ro => 'Muzicologă în bej, vând whisky și tequila, preț fix.',
    ru => 'Съешь же ещё этих мягких французских булок, да выпей чаю.',
    es => 'El veloz murciélago hindú comía feliz cardillo y kiwi. La cigüeña tocaba el saxofón detrás del palenque de paja.',
    uk => 'Жебракують філософи при ґанку церкви в Гадячі, ще й шатро їхнє п’яне знаємо.';

my %language-names =
    nl => 'Dutch',
    en => 'English',
    fr => 'French',
    de => 'German',
    id => 'Indonesian',
    it => 'Italian',
    nb => 'Norwegian (Bokmål)',
    nn => 'Norwegian (Nynorsk)',
    pl => 'Polish',
    ro => 'Romanian',
    ru => 'Russian',
    es => 'Spanish',
    uk => 'Ukrainian';

method pangram(Str:D $language --> Str:D) {
    die "No pangram is registered for language '$language'"
        unless %pangrams{$language}:exists;

    return %pangrams{$language};
}

method language-name(Str:D $language --> Str:D) {
    die "No language name is registered for language '$language'"
        unless %language-names{$language}:exists;

    return %language-names{$language};
}

method pangram-label(Str:D $language --> Str:D) {
    my Str $name = self.language-name($language);

    return "$name ($language) pangram";
}

method register-pangram(
    Str:D $language,
    Str:D $text,
    Str:D :$name!,
    --> Nil
) {
    %pangrams{$language} = $text;

    %language-names{$language} = $name;
}

method languages(--> List:D) {
    my @list;
    my @pkeys = %language-names.keys.sort;
    for @pkeys -> $pkey {
        my $lang = %language-names{$pkey};
        #say "$pkey - $lang";
        @list.push: "\n$pkey - $lang";
    }
    @list;
}
