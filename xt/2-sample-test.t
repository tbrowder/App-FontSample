use v6.d;
use Test;

use App::FontSample::SampleText;

is App::FontSample::SampleText.pangram('en'),
    'The quick brown fox jumps over the lazy dog.',
    'English pangram is available';

is App::FontSample::SampleText.language-name('en'),
    'English',
    'English language name is available';

is App::FontSample::SampleText.pangram-label('en'),
    'English (en) pangram',
    'pangram label includes language name and code';

App::FontSample::SampleText.register-pangram(
    'xx',
    'A test language sample.',
    :name<Test>,
);

is App::FontSample::SampleText.pangram('xx'),
    'A test language sample.',
    'pangrams can be registered';

is App::FontSample::SampleText.pangram-label('xx'),
    'Test (xx) pangram',
    'registered language name is used in pangram label';

ok 'en' (elem) App::FontSample::SampleText.languages,
    'language list contains English';

throws-like {
    App::FontSample::SampleText.pangram('missing');
}, X::AdHoc, 'missing language is rejected';

done-testing;
