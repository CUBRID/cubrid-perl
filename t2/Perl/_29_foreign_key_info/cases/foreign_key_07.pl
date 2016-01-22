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
$dbh->do("drop table if EXISTS album_07;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE album_07(id CHAR(10) primary key,title VARCHAR(100), artist VARCHAR(100));") or die $dbh->errstr . " : create error\n";
$dbh->do("CREATE TABLE track(album_07 CHAR(10),dsk INTEGER,posn INTEGER, song VARCHAR(255),FOREIGN KEY (album_07) REFERENCES album_07(id));") or die $dbh->errstr . " : create error\n";


my $sth=$dbh->foreign_key_info('','','this_table_no_exist','','','') or die $dbh->errstr . "   :foreign_key error\n";
is(my @row =$sth->fetchrow_array(),0,"foreign_key_info ok");

$dbh->do("drop table if EXISTS track;") or die $dbh->errstr  ."  :drop error\n"; 
$dbh->do("drop table if EXISTS album_07;") or die $dbh->errstr  ."  :drop error\n";
done_testing();

$sth->finish();
$dbh->disconnect();

