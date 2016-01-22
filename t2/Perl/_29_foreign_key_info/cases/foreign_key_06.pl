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
$dbh->do("drop table if EXISTS ssss;") or die $dbh->errstr . "  :drop error\n";
$dbh->do("drop table if EXISTS aaaa;") or die $dbh->errstr . "  :drop error\n";
$dbh->do("drop table if EXISTS album_06;") or die  $dbh->errstr . "  :drop error\n";


$dbh->do("CREATE TABLE album_06(id CHAR(10) primary key,title VARCHAR(100), artist VARCHAR(100));") or die $dbh->errstr . " : create error\n";
$dbh->do("CREATE TABLE aaaa(aid CHAR(10),FOREIGN KEY (aid) REFERENCES album_06(id));") or die $dbh->errstr . " :create error \n";


$dbh->do("CREATE TABLE ssss(album_06 CHAR(10),dsk INTEGER,posn INTEGER, song VARCHAR(255),FOREIGN KEY (album_06) REFERENCES album_06(id));") or die $dbh->errstr . " : create error\n";
my $sth=$dbh->foreign_key_info('','','album_06','','','') or die $dbh->errstr . "   :foreign_key error\n";

my @values=("album_06","id","","aaaa","aid",1,1,1,"fk_aaaa_aid","pk_album_06_id",undef,undef,
"album_06","id","","ssss","album_06",1,1,1,"fk_ssss_album_06","pk_album_06_id",undef,undef);
my $j=0;
while(my @row =$sth->fetchrow_array()){
   my $length=@row;
   is($row[2],$values[$j++],"foreign_key_info ok");
   is($row[3],$values[$j++],"foreign_key_info ok");
   is($row[4],$values[$j++],"foreign_key_info ok");
   is($row[6],$values[$j++],"foreign_key_info ok");
   is($row[7],$values[$j++],"foreign_key_info ok");
   is($row[8],$values[$j++],"foreign_key_info ok");
   is($row[9],$values[$j++],"foreign_key_info ok");
   is($row[10],$values[$j++],"foreign_key_info ok");
   is($row[11],$values[$j++],"foreign_key_info ok");
   is($row[12],$values[$j++],"foreign_key_info ok");
   is($row[13],$values[$j++],"foreign_key_info ok");
   is($row[14],$values[$j++],"foreign_key_info ok");
}

$dbh->do("drop table if EXISTS ssss;") or die $dbh->errstr . "  :drop error\n";
$dbh->do("drop table if EXISTS aaaa;") or die $dbh->errstr . "  :drop error\n";
$dbh->do("drop table if EXISTS album_06;") or die  $dbh->errstr . "  :drop error\n";
done_testing();

$sth->finish();
$dbh->disconnect();

