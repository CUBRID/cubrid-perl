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

$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb(typeid_ tinyint NOT NULL default 0, type_ varchar(50) NOT NULL, typeabr_ varchar(50) NULL);") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("insert into tdb (typeid_, type_, typeabr_) values(?,?,?); ") or die "prepare error: $dbh->errstr";
$sth->bind_param_array(1,[30]) or die "bind_param_array error: $dbh->errstr";
$sth->bind_param_array(2,["aa"]) or die "bind_param_array error: $dbh->errstr";
$sth->bind_param_array(3,["bb"]) or die "bind_param_array error: $dbh->errstr";
my $rv=$sth->execute_array( { ArrayTupleStatus => \my @tuple_status } ) or die "execute_array error: $dbh->errstr";
#print "rv values is $rv\n";

plan tests=>1;
ok($rv eq 1,"bind_param_array ok");

$sth->finish();
$dbh -> disconnect();
