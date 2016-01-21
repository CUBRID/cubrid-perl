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


$dbh->do("DROP TABLE IF EXISTS bug26786");
$dbh->do("CREATE TABLE bug26786 (user_id integer primary key, group_id integer, index(group_id))");

my $sth = $dbh->primary_key_info( undef, undef, 'bug26786' );
my $rows = $sth->fetchall_arrayref({});
while(my $row = (shift(@$rows))) {
    is($row->{PK_NAME},"pk_bug26786_user_id","primary_key_info ok");
    is($row->{TABLE_NAME},"bug26786","primary_key_info ok");
    is($row->{COLUMN_NAME},"user_id","primary_key_info ok");
}
done_testing();

$sth->finish();
$dbh->disconnect();





