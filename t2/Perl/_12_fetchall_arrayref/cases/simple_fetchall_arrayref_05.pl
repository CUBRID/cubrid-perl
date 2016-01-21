#!perl -w

use DBI;
use Test::More;
use Data::Dumper;

use vars qw($db $port $hostname);

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";
$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb (i int,age int,name varchar(10));") or die "create error: $dbh->errstr";
$dbh->do("insert into tdb values(1,25,'aaa'),(1,30,'bbbb'),(3,45,'ccc');") or die "insert: $dbh->err
str";

my $sth=$dbh->prepare("select * from tdb ;");
$sth->execute() or die "execute select: $dbh->errstr\n";
my $all_ref =$sth->fetchall_arrayref({i=>1,age=>2,name=>3}) or die "all_ref error: $dbh->errstr";

plan tests=>9;
foreach my $row(@$all_ref){
   ok($row->{i}, "fetchall_arrayref({i=>1,age=>2,name=>3} ok");
   ok($row->{age}, "fetchall_arrayref({i=>1,age=>2,name=>3} ok");
   ok($row->{name}, "fetchall_arrayref({i=>1,age=>2,name=>3} ok");
}

$dbh -> disconnect();

