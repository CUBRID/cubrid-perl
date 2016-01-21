#!perl -w

#using NULL value
use DBI;
use Test::More;

use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect err: $dbh->errstr";

$dbh -> do("drop table if EXISTS tbl;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tbl(id int, name char(20),age int);") or die "create error: $dbh->errstr";
$dbh -> do("insert into tbl values(1,'zhangsan',30);") or die "insert error:$dbh->errstr";

my $sth=$dbh->prepare("insert into tbl (id,name,age) values (?,?,?)") or die "select error: $dbh->errstr";
$sth->execute(1,'Joe',undef) or die "insert error: $dbh->errstr";

#####################################
ok($sth=$dbh->prepare("select * from tbl order by 2 desc;"),"select prepare");
$sth->execute;
my $arry=$sth->fetchall_arrayref({}) or die "Arry error:$dbh->errstr";

my $i=0;
my @id=(1,1);
my @name=('zhangsan            ','Joe                 ');
my @age=(30,0);
foreach my $row(@$arry){
 is($row->{'id'},$id[$i],"fetchall_arrayref({}) ok");
 is($row->{'name'},$name[$i],"fetchall_arrayref({}) ok");
 is($row->{'age'},$age[$i],"fetchall_arrayref({}) ok");
 $i++;
}
$sth->finish();
done_testing();
$sth->finish();
$dbh -> disconnect();
