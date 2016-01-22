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

use vars qw($db $port $hostname);

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";
$dbh -> do("drop table if EXISTS image_t;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE image_t (image_id VARCHAR(36) PRIMARY KEY, doc_id VARCHAR(64) NOT NULL, image BLOB);") or die "create error:  $dbh->errstr";
$dbh->do("INSERT INTO image_t VALUES ('image-0', 'doc-0', BIT_TO_BLOB(X'000001'));") or die "insert error: $dbh->errstr";
$dbh->do("INSERT INTO image_t VALUES ('image-1', 'doc-1', BIT_TO_BLOB(X'000010'));") or die "insert error: $dbh->errstr";
$dbh->do("INSERT INTO image_t VALUES ('image-2', 'doc-2', BIT_TO_BLOB(X'000100'));") or die "insert error: $dbh->errstr";

# http://jira.cubrid.org/browse/APIS-466, according this issue, change "BLOB_TO_BIT(image) to "image""
my $sth=$dbh->prepare(" select image from image_t;  ") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";

$sth->cubrid_lob_get (1) or die "cubrid_lob_get error: $dbh->errstr\n";
$sth->cubrid_lob_export(1,"$cwd/export1B.txt") or die "cubrid_lob_export error: $dbh->errstr";
$sth->cubrid_lob_export(2,"$cwd/export2B.jpg") or die "cubrid_lob_export error: $dbh->errstr";
$sth->cubrid_lob_export(3,"$cwd/export3B.jpg") or die "cubrid_lob_export error: $dbh->errstr";
$sth->cubrid_lob_close();


$sth->finish();
$dbh -> disconnect();




