use strict;
use warnings;
use utf8;
use Carp;
use FindBin qw/$Bin/;
use JSON;
use IPC::Open3 qw/open3/;

our $TESTSETS = "$Bin/testsets.json";
our $COMMAND = 'gradle -q run -Pargs="net.isucon.isucon5q.bench.scenario.Isucon5Qualification 127.0.0.1"';

main();

sub main {
  my $data = slurp($TESTSETS);
  my $json_all = parse_testsets($data);
  foreach my $set (@$json_all){
    do_bench($set); 
  }
  system('mysql -u root -e "SET GLOBAL innodb_buffer_pool_dump_now = 1;"');
}

sub do_bench {
  my $data = shift;
  my $json = JSON->new->utf8->encode($data);
  chdir($Bin);
  warn $COMMAND;
  my $pid = open3(my $in, my $out, 0, $COMMAND) or die $!;
  while (my $line = <$out>) {
    chomp $line;
    last if $line eq 'reading stdin';
  }
  print {$in} $json;
  close $in;
  while(<$out>){
    print;
  }
}

sub parse_testsets {
  my $json_text = shift;
  my $json = JSON->new->utf8->decode($json_text);
  return $json;
}

sub slurp {
  my $file = shift;
  open my $fh, '<', $file or croak "$!";
  my $data = do { local $/; <$fh> };
  close $fh;
  return $data;
}
