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
$dbh -> do("drop table if EXISTS doc_t;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE doc_t (doc_id VARCHAR(64) PRIMARY KEY, content CLOB);") or die "create error:  $dbh->errstr";
$dbh->do("INSERT INTO doc_t (doc_id, content) VALUES ('doc-1', CHAR_TO_CLOB('This is a Dog'));") or die "insert error: $dbh->errstr";
$dbh->do("INSERT INTO doc_t (doc_id, content) VALUES ('doc-2', CHAR_TO_CLOB('This is a Cat'));") or die "insert error: $dbh->errstr";

my $sth=$dbh->prepare("select * from doc_t") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";

my  $value=$sth->cubrid_lob_get (2) . "\n"; # fetch the second column
#print "value: $value\n";

plan tests=>2;
ok( $value ==1 , "cubrid_lob_get ok");

my $closeValue=$sth->cubrid_lob_close();
#print "closeValue: $closeValue\n";
ok($closeValue == 1, "cubrid_lob_close ok");

$sth->finish();
$dbh -> disconnect();



