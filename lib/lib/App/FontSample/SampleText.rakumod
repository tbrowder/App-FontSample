use v6.d;

unit class App::FontSample::SampleText;

my %pangram =
    en => 'The quick brown fox jumps over the lazy dog.';

method pangram(Str:D $language --> Str:D) {
    die "No pangram is registered for language '$language'"
        unless %pangram{$language}:exists;

    return %pangram{$language};
}

method register-pangram(
    Str:D $language,
    Str:D $text,
    --> Nil
) {
    %pangram{$language} = $text;
}

method languages(--> List:D) {
    return %pangram.keys.sort.List;
}
