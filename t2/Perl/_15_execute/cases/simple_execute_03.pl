#!perl -w

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
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";


my $statement1="SELECT ((CAST ({3,3,3,2,2,1} AS SET))+(CAST ({4,3,3,2} AS MULTISET)));";
my $sth=$dbh->prepare($statement1) or die "prepare error: $dbh->errstr";
my $exResult1=$sth->execute or die "execute error: $dbh->errstr";
my $row_ref1 =$sth->fetchrow_arrayref();
my $value1=$row_ref1->[0];
is($row_ref1->[0], '{1, 2, 2, 3, 3, 3, 4}',"execute");
ok($sth->finish(),"finish ok");



#####################
my $sth2=$dbh->prepare("SELECT (CAST(TIMESTAMP'2008-12-25 10:30:20' AS TIME));") or die "prepare error: $dbh->errstr";
$sth2->execute or die "execute error: $dbh->errstr";
my $row_ref2 =$sth2->fetchrow_arrayref();
my $value2=$row_ref2->[0];
is($row_ref2->[0],"10:30:20","execute");
$sth2->finish();

####################
my $sth=$dbh->prepare("SELECT (CAST(1234.567890 AS CHAR(5)));") or die "prepare error: $dbh->errstr";
my $prepare_error=$dbh->errstr;
$sth->execute;# or die "execute error: $dbh->errstr";
my $execute_error=$dbh->errstr;
is($execute_error,"CUBRID DBMS Error : (-181) Cannot coerce value of domain \"numeric\" to domain \"character\".","execute ok");

$sth->finish();
done_testing();



$dbh -> disconnect();



