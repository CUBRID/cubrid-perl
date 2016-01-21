#!perl -w

use DBI;
use DBD::cubrid;
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
##############################################
my $statement1="select BIT_LENGTH('CUBRID');";
my $sth=$dbh->prepare($statement1) or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref1 =$sth->fetchrow_arrayref();
my $value1=$row_ref1->[0];
ok($value1 eq 48 , "value1 ok");
#print "row_ref1 is $row_ref1->[0]\n ";
$sth->finish();

my $statement2="select BIT_LENGTH(B'010101010');";
my $sth=$dbh->prepare($statement2) or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref2 =$sth->fetchrow_arrayref();
my $value2=$row_ref2->[0];
ok($value2 eq 9 , "value2 ok");
#print "row_ref2 is $row_ref2->[0]\n ";
$sth->finish();

##############################################
my $sth=$dbh->prepare("SELECT LENGTH('');") or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref3 =$sth->fetchrow_arrayref();
my $value3=$row_ref3->[0];
ok($value3 eq 0 , "value3 ok");
#print "row_ref3 is $row_ref3->[0]\n ";
$sth->finish();

##############################################
my $sth=$dbh->prepare("SELECT CHR(68) || CHR(68-2);") or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref4 =$sth->fetchrow_arrayref();
my $value4=$row_ref4->[0];
ok($value4 eq 'DB' , "value4 ok");
#print "row_ref4 is $row_ref4->[0]\n ";
$sth->finish();

##############################################
my $sth=$dbh->prepare("SELECT CONCAT('CUBRID', '2008' , 'R3.0',NULL)")  or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref5 =$sth->fetchrow_arrayref();
my $value5=$row_ref5->[0];
ok(!$value5 , "value5 ok");
#print "row_ref5 is $row_ref5->[0]\n ";
$sth->finish();

##############################################
my $sth=$dbh->prepare("SELECT INSTR ('12345abcdeabcde','b', -1);")  or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref6 =$sth->fetchrow_arrayref();
my $value6=$row_ref6->[0];
ok($value6 eq 12 , "value6 ok");
#print "row_ref6 is $row_ref6->[0]\n";
$sth->finish();



$dbh -> disconnect();



