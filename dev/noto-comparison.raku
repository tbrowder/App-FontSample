use v6.d;
use NotoFonts-OT;
use App::FontSample;
use App::FontSample::FontEntry;

my @entries;

for <
    NotoSerif-Regular
    NotoSerif-Bold
    NotoSerif-Italic
    NotoSerif-BoldItalic
    NotoSans-Regular
    NotoSans-Bold
    NotoSans-Italic
    NotoSans-BoldItalic
    NotoSansMono-Regular
    NotoSansMono-Bold
> -> $code {
    my $font = get-loaded-font($code);

    @entries.push: App::FontSample::FontEntry.new(
        :name($code),
        :$font,
    );
}

create-font-collection-sample(
    @entries,
    :layout<comparison>,
    :comparison-size(18),
    :output<noto-comparison.pdf>,
);
