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

plan tests=>6;

#############################################
my $statement1="select date'2002-01-01' - datetime'2001-02-02 12:00:00 am';";
my $sth=$dbh->prepare($statement1) or die "prepare error: $dbh->errstr";
my $exResult1=$sth->execute or die "execute error: $dbh->errstr";
my $row_ref1 =$sth->fetchrow_arrayref();
my $value1=$row_ref1->[0];
ok($value1 eq  28771200000, "value1 ok");
#print "row_ref1 is $row_ref1->[0]\n ";
#print "exResult1: $exResult1\n";
$sth->finish();

#####################
my $sth=$dbh->prepare("SELECT date'2002-01-01' + '10';") or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref2 =$sth->fetchrow_arrayref();
my $value2=$row_ref2->[0];
ok($value2 eq '2002-01-11', "value2 ok");
#print "row_ref2 is $row_ref2->[0]\n ";
$sth->finish();

####################
my $sth=$dbh->prepare("SELECT 4 + '5.2'") or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref3 =$sth->fetchrow_arrayref();
my $value3=$row_ref3->[0];
ok($value3 eq  9.199999999999999e+00, "value3 ok");
#print "row_ref3 is $row_ref3->[0]\n ";
$sth->finish();

###################
my $sth=$dbh->prepare("SELECT DATE'2002-01-01'+1;") or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref4 =$sth->fetchrow_arrayref();
my $value4=$row_ref4->[0];
ok($value4 eq '2002-01-02' , "value4 ok");
#print "row_ref4 is $row_ref4->[0]\n ";
$sth->finish();

###################
my $sth=$dbh->prepare("SELECT '1'+'1';") or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref5 =$sth->fetchrow_arrayref();
my $value5=$row_ref5->[0];
ok($value5 eq '11' , "value5 ok");
#print "row_ref5 is $row_ref5->[0]\n ";
$sth->finish();

##################
my $sth=$dbh->prepare("SELECT '3'*'2';") or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref6 =$sth->fetchrow_arrayref();
my $value6=$row_ref6->[0];
ok($value6 eq '6' , "value6 ok");
#print "row_ref6 is $row_ref6->[0]\n ";
$sth->finish();





$dbh -> disconnect();



