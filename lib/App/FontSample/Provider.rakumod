use v6.d;
use PDF::Content::FontObj;

unit role App::FontSample::Provider;

method font(Str:D $key --> PDF::Content::FontObj:D) { ... }
method font-keys(--> Positional:D) { ... }
