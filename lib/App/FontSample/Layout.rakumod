use v6.d;

unit role App::FontSample::Layout;

method render-page(
    :$pdf!,
    :$page!,
    :$entry!,
    :$paper!,
    :$label-font!,
    :%options!,
    --> Nil
) {
    die "{self.^name} does not implement render-page";
}

method render-collection(
    :$pdf!,
    :$entries!,
    :$paper!,
    :$label-font!,
    :%options!,
    --> Nil
) {
    for $entries.List -> $entry {
        my $page = $pdf.add-page;
        $page.media-box = $paper.media-box;

        self.render-page(
            :$pdf,
            :$page,
            :$entry,
            :$paper,
            :$label-font,
            :%options,
        );
    }

    return;
}
