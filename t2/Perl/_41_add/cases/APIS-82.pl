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
$dbh->do("drop table if EXISTS b_tbl;") or die $dbh->errstr . "  :drop error\n";
$dbh->do("drop table if EXISTS a_tbl;") or die  $dbh->errstr . "  :drop error\n";

$dbh->do("CREATE TABLE a_tbl(id INT NOT NULL DEFAULT 0 PRIMARY KEY,phone VARCHAR(10));") or die $dbh->errstr . " : create error\n";
$dbh->do("CREATE TABLE b_tbl(ID INT ,name VARCHAR(10), CONSTRAINT fk_id FOREIGN KEY(id) REFERENCES a_tbl(id) ON DELETE SET NULL);") or die $dbh->errstr . " : create error\n";


print "##########################################\n";

my $sth=$dbh->foreign_key_info('','','','','','b_tbl') or die $dbh->errstr . "   :foreign_key error\n";
while(my @row =$sth->fetchrow_array()){
   my $length=@row;
   
   print "PKTABLE_NAME: $row[2]\n";
   print "PKCOLUMN_NAME: $row[3]\n";
   print "FKTABLE_CAT: $row[4]\n";
   print "FKTABLE_NAME : $row[6]\n";
   print "FKCOLUMN_NAME: $row[7]\n";
   print "KEY_SEQ: $row[8]\n";
   print "UPDATE_RULE: $row[9]\n";
   print "DELETE_RULE: $row[10]\n";
   print "FK_NAME: $row[11]\n";
   print "PK_NAME: $row[12]\n";
   print "DEFERRABILITY: $row[13]\n";
   #print "DEFERRABILITY: $row[]\n";
   print "UNIQUE_OR_PRIMARY : $row[14]\n\n\n\n";
}



$sth->finish();
$dbh->disconnect();
