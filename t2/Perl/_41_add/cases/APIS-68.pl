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
$dbh -> do("drop table if EXISTS tb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tb (id int, bgi bigint, name varchar(1),dc numeric(5,4),ft float(5) );") or die "create error: $dbh->errstr";
$dbh->do("insert into tb values(1,89.8,'a',0.12345678,12345678.9)");

my $sth=$dbh->prepare("select * from tb") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";
my $fieldNumber=$sth->{NUM_OF_FIELDS};
print "Number of field is $fieldNumber\n";

for (my $i=0;$i<$fieldNumber; $i++){
   print "name: $sth->{NAME}->[$i]\n";
   print "type: $sth->{TYPE}->[$i]\n";
   print "precision: $sth->{PRECISION}->[$i]\n\n\n";
}

$sth->finish();
$dbh -> disconnect();



