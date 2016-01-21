#!perl -w

# Test prepare for update
use DBI;
use DBD::cubrid;
use Test::More;
use strict;

use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $data_source="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;

$dbh=DBI->connect($data_source, $user, $pass,
	{RaiseError => 1}) or die "connect err: $dbh->errstr";

$dbh -> do("drop table if EXISTS enum032;") or die "drop error: $dbh->errstr";
$dbh -> do("create table enum032(id int, e2 enum('Yes', 'No', 'Cancel'),e3 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),e4 enum('x', 'y', 'z'));") or die "create error: $dbh->errstr";
$dbh -> do("insert into enum032 values(1,1,1,1),(6, 1, 4, 'z');") or die "insert error:$dbh->errstr";

plan tests=>3;
ok (my $sth=$dbh->prepare("update enum032 set e3=? where id=1"),"prepare ok");
is ($sth->execute(-1),undef,"prepare of select succeed");
ok ($sth->execute('Saturday'),"prepare of select succeed");


$sth->finish();
$dbh -> disconnect();
