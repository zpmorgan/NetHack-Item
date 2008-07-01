#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 6;
use NetHack::Item;

my $item = NetHack::Item->new("a long sword");
ok($item, "got an item using new(string)");
is($item->raw, "a long sword");

$item = NetHack::Item->new({raw => "a long sword"});
ok($item, "got an item using new(hashref)");
is($item->raw, "a long sword");

$item = NetHack::Item->new(raw => "a long sword");
ok($item, "got an item using new(hash)");
is($item->raw, "a long sword");

