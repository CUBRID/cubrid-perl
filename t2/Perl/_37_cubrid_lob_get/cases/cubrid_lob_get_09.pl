#!perl -w

use DBI;
use Test::More;
use strict;
use DBI qw(:sql_types);
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

my $sth=$dbh->prepare("insert into doc_t values(?,?)") or die "prepare error: $dbh->errstr";
$sth->bind_param(1,'doc-3') or die  $dbh->errstr . "   bind_param error\n"; 
$sth->bind_param(2,'ccccc',SQL_CLOB) or die  $dbh->errstr . "   bind_param error\n";
$sth->execute() or die "execute error:". $dbh->errstr ."\n";

my  $value=$sth->cubrid_lob_get (0) . "\n"; # fetch the second column
is(int($value),0,"cubrid_lob_get ok");
my $err=$dbh->errstr;
is($err,"CCI Error : Column index is out of range","cubrid_lob_get ok");

my $closeValue=$sth->cubrid_lob_close();
is($closeValue,1,"cubrid_lob_get ok");
done_testing();

$sth->finish();
$dbh -> disconnect();



