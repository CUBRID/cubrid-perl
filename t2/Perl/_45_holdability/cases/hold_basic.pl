#!perl -w

#Test the basic select is ok after holdability change.
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
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1,PrintError=>0,AutoCommit=>0}) or die "connect err: $dbh->errstr";

$dbh -> do("drop table if EXISTS hb01;") or die "drop error: $dbh->errstr";
$dbh -> do("create class hb01(i INT, working_days ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'),
            answers ENUM('Yes', 'No', 'Cancel'));") or die "create error: $dbh->errstr";
my $sth;
ok($sth=$dbh->prepare("insert into hb01 select 1,1,1 from db_class a,db_class b, db_class c limit 1000"),"prepare ok");
$dbh->{RaiseError}=0;
$dbh->{PrintError}=1;
ok($sth->execute(),"finished insert");
$dbh->commit or warn "commit error:$DBI::errstr";

$sth=$dbh->prepare("select * from hb01 order by i limit 0,1000;");
$sth->execute;

while(my $arry=$sth->fetchrow_arrayref()){
 is($arry->[0],1,'data right');
 is($arry->[1],'Monday','data right');
 is($arry->[2],'Yes','data right');
}

my $rows=$sth->rows;
is($rows,1000,"records number is ok");
$sth->finish();


$sth->finish();
done_testing();
$dbh -> disconnect();
