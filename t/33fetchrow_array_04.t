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

$dbh -> do("drop table if EXISTS test_tbl;") or die "drop error: $dbh->errstr";
$dbh -> do("create table test_tbl(age int,firstName varchar(20),lastName varchar(10),income float);") or die "create error: $dbh->errstr";
$dbh->do("insert into test_tbl values (26,'john','poul',13000),(26,'Bobo','Li',9000),(33,'Jacky','Wang',16000);") or die "insert: $dbh->err
str";

plan tests=>4;
my $name="jo%";
my $sth=$dbh->prepare("select * from test_tbl where firstName like ?;");
$sth->execute($name) or die "execute select: $dbh->errstr\n";
while(my $row_ref =$sth->fetchrow_arrayref()){
   ok($row_ref->[0] eq 26, "age ok");
   ok($row_ref->[1] eq 'john', "firstName ok");
   ok($row_ref->[2] eq 'poul', "lastName ok");
   ok($row_ref->[3] eq 13000, "income ok");  
}

$sth->finish();
$dbh -> disconnect();

