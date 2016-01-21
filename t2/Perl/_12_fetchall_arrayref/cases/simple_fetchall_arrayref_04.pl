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
$dbh -> do("create table tdb (i int,age int);") or die "create error: $dbh->errstr";
$dbh->do("insert into tdb values(1,25),(1,30),(3,45);") or die "insert: $dbh->err
str";

plan tests=>1;
my $sth=$dbh->prepare("select * from tdb where age <25 ;");
$sth->execute() or die "execute select: $dbh->errstr\n";
my $all_ref =$sth->fetchall_arrayref() or die "all_ref error: $dbh->errstr";
ok( !($all_ref->[0]),"fechall_arrayref ok");

$dbh -> disconnect();

