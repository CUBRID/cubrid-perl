#!perl -w

use DBI;
use Test::More;
use strict;
use DBI::Const::GetInfoType;

use vars qw($db $port $hostname $version); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
#$version=$ARGV[3];
$version=`perldoc -m  DBD::cubrid | grep "VERSION =" | awk -F '=' '{print $2}'`;
#print "version: ".$version;
$version=substr($version, 16, length($version)-19);
#print "version: ".$version;

my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";


my @values=($version,"pldb","dbi:cubrid:pldb",64,500,"\"",".",1,"CUBRID",$version);
my $i=0;
print "Database connection information \n\n";
my $database_version=$dbh->get_info($GetInfoType{SQL_DBMS_VER}) or die "get_info(18) error: $dbh->errstr";
is($database_version,$values[$i++],"get_info ok");

my $SQL_SERVER_NAME=$dbh->get_info($GetInfoType{SQL_SERVER_NAME}) or die "get_info(18) error: $dbh->errstr";
is($SQL_SERVER_NAME,$values[$i++],"get_info ok");

my $SQL_DATA_SOURCE_NAME =$dbh->get_info($GetInfoType{SQL_DATA_SOURCE_NAME }) or die "get_info(18) error: $dbh->errstr";
is($SQL_DATA_SOURCE_NAME,$values[$i++],"get_info ok");

my $SQL_MAX_IDENTIFIER_LEN=$dbh->get_info($GetInfoType{SQL_MAX_IDENTIFIER_LEN}) or die "get_info(18) error: $dbh->errstr";
is($SQL_MAX_IDENTIFIER_LEN,$values[$i++],"get_info ok");

my $SQL_MAX_INDEX_SIZE =$dbh->get_info($GetInfoType{SQL_MAX_INDEX_SIZE}) or die "get_info(18) error: $dbh->errstr";
is($SQL_MAX_INDEX_SIZE,$values[$i++],"get_info ok");

my $SQL_IDENTIFIER_QUOTE_CHAR =$dbh->get_info($GetInfoType{SQL_IDENTIFIER_QUOTE_CHAR}) or die $dbh->errstr .":IDENTIFIER error\n";
is($SQL_IDENTIFIER_QUOTE_CHAR,$values[$i++],"get_info ok");

my $SQL_CATALOG_NAME_SEPARATOR =$dbh->get_info($GetInfoType{SQL_CATALOG_NAME_SEPARATOR}) or die $dbh->errstr .":CATALOG_NAME error\n";
is($SQL_CATALOG_NAME_SEPARATOR,$values[$i++],"get_info ok");


my $SQL_CATALOG_LOCATION =$dbh->get_info($GetInfoType{SQL_CATALOG_LOCATION}) or die $dbh->errstr .":CATALOG_LOCATION error\n";
is($SQL_CATALOG_LOCATION,$values[$i++],"get_info ok");

my $SQL_DBMS_NAME =$dbh->get_info($GetInfoType{SQL_DBMS_NAME}) or die $dbh->errstr .":CATALOG_LOCATION error\n";
is($SQL_DBMS_NAME,$values[$i++],"get_info ok");

my $SQL_DBMS_VER =$dbh->get_info($GetInfoType{SQL_DBMS_VER}) or die $dbh->errstr .":CATALOG_LOCATION error\n";
is($SQL_DBMS_VER,$values[$i++],"get_info ok");

done_testing();

$dbh->disconnect();




