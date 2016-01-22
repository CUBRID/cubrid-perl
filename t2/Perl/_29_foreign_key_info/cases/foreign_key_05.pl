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
$dbh->do("drop table if EXISTS album_05;") or die  $dbh->errstr . "  :drop error\n";


$dbh->do("CREATE TABLE album_05(id CHAR(10) primary key,title VARCHAR(100), artist VARCHAR(100));") or die $dbh->errstr . " : create error\n";
$dbh->do("CREATE TABLE aaaa(aid CHAR(10), uid int primary key);") or die $dbh->errstr . " :create error \n";


$dbh->do("CREATE TABLE ssss(album_05 CHAR(10),dsk INTEGER,FOREIGN KEY (album_05) REFERENCES album_05(id), FOREIGN KEY (dsk) REFERENCES aaaa(uid));") or die $dbh->errstr . " : create error\n";
my $sth=$dbh->foreign_key_info('','','','','','ssss') or die $dbh->errstr . "   :foreign_key error\n";
my @values=("aaaa","uid","","ssss","dsk",1,1,1,"fk_ssss_dsk","pk_aaaa_uid",undef,undef,
"album_05","id","","ssss","album_05",1,1,1,"fk_ssss_album_05","pk_album_05_id",undef,undef);

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
$dbh->do("drop table if EXISTS album_05;") or die  $dbh->errstr . "  :drop error\n";
done_testing();

$sth->finish();
$dbh->disconnect();

