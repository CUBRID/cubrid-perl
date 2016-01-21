#!perl -w

use DBI;
use Test::More;
use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect err: $dbh->errstr";
$dbh -> do("drop table if EXISTS employees;" );

$dbh -> do("create table employees(id int not null, name varchar(20));") or die "create err $dbh->errstr";

my @names=("Larry","Tim","Rain");
my $strSQL="insert into employees values(?,?);";
$sth=$dbh->prepare_cached($strSQL) or die "prepare error: $dbh->err";

$sth->bind_param_array(1,[1,2,3]) or die "bind_param_array error: $dbh->errstr";
$sth->bind_param_array(2,\@names) or die "bind_param_array error: $dbh->errstr";
$rv=$sth->execute_array( { ArrayTupleStatus => \my @tuple_status } ) or die "execute_array error: $dbh->errstr";
#print "rv values is $rv\n";
$sth->finish;

$sth=$dbh->prepare_cached($strSQL) or die "prepare error: $dbh->err";
$sth->bind_param_array(1,[4]) or die "bind_param_array error: $dbh->errstr";
$sth->bind_param_array(2,['Jim']) or die "bind_param_array error: $dbh->errstr";
$rv2=$sth->execute_array( { ArrayTupleStatus => \my @tuple_status } ) or die "execute_array error: $dbh->errstr";
#print "rv2 values is $rv2\n";


plan tests=>2;
ok($rv eq 3, "execute_array ok");
ok($rv2 ==1, "execute_array ok");
$sth->finish();
$dbh -> disconnect();
