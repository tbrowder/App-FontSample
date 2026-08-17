use v6.d;
use App::FontSample::PDF;
use App::FontSample::FontEntry;

use NotoFonts-OT;
use NotoFonts-OT::FontPaths;

# Adjust these calls if the provider's final public API uses different names.
my $provider = NotoFonts-OT::FontPaths; 
my @entries;

for <NotoSerif-Regular NotoSerif-Bold NotoSans-Regular> -> $key {
    # key is a font name, get the font path
    my $font = get-font-path $key;
    @entries.push: App::FontSample::FontEntry.new(
        :name($key),
        #:font($provider.font($key)),
        :$font,
    );
}

my $sampler = App::FontSample::PDF.new;
$sampler.render-collection(
    @entries,
    :output<noto-samples.pdf>,
);
