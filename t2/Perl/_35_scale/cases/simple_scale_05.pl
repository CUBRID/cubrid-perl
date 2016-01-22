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

#cubrid 8.4.4 do not support enum type
=pod
$dbh -> do("drop table if EXISTS coo;") or die "drop error: $dbh->errstr";
$dbh -> do("create table coo(num1 numeric(3,3),set1 set(int,float),set2 set(int),enum1 enum('red','yellow','green'),i int,seta set,setm multiset,seq sequence);");# or die "create error: $dbh->errstr";
print $dbh->errstr;
$dbh->do("insert into coo values(0.999,{3},{3},'red',3,{3,23},{3,3},{1,2});") or die "insert error:  $dbh->errstr";


my $sth=$dbh->prepare("select * from coo") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";
my $fieldNumber=$sth->{NUM_OF_FIELDS};
print "Number of field is $fieldNumber\n";

for (my $i=0;$i<$fieldNumber; $i++){
   print "name: $sth->{NAME}->[$i]\n";
   print "type: $sth->{TYPE}->[$i]\n";
   print "precision: $sth->{PRECISION}->[$i]\n";
   print "scale: $sth->{SCALE}->[$i]\n\n\n";
}

$sth->finish();
=cut

$dbh -> disconnect();

