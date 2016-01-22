#!perl -w

use DBI ();
use DBI qw(:sql_types);
use DBI::Const::GetInfoType;
use Test::More;
use vars qw($table $test_dsn $test_user $test_passwd);
use lib '.', 't';
require 'lib.pl';

my $dbh;

eval {$dbh = DBI->connect($test_dsn, $test_user, $test_passwd,
        { RaiseError => 1, AutoCommit => 1})};

$dbh -> do("drop table if EXISTS tbl;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tbl(id int, name char(20));") or die "create error: $dbh->errstr";
$dbh -> do("insert into tbl values(1,'Johny'),(2,'lisi'),(3,'wangwu'),(4,'mazi');") or die "insert error:$dbh->errstr";

my @names=("Joh%","lis%","wan%");
my $sth=$dbh->prepare("select * from tbl where name LIKE ?;") or die "select error: $dbh->errstr";

$sth->bind_param_array(1,\@names) or die "bind_param_array error: $dbh->errstr";
my $rv=$sth->execute_array( { ArrayTupleStatus => \my @tuple_status } ) or die "execute_array error: $dbh->errstr";
#print "rv values is $rv\n";

plan tests=>1;
ok($rv == 3,"bind_param ok");

$sth->finish();
$dbh -> disconnect();
