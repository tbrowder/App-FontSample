use v6.d;

unit class App::FontSample::SampleText;

has $.debug;

submethod TWEAK {
    if $!debug {
        note "DEBUG ?: generating SampleText object";
    }
}

my %pangrams =
    en => 'The quick brown fox jumps over the lazy dog.';

my %language-names =
    en => 'English';

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

    %language-names{$language} = $name
        if $name.defined;
}

method languages(--> List:D) {
    return %pangrams.keys.sort.List;
}
