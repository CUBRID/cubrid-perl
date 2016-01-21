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

$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb(st SET);") or die "create error: $dbh->errstr";
#$dbh -> do("") or die "insert error:$dbh->errstr";
$dbh -> do("insert into tdb values({'a'});") or die "insert error:$dbh->errstr";

=head;
my $sth=$dbh->prepare("insert into tdb values(?)") or die "delete error: $dbh->errstr";

my $bdRs=$sth->bind_param(1,"\{'a'\}") or die  $dbh->errstr ."         :bind_param error\n";
print  "bdRs: $bdRs\n";

if( $bdRs == 0){
   print "undefined: $bdRs \n";
}else{
   print "define\n";
}

$sth->execute()  or die $dbh->errstr . "    :execute error\n";

$sth->finish();
=cut;

$dbh -> disconnect();
