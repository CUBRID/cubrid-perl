#!perl -w

use strict;
use Test::More;
use DBI;
use lib 't', '.';
require 'lib.pl';
use vars qw($table $test_dsn $test_user $test_passwd);

$|= 1;

my $dbh;
eval {$dbh= DBI->connect($test_dsn, $test_user, $test_passwd,
                      { RaiseError => 1, PrintError => 1, AutoCommit => 0 });};

$dbh -> do("drop table if EXISTS tbl;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tbl(id int, name varchar(20));") or die "create error: $dbh->errstr";
$dbh -> do("insert into tbl values(1,'Johny'),(2,'lisi'),(3,'wangwu'),(4,'mazi');") or die "insert error:$dbh->errstr";

#plan tests=>2;
my $bar;
my $sth=$dbh->prepare("select * from tbl where name LIKE ?;") or die "select error: $dbh->errstr";
ok($sth->bind_param_inout(1,\$bar,50),"bind_param ok");
done_testing();

$sth->finish();
$dbh -> disconnect();
