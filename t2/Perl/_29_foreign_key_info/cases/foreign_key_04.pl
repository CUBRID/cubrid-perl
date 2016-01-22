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
$dbh->do("drop table if EXISTS track;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS album_04;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE album_04(id CHAR(10) primary key,title VARCHAR(100), artist VARCHAR(100));") or die $dbh->errstr . " : create error\n";
$dbh->do("CREATE TABLE track(album_04 VARCHAR(10),dsk INTEGER,posn INTEGER, song VARCHAR(255),FOREIGN KEY (album_04) REFERENCES album_04(id));");
# or die $dbh->errstr . " : create error\n";

my $expected="CUBRID DBMS Error : (-921) The domain of the foreign key member 'album_04' is different from that of the primary key member 'id'.";
my $errCreat=$dbh->errstr;
is($errCreat,$expected,"foreign_key_info ok");

done_testing();

$dbh->do("drop table if EXISTS album_04;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS track;") or die "drop error: $dbh->errstr";


$dbh->disconnect();

