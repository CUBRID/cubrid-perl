#!perl -w

#Test bind method for delete.
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

$dbh -> do("drop table if EXISTS enumb04;") or die "drop error: $dbh->errstr";
$dbh -> do("create table enumb04(e1 enum('a', 'b'), e2 enum('Yes', 'No', 'Cancel'), e3 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),e4 enum('x', 'y', 'z'));") or die "create error: $dbh->errstr";

$dbh -> do("insert into enumb04 values(1, 1, 1, 1), (2, 3, 7, 3), ('b', 'No', 'Tuesday', 'y'), ('a', 'Yes', 'Friday', 'x'),('a', 'Cancel', 'Thursday', 'z'), ('b', 1, 4, 'z')") or die "insert values err: $dbh->errstr";

#plan tests=>21;

ok(my $sth=$dbh->prepare("delete from enumb04 where e1=?")," select prepare");
ok($sth->bind_param(1,'c')," bind_param ok");
ok($sth->execute(),"execute ok");
my $rows=$dbh->do("select * from enumb04;");
is($rows,6,"Haven't deleted anything");

ok($sth->bind_param(1,'b')," bind_param ok");
ok($sth->execute(),"execute ok");
my $rows=$dbh->do("select * from enumb04;");
is($rows,3,"Deleted successfully");


$sth->bind_param(2,'b');
like($DBI::errstr,qr/Parameter index is out of range/,"Error index is ok");
ok($sth->execute(),"execute ok");
my $rows=$dbh->do("select * from enumb04;");
is($rows,3,"Deleted successfully");


done_testing();

$sth->finish();
$dbh -> disconnect();
