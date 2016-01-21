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

$dbh -> do("drop table if EXISTS test4;") or die "drop error: $dbh->errstr";
$dbh -> do("CREATE TABLE test4(col_time time,col_date date,col_timestamp timestamp,col_datetime datetime);") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("insert into test4 values(?,?,?,?);") or die "delete error: $dbh->errstr";
my $bdRs1=$sth->bind_param(1, '10:20:30 AM',SQL_TIME) or die "bind_param error: $dbh->errstr";
my $bdRs2=$sth->bind_param(2, '12/25/1999',SQL_DATE) or die "bind_param error: $dbh->errstr";
my $bdRs3=$sth->bind_param(3, '10:20:30 AM 12/25/1999',SQL_TIMESTAMP) or die "bind_param error: $dbh->errstr";
my $bdRs4=$sth->bind_param(4, '10:12:13 6/5/2009',SQL_DATETIME) or die "bind_param error: $dbh->errstr";

#print  "1: $bdRs1\t 2:$bdRs2\t 3: $bdRs3\t 4: $bdRs4\n\n";
is($bdRs1,1,"bind 1 ok");
is($bdRs2,1,"bind 2 ok");
is($bdRs3,1,"bind 3 ok");
is($bdRs4,1,"bind 4 ok");

=head;
if( $bdRs == 0){
   print "undefined: $bdRs \n";
}else{
   print "define\n";
}
=cut;

$sth->execute() or die "execute error: $dbh->errstr";
done_testing();
$sth->finish();
$dbh -> disconnect();
