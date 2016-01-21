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
$dbh->do("drop table if EXISTS album;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE album(id CHAR(10) primary key,title VARCHAR(100), artist VARCHAR(100));") or die $dbh->errstr . " : create error\n";
$dbh->do("CREATE TABLE track(album CHAR(10),dsk INTEGER,posn INTEGER, song VARCHAR(255),FOREIGN KEY (album) REFERENCES album(id));") or die $dbh->errstr . " : create error\n";

my $sth=$dbh->foreign_key_info('','','album');# or die $dbh->errstr . "   :foreign_key error\n";

my $err= $dbh->errstr;
print $err ."\n";
if($err){
   print "##################ERROR#####################\n";
   print "$err\n";
}else{
   print "no error\n";
}



while(my @row =$sth->fetchrow_array()){
   my $length=@row;
   
   print "PKTABLE_NAME: $row[2]\n";
   print "PKCOLUMN_NAME: $row[3]\n";
   print "FKTABLE_CAT: $row[4]\n";
   print "FKTABLE_NAME : $row[6]\n";
   print "FKCOLUMN_NAME: $row[7]\n";
   print "KEY_SEQ: $row[8]\n";
   print "UPDATE_RULE: $row[9]\n";
   print "FK_NAME: $row[11]\n";
   print "PK_NAME: $row[12]\n";
   print "DEFERRABILITY: $row[13]\n";
   print "UNIQUE_OR_PRIMARY : $row[14]\n\n\n\n";
}

#$dbh->do("drop table if EXISTS album;") or die "drop error: $dbh->errstr";
#$dbh->do("drop table if EXISTS track;") or die "drop error: $dbh->errstr";


$sth->finish();
$dbh->disconnect();

