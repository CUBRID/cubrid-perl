#!/bin/env perl
#
# CREATE TABLE test_seq (
#     tags   SEQUENCE (VARCHAR(512))
# );

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

my $sth = $dbh->prepare("DROP TABLE if exists $table");
$sth->execute;
$sth = $dbh->prepare("CREATE TABLE $table (tags SEQUENCE (bit(8)))");
$sth->execute;

my @av_data=[ '1' ,'11','10','111'];

plan tests => 5;
ok($sth = $dbh->prepare("INSERT INTO $table ( tags ) VALUES (?)"));
ok($sth->bind_param(1,@av_data,SQL_BIT) or die "bind_param error: $dbh->errstr");
ok($sth->execute());

ok ($sth = $dbh->prepare("SELECT * FROM $table"));
ok($sth->execute);

$sth->finish();
$dbh -> disconnect();