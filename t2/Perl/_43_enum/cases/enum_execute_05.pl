#!perl -w
#Test execute for select_1;
use DBI;
use Test::More;
#use strict;
#Test execute for insert index.
use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";

my $dbh;

$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

$dbh->do("drop table if EXISTS enume05;") or die "drop error: $dbh->errstr";
$dbh->do("create class enume05(i INT, working_days ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') not null,answers ENUM('Yes', 'No', 'Cancel'))") or die "create error: $dbh->errstr";
$dbh->do("insert into enume05 values(1,1,1),(2,2,2);") or die "insert error:$dbh-errstr";

ok(my $sth=$dbh->prepare("delete from enume05 where working_days='Monday' "),"Prepare select is ok");
$sth->execute;
my $sel_sql="select * from enume05";
my $sth=$dbh->prepare($sel_sql);
$sth->execute or die "select error:$dbh->errstr";
my $rows=$sth->rows;
is($rows,1,"has delete one data");
$sth->finish();


ok(my $sth=$dbh->prepare("delete from enume05 where working_days=1 "),"Prepare select is ok");
$sth->execute;
my $sel_sql="select * from enume05";
my $sth=$dbh->prepare($sel_sql);
$sth->execute or die "select error:$dbh->errstr";
my $rows=$sth->rows;
is($rows,1,"done't delete date where enum=index");
$sth->finish();


done_testing();
$dbh -> disconnect();



