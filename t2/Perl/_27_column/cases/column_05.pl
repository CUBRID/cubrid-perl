#!perl -w

use DBI;
use Test::More;
use DBI qw(:sql_types);
#use strict;

use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";
$dbh -> do("drop table if EXISTS atype;") or die  $dbh->errstr ."   :drop error\n";
$dbh -> do("create table atype(vc varchar(10), nch  nchar(53), nchvar   nchar varying(53),b bit(1), bvar bit varying(3) );") or die $dbh->errstr . "  :create error\n";

my $sth=$dbh->column_info(undef,undef,'atype','%') or die "column_info error: $dbh->errstr";
while(my $hash_ref=$sth->fetchrow_hashref()){
   is($hash_ref->{DECIMAL_DIGITS},undef,"column_info ok");

}
done_testing();
$sth->finish();
$dbh->disconnect();

