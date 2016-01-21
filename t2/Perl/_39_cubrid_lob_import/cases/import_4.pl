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


my $sth=$dbh->prepare(" select * from image_t;  ") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";

$sth->cubrid_lob_get (3) or die "cubrid_lob_get error: $dbh->errstr\n";
$sth->cubrid_lob_export(1,"export1B.txt") or die "cubrid_lob_export error: $dbh->errstr";
$sth->finish;

my $sth=$dbh->prepare("insert into image_t values(?,?,?);") or die "prepare error: $dbh->errstr";
$sth->bind_param(1, 'image-3') or die "bind_param error: $dbh->errstr";
$sth->bind_param(2, 'doc-3') or die "cubrid_lob_import error: $dbh->errstr";
my $ip=$sth->cubrid_lob_import (3,"export1B.txt",DBI::SQL_BLOB) or die "cubrid_lob_import error: $dbh->errstr";

$sth->execute() or die "execute error: $dbh->errstr";
$sth->cubrid_lob_close();
$sth->finish();

print "##########################export############";
my $sth1=$dbh->prepare("select * from image_t;") or die "prepare error: $dbh->errstr";
$sth1->execute() or die "execute error: $dbh->errstr";
$sth1->cubrid_lob_get (3) or die "cubrid_lob_get error: $dbh->errstr\n";
$sth1->cubrid_lob_export(3,"export1B.answer") or die "cubrid_lob_export error: $dbh->errstr";

$sth1->cubrid_lob_close();


$sth1->finish();
$dbh -> disconnect();
