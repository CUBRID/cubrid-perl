#!perl -w

#Test bind method for insert.
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

$dbh -> do("drop table if EXISTS enumb01;") or die "drop error: $dbh->errstr";
$dbh -> do("create class enumb01(i INT, working_days ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'),
            answers ENUM('Yes', 'No', 'Cancel'));") or die "create error: $dbh->errstr";

plan tests=>13;

ok(my $sth=$dbh->prepare("insert into enumb01(working_days, answers) values(?,?);"),"1insert prepare");
ok($sth->bind_param(1,'Monday')," bind_param ok");
ok($sth->bind_param(2,'Yes'),"bind_param ok");
ok($sth->execute()," execute ok");
ok($sth->bind_param(2,'No')," bind_param ok");
ok($sth->bind_param(1,'Tuesday')," bind_param ok");
ok($sth->execute(),"execute ok");
ok($sth->bind_param(2,'No')," bind_param ok");

$dbh->{PrintError}=1;
$dbh->{RaiseError}=0; 

$sth->bind_param(3,'Tuesday');
like($DBI::errstr,qr/Parameter index/, " index error");
ok($sth->execute()," execute ok");

ok($sth->bind_param(1,'aaa')," bind error param ok");
$sth->execute();
like($DBI::errstr,qr/Cannot coerce host var to type enum/, " value error");


$sth->bind_param(1,'Tuesday');
ok($sth->execute(),"10 execute ok");


$sth->finish();
$dbh -> disconnect();
