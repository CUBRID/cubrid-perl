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
$dbh -> do("drop table if EXISTS coo;") or die "drop error: $dbh->errstr";
$dbh -> do("create table coo(col4 bit(8),col10 float,col11 double,col12 date,col13 time,col14 timestamp,col15 set, col18 blob );") or die "create error: $dbh->errstr";

$dbh->do("insert into coo values(b'0011', 10,11, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, bit_to_blob(B'000010'));") or die "insert error:  $dbh->errstr";


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


$dbh -> disconnect();



