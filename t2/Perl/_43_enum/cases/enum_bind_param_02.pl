#!perl -w

#Test bind method for select.
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
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1,PrintError=>0}) or die "connect err: $dbh->errstr";

$dbh -> do("drop table if EXISTS enumb02;") or die "drop error: $dbh->errstr";
$dbh -> do("create table enumb02(e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'), e2 enum('02/23/2012', '12/21/2012'), e3 enum('11:12:09', '13:13:13'), e4 enum('123', '9876', '-34'));") or die "create error: $dbh->errstr";

$dbh -> do("insert into enumb02 values(2, 1, 1, 2), (5, 2, 1, 1), (6, 2, 2, 3),(1, 1, 1, 2), (7, 1, 2, 3), (4, 2, 2, 2), (3, 1, 1, 1);") or die "insert values err: $dbh->errstr";

plan tests=>27;

ok(my $sth=$dbh->prepare("select e1 + ?, ? + e1, e1 + ?, e1 * ?, e1 + ? from enumb02 where e1 < ? order by 1, 2, 3, 4, 5")," select prepare");
ok($sth->bind_param(1,1)," bind_param ok");
ok($sth->bind_param(2,2)," bind_param ok");
ok($sth->bind_param(3,3)," bind_param ok");
ok($sth->bind_param(4,4)," bind_param ok");
ok($sth->bind_param(5,7)," bind_param ok");
ok($sth->bind_param(6,7)," bind_param ok");
ok($sth->execute(),"4 execute ok");

ok($sth->bind_param(1,1)," bind_param ok");
ok($sth->bind_param(2,2)," bind_param ok");
ok($sth->bind_param(2,3)," bind_param ok");
ok($sth->bind_param(2,4)," bind_param ok");
ok($sth->execute(),"4 execute ok");
$sth->finish();

ok(my $sth=$dbh->prepare("select repeat(e1, ?), substring(e1, ?, ?), concat(e1,?, e2, ?, e3), repeat(?, e1) from enumb02 order by 1, 2, 3, 4"),"select prepare");
ok($sth->bind_param(1,1),"bind_param ok");
ok($sth->bind_param(2,2),"bind_param ok");
ok($sth->bind_param(3,3),"bind_param ok");
ok($sth->bind_param(4,4),"bind_param ok");
ok($sth->bind_param(5,7),"bind_param ok");
ok($sth->bind_param(6,7),"bind_param ok");
ok($sth->execute(),"execute ok");
$sth->finish();

ok(my $sth=$dbh->prepare("select * from enumb02 where e1 in (?, ?, ?, ?)"),"select prepare");
ok($sth->bind_param(1,1),"bind_param ok");
ok($sth->bind_param(2,2),"bind_param ok");
ok($sth->bind_param(3,3),"bind_param ok");
ok($sth->bind_param(4,4),"bind_param ok");
ok($sth->execute(),"execute ok");


$sth->finish();
$dbh -> disconnect();
