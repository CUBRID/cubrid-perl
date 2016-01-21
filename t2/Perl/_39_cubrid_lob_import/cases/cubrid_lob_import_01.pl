#!perl -w

use DBI;
use DBD::cubrid;
use Cwd;
use File::Basename;
use Test::More;
use strict;

use vars qw($db $port $hostname);

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $cwd;
if ($0 =~ m{^/}) {
  $cwd = dirname($0);
} else {
  $cwd = dirname(getcwd()."/$0");
}
#print "$cwd\n";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";
$dbh -> do("drop table if EXISTS import_1 ;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE import_1 (doc_id VARCHAR(64) PRIMARY KEY, content CLOB);") or die "create error:  $dbh->errstr";

my $sth=$dbh->prepare("insert into import_1 values(?,?);") or die "prepare error: $dbh->errstr";
$sth->bind_param (1, 1) or die "bind_param error: $dbh->errstr";
my $importValue=$sth->cubrid_lob_import(2,"$cwd/import1.txt",DBI::SQL_CLOB) or die "cubrid_lob_import error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";

my $closeValue=$sth->cubrid_lob_close();

plan tests=>2;
ok($importValue == 1, "cubrid_lob_import ok");
ok($closeValue ==1, "cubrid_lob_close ok");
$sth->finish();
$dbh -> disconnect();



