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
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect err: $dbh->errstr";

$dbh -> do("drop table if EXISTS tbl;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tbl(id int, name varchar(20));") or die "create error: $dbh->errstr";
$dbh -> do("insert into tbl values(1,'Johny'),(2,'lisi'),(3,'wangwu'),(4,'mazi');") or die "insert error:$dbh->errstr";

#plan tests=>2;
my $li='John%';
my $sth=$dbh->prepare("select * from tbl where name LIKE ?;") or die "select error: $dbh->errstr";
ok($sth->bind_param_inout(1,\$li,10),"bind_param ok");
ok($sth->execute(),"execute ok");
my @row =$sth->fetchrow_array();
my ($id,$name)=@row;
is($id,1,"bind_param ok");
is($name,'Johny',"bind_param ok");
done_testing();

$sth->finish();
$dbh -> disconnect();
