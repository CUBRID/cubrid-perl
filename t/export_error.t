#!perl -w

use DBI ();
use Test::More;
use lib 't', '.';
require 'lib.pl';
use vars qw($table $test_dsn $test_user $test_passwd);

my $dbh;
eval {$dbh= DBI->connect($test_dsn, $test_user, $test_passwd,
                      { RaiseError => 1, PrintError => 1, AutoCommit => 0 });};
$dbh -> do("drop table if EXISTS doc_t;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE doc_t (doc_id VARCHAR(64) PRIMARY KEY, content CLOB);") or die "create error:  $dbh->errstr";
$dbh->do("INSERT INTO doc_t (doc_id, content) VALUES ('doc-1', CHAR_TO_CLOB('This is a Dog'));") or die "insert error: $dbh->errstr";
$dbh->do("INSERT INTO doc_t (doc_id, content) VALUES ('doc-2', CHAR_TO_CLOB('This is a Cat'));") or die "insert error: $dbh->errstr";

my $sth=$dbh->prepare("select * from doc_t") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";
my $curpath=`pwd`;
chomp $curpath;
my $path1=$curpath."/pldb/2.txt";

print $path1."#################\n";

$sth->cubrid_lob_get (2) or die "cubrid_lob_get error: $dbh->errstr\n";
$sth->cubrid_lob_export(1,"1.txt") or die "cubrid_lob_export error: $dbh->errstr";
#$sth->cubrid_lob_export(2, $path1) or die "cubrid_lob_export error: $dbh->errstr";
#$sth->cubrid_lob_export(3,"3.txt") or die "cubrid_lob_export error: $dbh->errstr";



$sth->cubrid_lob_close();
$sth->finish();
$dbh -> disconnect();



