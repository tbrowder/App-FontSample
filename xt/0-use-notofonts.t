use v6.d;
use Test;

use MacOS::NativeLib "*";
use PDF::Font::Loader::HarfBuzz;
use PDF::Font::Loader :load-font;
use PDF::Content;
use PDF::Content::FontObj;
use PDF::Lite;

use NotoFonts-OT;
use NotoFonts-OT::FontPaths;

use App::FontSample::PDF;
use App::FontSample::FontEntry;

# Adjust these calls if the provider's final public API uses different names.
#my $provider = NotoFonts-OT::FontPaths; 
my $provider = NotoFonts-OT;
my @entries;

for <NotoSerif-Regular NotoSerif-Bold NotoSans-Regular> -> $key {

    say "DEBUG: font name: '$key'";
    # key is a font name, get the font path

#   #*=begin comment
    my IO::Path $path = get-font-path $key;
    isa-ok $path, IO::Path, "'$path' is an IO::Path object";
    say "font path: $path";
    say $path.e;

    my $loaded-font = get-loaded-font $key;
    isa-ok $loaded-font, PDF::Content::FontObj;

    my $proc = run "get-font-path", $key, :out, :err;
    say "exit code: {$proc.exitcode}";
    my $out = $proc.out.slurp(:close);
    my $err = $proc.err.slurp(:close);
    say "stdout: $out";
    say "stderr: $err";

    #=begin comment
    @entries.push: App::FontSample::FontEntry.new(
        :name($key),
        :font(get-loaded-font($key)),
        #:$font,
    );
    #=end comment

}

done-testing;

=finish

my $sampler = App::FontSample::PDF.new;
$sampler.render-collection(
    @entries,
    :output<noto-samples.pdf>,
);


