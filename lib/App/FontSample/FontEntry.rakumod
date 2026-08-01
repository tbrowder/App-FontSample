use v6.d;
use PDF::Content::FontObj;

unit class App::FontSample::FontEntry;

has Str:D                   $.name is required;
has PDF::Content::FontObj:D $.font is required;
has Str:D                   $.family = '';
has Str:D                   $.style = 'Regular';
has Str:D                   $.source = '';

method display-name(--> Str:D) {
    my @parts;

    @parts.push: $!family if $!family.chars;
    @parts.push: $!style if $!style.chars;

    return @parts.elems ?? @parts.join(' ') !! $!name;
}
