use Test;

my @modules = <
    App::FontSample
>;

plan @modules.elems;

for @modules -> $m {
    use-ok $m, "Module '$m' used okay";
}
