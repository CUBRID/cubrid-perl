#!perl -w

use DBI;
use Test::More;
use strict;

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


my $sth=$dbh->prepare("select * from image_t") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";

my  $value=$sth->cubrid_lob_get (3) ; # fetch the second column
#print "value: $value\n";

plan tests=>2;
ok( $value ==1 , "cubrid_lob_get ok");

my $closeValue=$sth->cubrid_lob_close();
#print "closeValue: $closeValue\n";
ok($closeValue == 1, "cubrid_lob_close ok");

$sth->finish();
$dbh -> disconnect();



