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

my $sth=$dbh->prepare("select  * from doc_t") or die "prepare error: $dbh->errstr";
$sth->execute() or die  $dbh->errstr. "  execute error\n";

my  $value=$sth->cubrid_lob_get (1);# fetch the second column
is($value,1,"cubrid_lob_get ok");
is($dbh->errstr,undef,"cubrid_lob_get ok");

my $closeValue=$sth->cubrid_lob_close();
is($closeValue,1,"cubrid_lob_get ok");

done_testing();

$sth->finish();
$dbh -> disconnect();



