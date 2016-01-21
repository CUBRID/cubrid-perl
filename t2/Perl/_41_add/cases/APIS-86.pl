#!perl -w

use DBI;
use Test::More;
use strict;
use DBI::Const::GetInfoType;

use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";


print "Database connection information \n\n";
my $database_version=$dbh->get_info($GetInfoType{SQL_DBMS_VER}) or die "get_info(18) error: $dbh->errstr";
print "GetInfoType{SQL_DBMS_VER} is $database_version\n";

my $SQL_SERVER_NAME=$dbh->get_info($GetInfoType{SQL_SERVER_NAME}) or die "get_info(18) error: $dbh->errstr";
print "SQL_SERVER_NAME is $SQL_SERVER_NAME\n";

my $SQL_DATA_SOURCE_NAME =$dbh->get_info($GetInfoType{SQL_DATA_SOURCE_NAME }) or die "get_info(18) error: $dbh->errstr";
print "SQL_DATA_SOURCE_NAME  is $SQL_DATA_SOURCE_NAME \n";

my $SQL_MAX_IDENTIFIER_LEN=$dbh->get_info($GetInfoType{SQL_MAX_IDENTIFIER_LEN}) or die "get_info(18) error: $dbh->errstr";
print "SQL_MAX_IDENTIFIER_LEN is $SQL_MAX_IDENTIFIER_LEN\n";

my $SQL_MAX_INDEX_SIZE =$dbh->get_info($GetInfoType{SQL_MAX_INDEX_SIZE}) or die "get_info(18) error: $dbh->errstr";
print " SQL_MAX_INDEX_SIZE  is $SQL_MAX_INDEX_SIZE \n";

=head;
my $SQL_MAX_COLUMNS_IN_TABLE=$dbh->get_info($GetInfoType{SQL_MAX_COLUMNS_IN_TABLE}) or die $dbh->errstr ."    :MAX_COLUMNS error\n";
print "SQL_MAX_COLUMNS_IN_TABLE is $SQL_MAX_COLUMNS_IN_TABLE\n";
=cut;

#head;
my $SQL_IDENTIFIER_QUOTE_CHAR =$dbh->get_info($GetInfoType{SQL_IDENTIFIER_QUOTE_CHAR}) or die $dbh->errstr .":IDENTIFIER error\n";
print "SQL_IDENTIFIER_QUOTE_CHAR  is $SQL_IDENTIFIER_QUOTE_CHAR \n";
#=cut;


my $SQL_CATALOG_NAME_SEPARATOR =$dbh->get_info($GetInfoType{SQL_CATALOG_NAME_SEPARATOR}) or die $dbh->errstr .":CATALOG_NAME error\n";
print "SQL_CATALOG_NAME_SEPARATOR  is $SQL_CATALOG_NAME_SEPARATOR \n";


my $SQL_CATALOG_LOCATION =$dbh->get_info($GetInfoType{SQL_CATALOG_LOCATION}) or die $dbh->errstr .":CATALOG_LOCATION error\n";
print "SQL_CATALOG_LOCATION  is $SQL_CATALOG_LOCATION\n";






$dbh->disconnect();






