#!perl -w

use DBI ();
use Test::More;
use lib 't', '.';
require 'lib.pl';
use vars qw($table $test_dsn $test_user $test_passwd);

my $dbh;
eval {$dbh= DBI->connect($test_dsn, $test_user, $test_passwd,
                      { RaiseError => 1, PrintError => 1, AutoCommit => 0 });};
if ($@) {
    plan skip_all => "ERROR: $DBI::errstr. Can't continue test";
}

plan tests => 13;

ok ($dbh->do("DROP TABLE IF EXISTS $table"));

my $create = <<EOT;
CREATE TABLE $table (a INT, b DOUBLE, c STRING, d int,e bigint,f bit)
EOT

ok ($dbh->do($create));

ok ($sth = $dbh->prepare("INSERT INTO $table VALUES (?, ?,?,?,?,?)"));

ok ($sth->bind_param(1,1234));
ok ($sth->bind_param(2, 123.56));
ok ($sth->bind_param(3, "abc"));
ok ($sth->bind_param(4, 12));
ok ($sth->bind_param(5, 111111111111111));
ok ($sth->bind_param(6, '0'));
ok ($sth->execute);

$sth=$dbh->prepare("select * from $table ") or die $dbh->errstr ." prepare error\n";
$sth->execute or die  $dbh->errstr ."  delete error\n";

ok ($dbh->do("DROP TABLE $table"));

ok $sth->finish;
ok $dbh->disconnect;
