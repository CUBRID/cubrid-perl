#!perl -w

#using NULL value
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

$dbh -> do("create table employees(id int not null, name varchar(128),title varchar(128),phone char(8));") or die "create err $dbh->errstr";
$dbh->do("insert into employees values (1,'Larryma','Computer','5555-0101'),(2,'Times','Database','5555-0202'),(3,'Darling','Perl','5555-0303');") or die "insert error: $dbh->errstr";
my @names=("Larry%","Tim%","Rain%");
my $sth=$dbh->prepare("delete from employees where name LIKE ?;") or die "prepare error: $dbh->err";

$sth->bind_param_array(1,\@names) or die "bind_param_array error: $dbh->errstr";
my $rv=$sth->execute_array( { ArrayTupleStatus => \my @tuple_status } ) or die "execute_array error: $dbh->errstr";
is($rv,3,"bind_param_array delete ok");
done_testing();

$sth->finish();
$dbh -> disconnect();
