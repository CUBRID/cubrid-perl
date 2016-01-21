#!perl -w
#Test execute for update_2;
use DBI;
use Test::More;
#use strict;
#Test execute update_2
use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";

my $dbh;

$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

$dbh->do("drop table if EXISTS enume02;") or die "drop error: $dbh->errstr";
$dbh->do("create table enume02(id int, e2 enum('Yes', 'No', 'Cancel'));") or die "create error: $dbh->errstr";
$dbh->do("insert into enume02 values (1, 2),(2, 3);") or die "insert error:$dbh-errstr";
my $sth;


#############################################
ok($sth=$dbh->prepare("update enume02 set e2=id;"),"Update prepare");
my $exResult1=$sth->execute or die "execute for update error: $dbh->errstr";
$sth->finish();

ok($sth=$dbh->prepare("update enume02 set e2=id + 2;"),"Update prepare");
$exResult1=$sth->execute;
is($DBI::err,-20001,"Error code is right");
$sth->finish();

####################################
$dbh->{PrintError}=1;
$dbh->{RaiseError}=0;

ok($sth=$dbh->prepare("update enume02 set e2=id + 2;"),"Update prepare");
$sth->execute;
like($DBI::errstr,qr/Cannot coerce value of domain/,"Error message is ok");

$sth->finish();

#####################################
ok($sth=$dbh->prepare("update enume02 set id=cast(e2 as int)+40;"),"Update prepare");
$sth->execute or die "execute for update error: $dbh->errstr";
$sth->finish();

#####################################
ok($sth=$dbh->prepare("select * from enume02 order by 1, 2;"),"Update prepare");
$sth->execute;
my $arry=$sth->fetchall_arrayref({}) or die "Arry error:$dbh->errstr";

my $i=0;
my @id=(41,42);
my @name=('Yes','No');
foreach my $row(@$arry){
 is($row->{'id'},$id[$i],"fetchall_arrayref({}) ok");
 is($row->{'e2'},$name[$i],"fetchall_arrayref({}) ok");
 $i++;
}
$sth->finish();

done_testing();
$dbh -> disconnect();



