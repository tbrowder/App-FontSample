#!/usr/bin/bash

raku -Ilib examples/current-capabilities.raku
#font-samples.json
raku -Ilib examples/noto-characters.raku
raku -Ilib examples/noto-collection.raku
raku -Ilib examples/noto-comparison.raku
raku -Ilib examples/noto-provider.raku
raku -Ilib examples/noto-specimen.raku


exit;
#raku -Ilib examples/font-samples.json

#raku -Ilib examples/noto-collection.raku
#examples/noto-collection.raku

raku -Ilib examples/noto-provider.raku
exit

raku -Ilib examples/noto-specimen.raku

raku -Ilib examples/noto-waterfall.raku
