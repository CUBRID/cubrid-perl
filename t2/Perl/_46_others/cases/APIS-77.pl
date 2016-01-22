#!perl -w 

use DBI;
use Test::More;
use DBI qw(:sql_types);
use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect err: $dbh->errstr";

$dbh -> do("drop table if EXISTS tm;") or die "drop error: $dbh->errstr";
$dbh -> do("CREATE TABLE tm(col_time time);") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("insert into tm values(?);") or die "prepare error: $dbh->errstr";
my $bdRs1=$sth->bind_param(1, '10:20:59 aaM',SQL_TIME) or die "bind_param error: $dbh->errstr";

print  "1: $bdRs1\n";


$sth->execute();# or die "execute error: $dbh->errstr";
#print $dbh->errstr
#like($dbh->errstr,qr/"Cannot coerce host var to type time"/,"error data type");
#print $dbh->errstr ."\n";
done_testing();
$sth->finish();
$dbh -> disconnect();
