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
$dbh -> do("drop table if EXISTS test_tbl;") or die "drop error: $dbh->errstr";
$dbh -> do("create table test_tbl(age int, name varchar(20));") or die "create error: $dbh->errstr";
$dbh->do("insert into test_tbl values (89.8,'aaaa'),(7823467,'bbbb'),(8934,'cccc');") or die "insert: $dbh->err
str";

my $sth=$dbh->prepare("select * from test_tbl ;");
$sth->execute() or die "execute select: $dbh->errstr\n";
my $all_ref =$sth->fetchall_arrayref({}) or die "all_ref error: $dbh->errstr";

my $i=0;
my @id=(90,7823467,8934);
my @name=('aaaa','bbbb','cccc');
foreach my $row(@$all_ref){      
   is($row->{'age'},$id[$i],"fetchall_arrayref({}) ok");
   is($row->{'name'},$name[$i],"fetchall_arrayref({}) ok");
   $i++;
}
done_testing();

$sth->finish();
$dbh -> disconnect();

