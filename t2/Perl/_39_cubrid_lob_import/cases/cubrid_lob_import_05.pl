#!perl -w

use DBI;
use Test::More;
use strict;

use Cwd;
use File::Basename;

my $cwd;
if ($0 =~ m{^/}) {
  $cwd = dirname($0);
} else {
  $cwd = dirname(getcwd()."/$0");
}


use vars qw($db $port $hostname $path);

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
$path=$ARGV[3];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";
$dbh -> do("drop table if EXISTS import_2;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE import_2 (image_id VARCHAR(36) PRIMARY KEY, image BLOB);") or die "create error:  $dbh->errstr";

my $sth=$dbh->prepare("insert into import_2 values(?,?);") or die "prepare error: $dbh->errstr";
$sth->bind_param (1, 1) or die "bind_param error: $dbh->errstr";
my $ip=$sth->cubrid_lob_import(2,"$cwd/2.txt", DBI::SQL_BLOB) or die "cubrid_lob_import error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";

my $cs=$sth->cubrid_lob_close();

plan tests=>2;
ok($ip == 1, "cubrid_lob_import ok");
ok($cs == 1, "cubrid_lob_close ok");

$sth->finish();
$dbh -> disconnect();



