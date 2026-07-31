use v6.d;
use App::FontSample::PDF;
use App::FontSample::FontEntry;
use NotoFonts-OT;

# Adjust these calls if the provider's final public API uses different names.
my $provider = NotoFonts-OT.new;
my @entries;

for <NotoSerif-Regular NotoSerif-Bold NotoSans-Regular> -> $key {
    @entries.push: App::FontSample::FontEntry.new(
        :name($key),
        :font($provider.font($key)),
    );
}

my $sampler = App::FontSample::PDF.new;
$sampler.render-collection(
    @entries,
    :output<noto-samples.pdf>,
);
