#!/usr/bin/perl
use strict;
use warnings;

my %vars;

print "Çıkmak için 'exit' yazın.\n";

while (1) {
    print ">> ";
    my $input = <STDIN>;
    chomp($input);

    last if $input eq 'exit';

    if ($input =~ /^print\s+(.*)/) {
        my $expr = $1;
        my $result = evaluate($expr);
        if (defined $result) {
            print "$result\n";
        }
    } elsif ($input =~ /^([a-zA-Z_]\w*)\s*=\s*(.+)$/) {
        my ($var, $expr) = ($1, $2);
        my $val = evaluate($expr);
        if (defined $val) {
            $vars{$var} = $val;
            print "$var = $val\n";
        }
    } else {
        my $result = evaluate($input);
        if (defined $result) {
            print "Result: $result\n";
        }
    }
}

sub evaluate {
    my $expr = shift;

    # Değişkenleri değerlendir
    $expr =~ s/\b([a-zA-Z_]\w*)\b/
        exists $vars{$1} ? $vars{$1} : return print "Hata: Tanımsız değişken '$1'\n"
    /ge;

    # Güvenli eval
    my $result = eval $expr;
    if ($@) {
        print "Hata: İfade çözümlenemedi ($@)\n";
        return undef;
    }
    return $result;
}
