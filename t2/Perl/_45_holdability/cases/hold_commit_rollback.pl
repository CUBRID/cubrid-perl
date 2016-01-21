#!perl -w

#Test holdablity is ok after commit and rollback.
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
ok($sth=$dbh->prepare("insert into hb01 select rownum,1,1 from db_class a,db_class b, db_class c limit 1000"),"prepare ok");
$dbh->{RaiseError}=0;
$dbh->{PrintError}=1;
ok($sth->execute(),"finished insert");
$dbh->commit or warn "commit error:$DBI::errstr";

print "#########Test fetch the first record############\n";
my $sth1=$dbh->prepare("select * from hb01 order by i limit 0,10;");
ok($sth1->execute(),"execute select");
my $arry=$sth1->fetchrow_arrayref();
is($arry->[0],1,'i data right');
is($arry->[1],'Monday','data right');
is($arry->[2],'Yes','data right');


print "#########Test fetch the second record after commit############\n";
$dbh->commit or warn "commit error:$DBI::errstr";
$arry=$sth1->fetchrow_arrayref();
is($arry->[0],2,'i data right');
is($arry->[1],'Monday','data right');
is($arry->[2],'Yes','data right');


print "#########Test fetch record after rollback############\n";
$dbh->rollback or warn "commit error:$DBI::errstr";
$arry=$sth1->fetchrow_arrayref();
is($arry->[0],3,'i data right');
is($arry->[1],'Monday','data right');
is($arry->[2],'Yes','data right');

print "#########Test fetch record after execute again############\n";
ok($sth1->execute(),"execute select");
my $arry=$sth1->fetchrow_arrayref();
is($arry->[0],1,'i data right');
is($arry->[1],'Monday','data right');
is($arry->[2],'Yes','data right');
$dbh->commit or warn "commit error:$DBI::errstr";

$sth->finish();
$sth1->finish();
done_testing();
$dbh -> disconnect();
