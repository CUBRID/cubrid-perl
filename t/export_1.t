#!perl -w

use DBI ();
use Test::More;
use lib 't', '.';
require 'lib.pl';
use vars qw($table $test_dsn $test_user $test_passwd);

my $dbh;
eval {$dbh= DBI->connect($test_dsn, $test_user, $test_passwd,
                      { RaiseError => 1, PrintError => 1, AutoCommit => 0 });};
$dbh -> do("drop table if EXISTS image_t;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE image_t (image_id VARCHAR(36) PRIMARY KEY, doc_id VARCHAR(64) NOT NULL, image BLOB);") or die "create error:  $dbh->errstr";
$dbh->do("INSERT INTO image_t(image_id, doc_id) VALUES ('image-0', 'doc-0');") or die "insert error: $dbh->errstr";

my $sth=$dbh->prepare("select  * from image_t") or die "prepare error: $dbh->errstr";
$sth->execute() or die  $dbh->errstr. "  execute error\n";

my  $value=$sth->cubrid_lob_get(3) or die $dbh->errstr ."  lob_get error\n";# fetch the second column
print "value: $value\n";

$sth->cubrid_lob_export(1,"null1.txt");

like($dbh->errstr,qr/Invalid lob handle/,"cubrid_lob_export error");



my $closeValue=$sth->cubrid_lob_close();
print "closeValue: $closeValue\n";


done_testing();
$sth->finish();
$dbh -> disconnect();



