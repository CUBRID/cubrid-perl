#!perl -w

# Test the prepare for select
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
$dbh=DBI->connect($data_source, $user, $pass,{RaiseError => 1}) or die "connecr error: $dbh->errstr";

$dbh->do("drop table if EXISTS enum03;") or die "drop error: $dbh->errstr";

$dbh->do("create table enum03(e1 enum('a', 'b'), e2 enum('Yes', 'No', 'Cancel'),e3 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),e4 enum('x', 'y', 'z'));") or die "create error: $dbh->errstr";
$dbh -> do("insert into enum03 values(1,1,1,1), (2, 3, 7, 3), ('b', 'No', 'Tuesday', 'y'),('a', 'Yes', 'Friday', 'x'), ('a', 'Cancel', 'Thursday', 'z'),('b', 1, 4, 'z');") or die "insert error:$dbh->errstr";

plan tests=>3;
ok (my $sth=$dbh->prepare("select * from enum03 where e3 < ? and (e1 <> ? or e2 <> ?) order by 1, 2, 3,4"),"prepare ok");
ok ($sth->execute(6,2,3),"prepare of select succeed");
ok ($sth->execute('Sunday', 'a', 'Yes'),"prepare of select succeed");

$sth->finish();

$dbh->disconnect();




