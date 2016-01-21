#!perl -w
#Test execute for update_1.
use DBI;
use Test::More;
#use strict;
#Test execute update.
use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";

my $dbh;

$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

$dbh->do("drop table if EXISTS enume01;") or die "drop error: $dbh->errstr";
$dbh->do("create table enume01(e1 enum('a', 'b'), e2 enum('Yes', 'No', 'Cancel'));") or die "create error: $dbh->errstr";
$dbh->do("insert into enume01 values (1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3);") or die "insert error:$dbh-errstr";
my $sth;


#############################################
ok($sth=$dbh->prepare("update enume01 set e1=cast(e2 as int) where e2 < 3;"),"Update prepare");
my $exResult1=$sth->execute or die "execute for update error: $dbh->errstr";
$sth->finish();


ok($sth=$dbh->prepare("update enume01 set e2=e1 + 1;"),"Update prepare");
my $exResult1=$sth->execute or die "execute for update error: $dbh->errstr";
$sth->finish();

ok($sth=$dbh->prepare("update enume01 set e1='b', e2='No';"),"Update prepare");
my $exResult1=$sth->execute or die "execute for update error: $dbh->errstr";
$sth->finish();

ok($sth=$dbh->prepare("select * from enume01 order by 1, 2;"),"Update prepare");
$sth->execute;
while(my $arry=$sth->fetchrow_arrayref()){
 is($arry->[0],'b','data right');
 is($arry->[1],'No','data right');
}
$sth->finish();

done_testing();
$dbh -> disconnect();



