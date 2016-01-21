#!perl -w

use DBI;
use Test::More;
#use strict;

use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV1[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";
$dbh->do("drop table if EXISTS ss;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE ss (id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, text VARCHAR(32));") or die "create error: $dbh->errstr";

$dbh->do("INSERT into ss VALUES(NULL,'cubrid');") or die "insert error: $dbh->errstrt";
my $id1=$dbh->last_insert_id(undef,undef,'ss',id) or die "last_insert_id error: $dbh->errstr";
#print "last_insert_id is $id1\n";

$dbh->do("INSERT into ss VALUES(NULL,'BBB'),(NULL,'Mysql');") or die "insert error: $dbh->errstrt";
my $id2=$dbh->last_insert_id(undef,undef,'ss',id) or die "last_insert_id error: $dbh->errstr";
#print "last_insert_id is $id2\n";

plan tests=>2;
ok($id1 == 1, "last_insert_id ok");
ok($id2 == 2, "last_insert_id ok");
$dbh->disconnect();


