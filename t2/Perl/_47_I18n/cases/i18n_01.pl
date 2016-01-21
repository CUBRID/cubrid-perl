#!perl -w
#Test the chr function is ok when run in many charset.
use DBI;
use Test::More;
#use strict;

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
$dbh -> do("create table tb (id int, name varchar(10),ch char(10) );") or die "create error: $dbh->errstr";
$dbh->do("insert into tb values(1,'a','b')");

print "####################case1########\n";

my $sth=$dbh->prepare("select chr(68);") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";

my $fieldNumber=$sth->{NUM_OF_FIELDS};
print "Number of field is $fieldNumber\n";
ok( $fieldNumber==1, "Field number is 1" );

for (my $i=0;$i<$fieldNumber; $i++){
   print "name: $sth->{NAME}->[$i]\n";
}

print "####################case2############\n";

my $sth1=$dbh->prepare("select chr(68)||chr(68-2);") or die "prepare error: $dbh->errstr";
$sth1->execute() or die "execute error: $dbh->errstr";

$fieldNumber=$sth1->{NUM_OF_FIELDS};
print "Number of field is $fieldNumber\n";
ok( $fieldNumber==1, "Field number is 1" );

for (my $i=0;$i<$fieldNumber; $i++){
   print "name: $sth1->{NAME}->[$i]\n";
}


done_testing();
$sth->finish();
$sth1->finish();
$dbh -> disconnect();



