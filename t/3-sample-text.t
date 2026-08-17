use v6.d;
use Test;

use App::FontSample::SampleText;

is App::FontSample::SampleText.pangram('en'),
    'The quick brown fox jumps over the lazy dog.',
    'English pangram is available';

App::FontSample::SampleText.register-pangram(
    'xx',
    'A test language sample.',
);

is App::FontSample::SampleText.pangram('xx'),
    'A test language sample.',
    'pangrams can be registered';

ok 'en' (elem) App::FontSample::SampleText.languages,
    'language list contains English';

throws-like {
    App::FontSample::SampleText.pangram('missing');
}, X::AdHoc, 'missing language is rejected';

done-testing;
