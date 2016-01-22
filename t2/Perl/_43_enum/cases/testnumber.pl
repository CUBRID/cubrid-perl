#!perl -w

## Test insert by enum index by prepare.
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
$sth->bind_param(1, 1, DBI::SQL_INTEGER);
$sth->bind_param(2, 1, DBI::SQL_INTEGER);
$sth->bind_param(3, 1, DBI::SQL_INTEGER);
$sth->execute() or warn "Insert error: $DBI::errstr";


$dbh->commit or warn "commit error:$DBI::errstr";
$sth->finish();
done_testing();
$dbh -> disconnect();
