#!/usr/bin/perl

use v5.10;

use warnings;
use strict;

my $r = 25, my $c = 30;

my @poleGry, my @temp;

sub stworzPoleGry {
	for (my $row = 0; $row < $r; $row++) {
		for (my $col = 0; $col < $c; $col++) {
			$poleGry[$row][$col] = ".";
			$temp[$row][$col] = ".";
		}
	}
}

sub pokazPoleGry {
	for (my $row = 0; $row < $r; $row++) {
		for (my $col = 0; $col < $c; $col++) {
			print "$poleGry[$row][$col] ";
		}
		print "\n";
	}
}

sub zamienPoleGry {
	for (my $row = 0; $row < $r; $row++) {
		for (my $col = 0; $col < $c; $col++) {
			$poleGry[$row][$col] = $temp[$row][$col];
		}
	}
}

sub sprawdzKomorke {
	my $suma = 0;
	my ($row, $col) = @_;
	for (my $i = -1; $i <= 1; $i++) {
		for (my $j = -1; $j <= 1; $j++) {
			if ($i != 0 || $j != 0) {
				if ($poleGry[$row+$i][$col+$j] eq "*") {
					$suma += 1;
				}
			}
		}
	}
	if ($poleGry[$row][$col] eq "*") {
		if ($suma < 2 || $suma > 3) {
			$temp[$row][$col] = ".";
		}
	} else {
		if ($suma == 3) {
			$temp[$row][$col] = "*";
		}
	}
}

sub menu {
	my $t = 1;
	do {
		print "(d)odaj/(u)sun komorke | (w)czytaj przyklad z pliku | (s)tart\n";
		my $char = <STDIN>;
		chomp($char);
		given($char) {
			when ("d") {
				print "podaj wspolrzedne komorki:\n";
				print "x = <2, ".($r-1).">\n";
				my $x = <STDIN>;
				chomp($x);
				print "y = <2, ".($c-1).">\n";
				my $y = <STDIN>;
				chomp($y);
				$poleGry[$y-1][$x-1] = "*";
				$temp[$y-1][$x-1] = "*";
				print "\033[2J";
				&pokazPoleGry();
			}
			when ("u") {
				print "podaj wspolrzedne komorki:\n";
				print "x = <2, ".($r-1).">\n";
				my $x = <STDIN>;
				chomp($x);
				print "y = <2, ".($c-1).">\n";
				my $y = <STDIN>;
				chomp($y);
				$poleGry[$y-1][$x-1] = ".";
				$temp[$y-1][$x-1] = ".";
				print "\033[2J";
				&pokazPoleGry();
			}
			when ("w") {
				print "(d)akota | (g)lider | (p)entadecathlon | pulsa(r) \n";
				my $digit = <STDIN>;
				chomp($digit);
				my $file;
				given($digit) {
					when ("d") {
						$file = "dakota.txt";
					}
					when ("g") {
						$file = "glider.txt";
					}
					when ("p") {
						$file = "pentadecathlon.txt";
					}
					when ("r") {
						$file = "pulsar.txt";
					}
				}
				open(DATA, $file) || die "nie mozna otworzyc pliku\n";
				while (my $lineX = <DATA>) {
					chomp($lineX);
					my $lineY = <DATA>;
					chomp($lineY);
					$poleGry[$lineY][$lineX] = "*";
					$temp[$lineY][$lineX] = "*";
				}
				close DATA;
				print "\033[2J";
				&pokazPoleGry();
			}
			when ("s") {
				$t = 0;
			}
			default {
				print "zly wybor, podaj litere jeszcze raz:\n";
			}
		}
	} while ($t != 0);
}

sub graj {
	my $gen = 0;
	do {
		for (my $row = 1; $row < $r-1; $row++) {
			for (my $col = 1; $col < $c-1; $col++) {
				&sprawdzKomorke($row, $col);
			}
		}
		&zamienPoleGry();
		print "\033[2J";
		&pokazPoleGry();
		$gen += 1;
		print "pokolenie: $gen\n";
		sleep 1;
	} while (1);
}

print "\033[2J";
&stworzPoleGry();
&pokazPoleGry();
&menu();
&graj();