#!perl -w
#Test execute for select_1;
use DBI;
use Test::More;
#use strict;
#Test execute for delete condition is enum.
use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";

my $dbh;

$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

$dbh->do("drop table if EXISTS enume04;") or die "drop error: $dbh->errstr";
$dbh->do("create class enume04(i INT, working_days ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') not null,answers ENUM('Yes', 'No', 'Cancel'))") or die "create error: $dbh->errstr";
$dbh->do("insert into enume04 values(1,1,1);") or die "insert error:$dbh-errstr";
my $sth;

###############################################
ok($sth=$dbh->prepare("delete from enume04 where working_days='Monday';"),"Prepare select is ok");
$sth->execute;
my $num=$sth->rows();
is($num,1,"have deleted one records");
$sth->finish();
my $sth=$dbh->prepare("select * from enume04;");
my $num=$sth->rows();
is($num,-1,"haven't change any records");

done_testing();
$dbh -> disconnect();



