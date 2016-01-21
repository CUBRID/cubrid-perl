#!perl -w

#Test bind method for update.
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

$dbh -> do("drop table if EXISTS enumb03;") or die "drop error: $dbh->errstr";
$dbh -> do("create table enumb03(e1 enum('a', 'b'), e2 enum('Yes', 'No', 'Cancel'), e3 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),e4 enum('x', 'y', 'z'));") or die "create error: $dbh->errstr";

$dbh -> do("insert into enumb03 values(1, 1, 1, 1), (2, 3, 7, 3), ('b', 'No', 'Tuesday', 'y'), ('a', 'Yes', 'Friday', 'x'),('a', 'Cancel', 'Thursday', 'z'), ('b', 1, 4, 'z')") or die "insert values err: $dbh->errstr";

#plan tests=>21;

ok(my $sth=$dbh->prepare("select * from enumb03 where e3 < ? and (e1 <> ? or e2 <> ?) order by 1, 2, 3, 4")," select prepare");
ok($sth->bind_param(1,3)," bind_param ok");
ok($sth->bind_param(2,2)," bind_param ok");
ok($sth->bind_param(3,1)," bind_param ok");
ok($sth->execute(),"execute ok");

ok($sth->bind_param(1,9)," bind_param ok");
ok($sth->bind_param(2,4)," bind_param ok");
ok($sth->bind_param(3,2)," bind_param ok");
ok($sth->execute(),"execute ok");
$sth->finish();

ok(my $sth=$dbh->prepare("update enumb03 set e1=?, e2=? where e3=?"),"select prepare");
ok($sth->bind_param(1,'a'),"bind_param ok");
ok($sth->bind_param(2,'Yes'),"bind_param ok");
ok($sth->bind_param(3,'Monday'),"bind_param ok");
ok($sth->execute(),"execute ok");

$dbh->{PrintError}=1;
$dbh->{RaiseError}=0;

ok($sth->bind_param(1,'ai'),"error value bind_param ok");
ok($sth->bind_param(2,'Yes'),"bind_param ok");
ok($sth->bind_param(3,'Monday'),"bind_param ok");
ok($sth->execute(),"error value execute");

ok($sth->bind_param(1,'ai'),"error value bind_param ok");
ok($sth->bind_param(2,'Yes'),"bind_param ok");
ok($sth->bind_param(3,'Friday'),"bind_param ok");
$sth->execute();
like($DBI::errstr,qr/Cannot coerce value of domain/,"Error value execute");

ok($sth->bind_param(1,'a'),"error index bind_param ok");
ok($sth->bind_param(2,'Yes'),"bind_param ok");
$sth->bind_param(4,'Monday');
like($DBI::errstr,qr/Parameter index is out of range/,"Bind error index value");
$sth->execute();
$sth->finish();

$dbh->do("select * from enumb03 order by 1,2,3,4");

done_testing();

$sth->finish();
$dbh -> disconnect();
