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
$dbh -> do("create table coo(id int not null primary key auto_increment,col4 bit(8),col10 float,col11 double,col12 date,col13 time,col14 timestamp);") or die "create error: $dbh->errstr";

$dbh->do("insert into coo values(NULL,b'0011', 10,11, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm');") or die "insert error:  $dbh->errstr";

my @value=("id",0,"col4",1,"col10",1,"col11",1,"col12",1,"col13",1,"col14",1);
my $j=0;
my $sth=$dbh->prepare("select * from coo") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";
my $fieldNumber=$sth->{NUM_OF_FIELDS};
print "Number of field is $fieldNumber\n";

for (my $i=0;$i<$fieldNumber; $i++){
   is($sth->{NAME}->[$i],$value[$j++],"NAME ok");
   is($sth->{NULLABLE}->[$i],$value[$j++],"NULLABLE ok");
}
done_testing();

$sth->finish();


$dbh -> disconnect();



