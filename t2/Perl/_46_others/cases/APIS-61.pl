#!perl -w

use DBI;
use Test::More;
use DBI qw(:sql_types);
#use strict;

use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb (id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, num DOUBLE);") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("insert into tdb (id, num) values(NULL,?)") or die "prepare error: $dbh->errstr";
$sth->bind_param(1,2.1,SQL_DOUBLE) or die "bind_param error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";
$sth->finish or die "finish error: $dbh->errstr";

my $sql="select * from tdb";
$sth=$dbh->prepare($sql);
$sth->execute;
my $rows=$sth->fetchall_arrayref({});
$sth->finish();
print "Values: $rows->[0]{num}\n";
is($rows->[0]{num},2.1,"ok");
done_testing();

$dbh->disconnect();

