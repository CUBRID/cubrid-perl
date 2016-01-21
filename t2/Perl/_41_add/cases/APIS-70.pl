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
$dbh -> do("create table coo(id int not null primary key auto_increment,col4 bit(8), phone int );") or die "create error: $dbh->errstr";

$dbh->do("insert into coo values(NULL,b'0011', 1234);") or die "insert error:  $dbh->errstr";


my $sth=$dbh->prepare("select * from coo") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";
my $fieldNumber=$sth->{NUM_OF_FIELDS};
print "Number of field is $fieldNumber\n";

for (my $i=0;$i<$fieldNumber; $i++){
   print "name: $sth->{NAME}->[$i]\n";
   print "nullable: $sth->{NULLABLE}->[$i]\n\n\n";
}

$sth->finish();


$dbh -> disconnect();



