#!/usr/bin/env perl
package NetHack::Item::Tool::Candelabrum;
use Moose;
extends 'NetHack::Item::Tool::Light';

use constant subtype => 'candelabrum';

has candles_attached => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

after incorporate_stats => sub {
    my $self  = shift;
    my $stats = shift;

    $self->candles_attached($stats->{candles});
};

__PACKAGE__->meta->make_immutable;
no Moose;

1;

