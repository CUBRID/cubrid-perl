#!perl -w

# select enum data and select cast.
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

$dbh -> do("drop table if EXISTS enum02;") or die "drop error: $dbh->errstr";
$dbh -> do("create class enum02(i INT AUTO_INCREMENT, working_days ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'),answers ENUM('Yes', 'No', 'Cancel'));") or die "create error: $dbh->errstr";
$dbh -> do("insert into enum02(working_days, answers) values(?,?)") or die "insert error:$dbh->errstr";

plan tests=>5;
ok (my $sth=$dbh->prepare("insert into enum02(working_days, answers) values(?,?);"),"prepare ok");
ok ($sth->execute('Monday','Yes'),"prepare of insert succeed");
ok ($sth->execute('Friday','No'),"prepare of insert succeed");
ok ($dbh->do("select * from enum02"),"select * successed");
ok ($dbh->do("select cast(working_days as int),cast(answers as int) from enum02"),"select cast ok");

$sth->finish();
$dbh -> disconnect();




