use Test;

my @modules = <
    App::FontSample
    App::FontSample::PDF
    App::FontSample::Paper
    App::FontSample::FontEntry
    App::FontSample::Layout
    App::FontSample::Layout::Specimen
    App::FontSample::Provider
    App::FontSample::SampleText
>;

plan @modules.elems;

for @modules -> $m {
    use-ok $m, "Module '$m' used okay";
}
