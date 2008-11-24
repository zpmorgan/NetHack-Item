#!/usr/bin/env perl
package NetHack::ItemPool;
use Moose;
use NetHack::Item;

use NetHack::Inventory;

use constant inventory_class => 'NetHack::Inventory';
use constant trackers_class  => 'NetHack::ItemPool::Trackers';

has artifacts => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} },
);

has inventory => (
    is      => 'ro',
    isa     => 'NetHack::Inventory',
    lazy    => 1,
    default => sub { shift->inventory_class->new },
);

has trackers => (
    is      => 'ro',
    isa     => 'NetHack::ItemPool::Trackers',
    lazy    => 1,
    default => sub { shift->trackers_class->new },
);

sub new_item {
    my $self = shift;

    unshift @_, 'raw' if @_ == 1;
    my $item = NetHack::Item->new(@_, pool => $self);

    if ($item->is_artifact) {
        if (my $existing_arti = $self->get_artifact($item->artifact)) {
            $existing_arti->incorporate_stats_from($item);
            $item = $existing_arti;
        }
        else {
            $self->_incorporate_artifact($item);
        }
    }

    if (defined($item->slot)) {
        $self->inventory->update($item);
    }

    return $item;
}

sub get_artifact {
    my $self = shift;
    my $name = shift;

    return $self->artifacts->{$name};
}

sub _incorporate_artifact {
    my $self = shift;
    my $item = shift;

    $self->artifacts->{ $item->artifact } = $item;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__

=head1 NAME

NetHack::ItemPool - represents a universe of NetHack items

=head1 SYNOPSIS

    use NetHack::ItemPool;
    my $pool = NetHack::ItemPool->new;
    my $excalibur = $pool->new_item("the +3 Excalibur (weapon in hand)");
    is($pool->inventory->weapon, $excalibur);

=head1 DESCRIPTION

Objects of this class represent a universe of NetHack items. For example, each
instance of this class gets exactly one Magicbane, because each NetHack game
gets exactly one Magicbane.

An ItemPool also manages inventory (L<NetHack::Inventory>) and
equipment (L<NetHack::Inventory::Equipment>) for you.

More documentation to come. For now, the best resource is this module's test
suite.

=cut
