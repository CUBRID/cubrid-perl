#!perl -w

#Test holdability after commit.
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

$dbh -> do("drop table if EXISTS enumb01;") or die "drop error: $dbh->errstr";
$dbh -> do("create class enumb01(i INT, working_days ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'),
            answers ENUM('Yes', 'No', 'Cancel'));") or die "create error: $dbh->errstr";
my $sth;
ok($sth=$dbh->prepare("insert into enumb01 values (?,?,?);"),"prepare ok");
$dbh->{RaiseError}=0;
$dbh->{PrintError}=1;
ok($sth->execute(1,'Monday','Yes'),"insert execute ok");
$dbh->commit or warn "commit error:$DBI::errstr";

$sth=$dbh->prepare("select * from enumb01;");
$sth->execute;
$dbh->commit or warn "After select do commit error:$DBI::errstr";

while(my $arry=$sth->fetchrow_arrayref()){
 is($arry->[0],1,'data right');
 is($arry->[1],'Monday','data right');
 is($arry->[2],'Yes','data right');
}


$sth->finish();
done_testing();
$dbh -> disconnect();
