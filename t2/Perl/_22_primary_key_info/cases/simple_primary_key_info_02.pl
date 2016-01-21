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
my @ta=(undef,undef,"ta","a",1,"pk_ta_a");
my $i=0;
while(my @row =$sth->fetchrow_array()){  
   print "length: " . @row ."\n";
   is($row[$i],$ta[$i++],"primary_key_info ok");
   is($row[$i],$ta[$i++],"primary_key_info ok");
   is($row[$i],$ta[$i++],"primary_key_info ok");
   is($row[$i],$ta[$i++],"primary_key_info ok");
   is($row[$i],$ta[$i++],"primary_key_info ok");
   is($row[$i],$ta[$i++],"primary_key_info ok");
}

print "tb infromation";
my $sth2=$dbh->primary_key_info(undef,undef,'tb') or die "primary_key_info error: $dbh->errstr";
my @tb=(undef,undef,undef,undef,undef,undef);
my $i=0;
my @row =$sth2->fetchrow_array();
   print "length: " . @row ."\n";
   is($row[$i],$tb[$i++],"primary_key_info ok");
   is($row[$i],$tb[$i++],"primary_key_info ok");
   is($row[$i],$tb[$i++],"primary_key_info ok");
   is($row[$i],$tb[$i++],"primary_key_info ok");
   is($row[$i],$tb[$i++],"primary_key_info ok");
   is($row[$i],$tb[$i++],"primary_key_info ok");



$dbh->do("drop table if EXISTS tb;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS ta;") or die "drop error: $dbh->errstr";

done_testing();
$sth->finish();
$sth2->finish();
$dbh->disconnect();


