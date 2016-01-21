#!perl -w

#Test holdability after rollback.
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

$dbh -> do("drop table if EXISTS enumh02;") or die "drop error: $dbh->errstr";
$dbh -> do("create class enumh02(i INT, working_days ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'),
            answers ENUM('Yes', 'No', 'Cancel'));") or die "create error: $dbh->errstr";
$dbh -> do("insert into enumh02 values (1,1,1);");
$dbh ->commit;
$dbh->{RaiseError}=0;
$dbh->{PrintError}=1;

ok(my $sth=$dbh->prepare("select * from enumh02;"),"prepare ok");
$sth->execute or warn "first execute error:$DBI::errstr";
$dbh->rollback or warn "After select do commit error:$DBI::errstr";

if(my $arry=$sth->fetchrow_arrayref()){
 is($arry->[0],undef,'data right');
 is($arry->[1],undef,'data right');
 is($arry->[2],undef,'data right');
}else{
 ok(1,"havent data ok");
}

$sth->execute or warn "after rollback execute error:$DBI::errstr";

while(my $arry=$sth->fetchrow_arrayref()){
 is($arry->[0],1,'data right');
 is($arry->[1],'Monday','data right');
 is($arry->[2],'Yes','data right');
}

$sth->finish();
done_testing();
$dbh -> disconnect();
