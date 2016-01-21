#!perl -w

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
$dbh -> do("drop table if EXISTS test_cn;") or die "drop error: $dbh->errstr";
$dbh -> do("CREATE TABLE test_cn ( sh1 short, i1 int, b1 bigint, n1 numeric, f1 float, d1 double, m1 monetary);") or die "create error: $dbh->errstr";
$dbh->do("insert into test_cn values (193, 193,193,193,193,193,193);");

print "####################case1########";

my $sth=$dbh->prepare("select chr(sh1), chr(i1), chr (b1), chr(n1) , chr (f1), chr (d1), chr (m1) from test_cn;") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";

my $fieldNumber=$sth->{NUM_OF_FIELDS};
print "Number of field is $fieldNumber\n";

for (my $i=0;$i<$fieldNumber; $i++){
   print "name: $sth->{NAME}->[$i]\n";
}
my $arry=$sth->fetchall_arrayref({}) or die "Arry error:$dbh->errstr";

my @m1=(193);
my $i=0;
foreach my $row(@$arry){
 is($row->{'m1'},$m1[$i],"fetchall_arrayref ok");
}
#$dbh -> do("drop table if EXISTS test_cn;") or die "drop error: $dbh->errstr";

done_testing();
$sth->finish();
$sth1->finish();
$dbh -> disconnect();



