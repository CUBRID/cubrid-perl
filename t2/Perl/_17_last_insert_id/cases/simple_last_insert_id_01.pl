#!perl -w

use DBI;
use Test::More;
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
$dbh->do("drop table if EXISTS ss;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE ss (id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, text VARCHAR(32));") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("INSERT into ss VALUES(NULL,?);") or die "insert error: $dbh->errstrt";
$sth->execute('cubrid') or die "execute error: $dbh->errstr";
my $id=$dbh->last_insert_id(undef,undef,ss,undef) or die "last_insert_id error: $dbh->errstr";
#print "last_insert_id is $id\n";

plan tests=>1;
ok($id == 1, "last_insert_id ok");
$sth->finish();
$dbh->disconnect();


