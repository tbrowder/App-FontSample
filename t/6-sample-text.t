use Test;

use App::FontSample::SampleText;

my %alphabets = (
    nl => 'abcdefghijklmnopqrstuvwxyz',
    en => 'abcdefghijklmnopqrstuvwxyz',
    fr => 'abcdefghijklmnopqrstuvwxyz',
    de => 'abcdefghijklmnopqrstuvwxyzäöüß',
    id => 'abcdefghijklmnopqrstuvwxyz',
    it => 'abcdefghijklmnopqrstuvwxyz',
    nb => 'abcdefghijklmnopqrstuvwxyzæøå',
    nn => 'abcdefghijklmnopqrstuvwxyzæøå',
    pl => 'aąbcćdeęfghijklłmnńoóprsśtuwyzźż',
    ro => 'aăâbcdefghiîjklmnopqrsștțuvwxyz',
    ru => 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя',
    es => 'abcdefghijklmnñopqrstuvwxyz',
    uk => 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюя',
);

my $samples = App::FontSample::SampleText.new;

for %alphabets.keys.sort -> $code {
    my Str $text = $samples.pangram($code).lc;
    my @missing;

    for %alphabets{$code}.comb -> $letter {
        unless $text.contains($letter) {
            @missing.push: $letter;
        }
    }

    is @missing.elems, 0,
        "pangram '$code' contains every required alphabet character";

    if @missing.elems {
        diag "Missing from '$code': {@missing.join(', ')}";
    }
}

is $samples.languages.elems, 13,
    'there are 13 built-in language samples';

done-testing;
