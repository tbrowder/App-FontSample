use v6.d;
use JSON::Fast;
use App::FontSample::Config;

unit class App::FontSample::ConfigFile;

has IO::Path:D $.source-file is required;
has IO::Path:D $.base-dir is required;
has List:D $.samples is required;

method from-file(
    IO() $file
    --> App::FontSample::ConfigFile:D
) {
    my IO::Path $path = $file.IO;

    die "JSON configuration file does not exist: $path"
        unless $path.f;

    my $decoded = from-json($path.slurp);

    die 'The JSON configuration root must be an object'
        unless $decoded ~~ Associative;

    my %root = $decoded.Hash;
    my IO::Path $base-dir = $path.parent;
    my @samples;

    if %root<samples>:exists {
        die 'The samples value must be a non-empty array'
            unless %root<samples> ~~ Positional
                and %root<samples>.elems;

        my %defaults;

        if %root<defaults>:exists {
            die 'The defaults value must be an object'
                unless %root<defaults> ~~ Associative;

            %defaults = %root<defaults>.Hash;
        }

        for %root<samples>.List.kv -> $index, $sample-data {
            die "Sample entry {$index + 1} must be an object"
                unless $sample-data ~~ Associative;

            my %sample = %sample-data.Hash;
            my %merged;

            for %defaults.kv -> $key, $value {
                %merged{$key} = $value;
            }

            for %sample.kv -> $key, $value {
                %merged{$key} = $value;
            }

            @samples.push:
                App::FontSample::Config.from-data(
                    %merged,
                    :source-file($path),
                    :$base-dir,
                );
        }
    }
    else {
        @samples.push:
            App::FontSample::Config.from-data(
                %root,
                :source-file($path),
                :$base-dir,
            );
    }

    return self.new(
        :source-file($path),
        :$base-dir,
        :samples(@samples.List),
    );
}
