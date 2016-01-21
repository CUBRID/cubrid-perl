#!perl -w

use DBI;
use Test::More;
use strict;

use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

$dbh->do("drop table if EXISTS ta;") or die "drop error: $dbh->errstr";
$dbh->do("create table ta(a int primary key, b int);") or die "create error: $dbh->errstr";
$dbh->do("insert into ta(a, b) values(1, 1),(2,2);") or die "inser error: $dbh->errstr";

$dbh->do("drop table if EXISTS tb;") or die "drop error: $dbh->errstr";
$dbh->do("create table tb(a int, b int);") or die "create error: $dbh->errstr";
$dbh->do("insert into tb(a, b) values(1, 2);") or die "inser error: $dbh->errstr";
$dbh->do("create index ix_tb_a on tb(a);") or die "create error: $dbh->errstr";

$dbh->do("alter table tb add constraint fk_tb_a foreign key (a) references ta;") or die "alter error: $dbh->errstr";
$dbh->do("update tb set a=2 where b =2;") or die "update error: $dbh->errstr";

my $sth=$dbh->primary_key_info(undef,undef,'ta') or die "primary_key_info error: $dbh->errstr";

my $all_ref =$sth->fetchall_arrayref() or die "all_ref error: $dbh->errstr";
my($i,$j);
for $i(0 .. $#{$all_ref}){
   for $j(0 .. $#{$all_ref->[$i]}){
      print "Values: $all_ref->[$i][$j] \n";
      $j++ ;
      print "\n\n";
   }
   print "value of i is $i \n\n";
   $i++;
}


my $sth2=$dbh->primary_key_info(undef,undef,'tb') or die "primary_key_info error: $dbh->errstr";

my $all_ref2 =$sth2->fetchall_arrayref() or die "all_ref error: $dbh->errstr";
my($i,$j);
for $i(0 .. $#{$all_ref2}){
   for $j(0 .. $#{$all_ref2->[$i]}){
      print "Values: $all_ref2->[$i][$j] \n";
      $j++ ;
      print " \n\n";
   }
   print "value of i is $i \n\n";
   $i++;
}


$dbh->do("drop table if EXISTS tb;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS ta;") or die "drop error: $dbh->errstr";


$sth->finish();
$sth2->finish();
$dbh->disconnect();


