#!perl -w

use DBI;
use Test::More;
#use strict;
#use warnings;

use DBI qw(:sql_types); 


$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

my $type=$dbh->type_info_all();
my @values=(["CHAR",1,1073741823,"'","'","length",1,0,3,-1,0,0,"CHAR",-1,-1],
["VARCHAR",12,1073741823,"'","'","length",1,0,3,-1,0,0,"CHAR VARYING",-1,-1],
["BIT",-2,134217727.875,"X'","'","length",1,0,3,-1,0,0,"BIT",-1,-1],
["BIT VARYING",-3,134217727.875,"X'","'","length",1,0,3,-1,0,0,"BIT VARYING",-1,-1],
["NUMERIC",2,38,,undef,undef,"precision, scale",1,0,2,0,0,0,"NUMERIC",0,38],
["DECIMAL",3,38,undef,undef,"precision, scale",1,0,2,0,0,0,"DECIMAL",0,38],
["INTEGER",4,10,undef,undef,undef,1,0,2,0,0,0,"INTEGER",-1,-1],
["SMALLINT",5,5,undef,undef,undef,1,0,2,0,0,0,"SMALLINT",-1,-1],
["REAL",7,14,undef,undef,"precision",1,0,2,0,0,0,"REAL",-1,-1],
["FLOAT",6,14,undef,undef,"precision",1,0,2,0,0,0,"FLOAT",-1,-1],
["DOUBLE",8,28,undef,undef,"precision",1,0,2,0,0,0,"DOUBLE",-1,-1],
["DATE",91,10,"DATE '","'",undef,1,0,2,0,0,0,"DATE",-1,-1],
["TIME",92,8,"TIME '","'",undef,1,0,2,0,0,0,"TIME",-1,-1],
["TIMESTAMP",93,19,"TIMESTAMP '","'",undef,1,0,2,0,0,0,"TIMESTAMP",-1,-1],
["BIGINT",-5,19,undef,undef,undef,1,0,2,0,0,0,"BIGINT",-1,-1],
["DATETIME",93,23,"DATETIME '","'",undef,1,0,2,0,0,0,"DATETIME",-1,-1],
["BLOB",30,0,undef,undef,undef,1,0,3,0,0,0,"BLOB",-1,-1],
["CLOB",40,0,undef,undef,undef,1,0,3,0,0,0,"CLOB",-1,-1]
);
=zhushi
for(my $i=1;$i<18;$i++){
   print $i .":   \n";
   for(my $j=0;$j<15;$j++){
      print $type->[$i][$j] ."\t"; 
   }
   print "\n\n\n";
}
=cut
my $k=0;
for(my $i=1;$i<19;$i++){
   my $g=0;
   print $i .":   \n";
   for(my $j=0;$j<15;$j++){
      is($type->[$i][$j],$values[$k][$g++],"type_info_all ok"); 
   }
   $k++;
   print "\n";
}

done_testing();
$dbh->disconnect();





