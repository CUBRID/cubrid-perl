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
$dbh->do("CREATE TABLE b_tbl(ID INT NOT NULL,name VARCHAR(10) NOT NULL,CONSTRAINT pk_id PRIMARY KEY(id), CONSTRAINT fk_id FOREIGN KEY(id) REFERENCES a_tbl(id) ON DELETE CASCADE ON UPDATE RESTRICT);") or die $dbh->errstr . " : create error\n";

my @values1=(undef,undef,"b_tbl","id",1,"pk_id");
my @values2=("a_tbl","id","","b_tbl","id",1,1,"fk_id","pk_a_tbl_id",undef,undef);
my $sth2=$dbh->primary_key_info(undef,undef,'b_tbl') or die "primary_key_info error: $dbh->errstr";

my $all_ref2 =$sth2->fetchall_arrayref() or die "all_ref error: $dbh->errstr";
my($i,$j);
for $i(0 .. $#{$all_ref2}){
   for $j(0 .. $#{$all_ref2->[$i]}){
      is($all_ref2->[$i][$j],$values1[$j],"foreign_key_info ok");
      $j++ ;
   }
   $i++;
}

print "##########################################\n";
my $j=0;
my $sth=$dbh->foreign_key_info('','','','','','b_tbl') or die $dbh->errstr . "   :foreign_key error\n";
while(my @row =$sth->fetchrow_array()){
   my $length=@row;
   is($row[2],$values2[$j++],"foreign_key_info ok");
   is($row[3],$values2[$j++],"foreign_key_info ok");
   is($row[4],$values2[$j++],"foreign_key_info ok");
   is($row[6],$values2[$j++],"foreign_key_info ok");
   is($row[7],$values2[$j++],"foreign_key_info ok");
   is($row[8],$values2[$j++],"foreign_key_info ok");
   is($row[9],$values2[$j++],"foreign_key_info ok");
   is($row[11],$values2[$j++],"foreign_key_info ok");
   is($row[12],$values2[$j++],"foreign_key_info ok");
   is($row[13],$values2[$j++],"foreign_key_info ok");
   is($row[14],$values2[$j++],"foreign_key_info ok");
}
done_testing();
$dbh->do("drop table if EXISTS b_tbl;") or die $dbh->errstr . "  :drop error\n";
$dbh->do("drop table if EXISTS a_tbl;") or die  $dbh->errstr . "  :drop error\n";

$sth->finish();
$dbh->disconnect();

