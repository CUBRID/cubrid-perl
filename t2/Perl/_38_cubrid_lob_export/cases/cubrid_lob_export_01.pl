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
$dbh -> do("drop table if EXISTS doc_t;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE doc_t (doc_id VARCHAR(64) PRIMARY KEY, content CLOB);") or die "create error:  $dbh->errstr";
$dbh->do("INSERT INTO doc_t (doc_id, content) VALUES ('doc-1', CHAR_TO_CLOB('This is a Dog'));") or die "insert error: $dbh->errstr";
$dbh->do("INSERT INTO doc_t (doc_id, content) VALUES ('doc-2', CHAR_TO_CLOB('This is a Cat'));") or die "insert error: $dbh->errstr";

my $sth=$dbh->prepare("select * from doc_t") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";
my $curpath=$cwd."/export2.txt";
#print $curpath;
$sth->cubrid_lob_get (2) or die "cubrid_lob_get error: $dbh->errstr\n";
$sth->cubrid_lob_export(1,$cwd."/export1.txt") or die "cubrid_lob_export error: $dbh->errstr";
$sth->cubrid_lob_export(2,$curpath) or die "cubrid_lob_export error: $dbh->errstr";

$sth->cubrid_lob_close();
$sth->finish();
$dbh -> disconnect();

