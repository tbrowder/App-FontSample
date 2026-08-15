use v6.d;
use JSON::Fast;
use App::FontSample::SampleText;

unit class App::FontSample::Config;

has IO::Path:D $.source-file is required;
has IO::Path:D $.base-dir is required;
has IO::Path:D $.output is required;
has Str:D $.paper = 'Letter';
has Bool:D $.landscape = False;
has Numeric:D $.margin = 36e0;
has Str:D $.title = 'Font Samples';
has Str:D $.layout = 'specimen';
has Str $.language;
has Str $.text;
has Str $.pangram;
has Str $.characters;
has Numeric $.comparison-size;
has Numeric $.sample-size;
has Numeric $.leading-ratio;
has Int $.columns;
has List:D $.sizes = ();
has List:D $.fonts is required;

method from-file(
    IO() $file
    --> App::FontSample::Config:D
) {
    my IO::Path $path = $file.IO;

    die "JSON configuration file does not exist: $path"
        unless $path.f;

    my $decoded = from-json($path.slurp);

    die 'The JSON configuration root must be an object'
        unless $decoded ~~ Associative;

    return self.from-data(
        $decoded,
        :source-file($path),
        :base-dir($path.parent),
    );
}

method from-data(
    Associative:D $decoded,
    IO::Path:D :$source-file!,
    IO::Path:D :$base-dir!,
    --> App::FontSample::Config:D
) {
    my %data = $decoded.Hash;

    die 'The JSON configuration requires a non-empty output value'
        unless %data<output>:exists
            and %data<output> ~~ Str
            and %data<output>.chars;

    die 'The JSON configuration requires a non-empty fonts array'
        unless %data<fonts>:exists
            and %data<fonts> ~~ Positional
            and %data<fonts>.elems;

    my Str $paper = %data<paper> // 'Letter';

    die "Unsupported paper size '$paper'; use Letter or A4"
        unless $paper eq 'Letter'
            or $paper eq 'A4';

    my Str $layout = (%data<layout> // 'specimen').Str.lc;

    die "Unsupported layout '$layout'"
        unless $layout eq 'specimen'
            or $layout eq 'waterfall'
            or $layout eq 'comparison'
            or $layout eq 'characters'
            or $layout eq 'collection';

    my Numeric $margin = (%data<margin> // 36).Numeric;

    die 'The margin must be zero or greater'
        unless $margin >= 0;

    my @sizes;

    if %data<sizes>:exists {
        die 'The sizes value must be an array'
            unless %data<sizes> ~~ Positional;

        for %data<sizes>.List -> $size {
            my Numeric $number = $size.Numeric;

            die 'Every size must be greater than zero'
                unless $number > 0;

            @sizes.push: $number;
        }
    }

    my @fonts;

    for %data<fonts>.List.kv -> $index, $font-data {
        die "Font entry {$index + 1} must be an object"
            unless $font-data ~~ Associative;

        my %font = $font-data.Hash;

        die "Font entry {$index + 1} requires a non-empty file value"
            unless %font<file>:exists
                and %font<file> ~~ Str
                and %font<file>.chars;

        my IO::Path $font-file =
            resolve-path(%font<file>, $base-dir);

        my %entry = file => $font-file;

        for <name family style source> -> $key {
            %entry{$key} = %font{$key}
                if %font{$key}:exists;
        }

        @fonts.push: %entry;
    }

    my %new =
        source-file => $source-file,
        base-dir    => $base-dir,
        output      => resolve-path(%data<output>, $base-dir),
        paper       => $paper,
        landscape   => so (%data<landscape> // False),
        margin      => $margin,
        title       => (%data<title> // 'Font Samples'),
        layout      => $layout,
        sizes       => @sizes.List,
        fonts       => @fonts.List;

    for <language text pangram characters> -> $key {
        %new{$key} = %data{$key}
            if %data{$key}:exists;
    }

    if %data<comparison-size>:exists {
        my Numeric $size = %data<comparison-size>.Numeric;

        die 'comparison-size must be greater than zero'
            unless $size > 0;

        %new<comparison-size> = $size;
    }

    if %data<sample-size>:exists {
        my Numeric $size = %data<sample-size>.Numeric;

        die 'sample-size must be greater than zero'
            unless $size > 0;

        %new<sample-size> = $size;
    }

    if %data<leading-ratio>:exists {
        my Numeric $ratio = %data<leading-ratio>.Numeric;

        die 'leading-ratio must be zero or greater'
            unless $ratio >= 0;

        %new<leading-ratio> = $ratio;
    }

    if %data<columns>:exists {
        my Int $columns = %data<columns>.Int;

        die 'columns must be greater than zero'
            unless $columns > 0;

        %new<columns> = $columns;
    }

    if %new<language>:exists
        and !%new<pangram>:exists {
        %new<pangram> =
            App::FontSample::SampleText.new.pangram(
                %new<language>
            );
    }

    return self.new(|%new);
}

sub resolve-path(
    Str:D $value,
    IO::Path:D $base-dir,
    --> IO::Path:D
) {
    my IO::Path $path = $value.IO;

    return $path.is-absolute
        ?? $path
        !! $base-dir.add($path);
}
