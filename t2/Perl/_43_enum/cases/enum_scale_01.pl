#!perl -w
#Test the scale of enum is ok.
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
$dbh -> do("drop table if EXISTS enums;") or die "drop error: $dbh->errstr";
$dbh -> do("create table enums(e1 enum('a', 'b'), e2 enum('Yes', 'No', 'Cancel'));") or die "create error: $dbh->errstr";

$dbh->do("insert into enums values (1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3);") or die "insert error:  $dbh->errstr";


my $sth=$dbh->prepare("select * from enums") or die "prepare error: $dbh->errstr";
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



