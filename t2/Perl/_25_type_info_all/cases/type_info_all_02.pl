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

my @type=@{$dbh->type_info_all()};
print \@type;
print "\n";
my $length=@type;
print "length: $length\n";


my $sql=$type[0]->{DATA_TYPE};
my $name=$type[0]->{TYPE_NAME};
my $columnsize=$type[0]->{COLUMN_SIZE};
my $SQL_DATA_TYPE=$type[0]->{SQL_DATA_TYPE};
my $SQL_DATETIME_SUB=$type[0]->{SQL_DATETIME_SUB};
my $MAXIMUM_SCALE=$type[0]->{MAXIMUM_SCALE};

my @values=([1,"CHAR",1073741823,1,-1,"CHAR"],
[12,"VARCHAR",1073741823,12,-1,"VARCHAR"],
[-2,"BIT",134217727.875,-2,-1,"BIT"],
[-3,"BIT VARYING",134217727.875,-3,-1,"BIT VARYING"],
[2,"NUMERIC",38,2,38,"NUMERIC"],
[3,"DECIMAL",38,3,38,"DECIMAL"],
[4,"INTEGER",10,4,-1,"INTEGER"],
[5,"SMALLINT",5,5,-1,"SMALLINT"],
[7,"REAL",14,7,-1,"REAL"],
[6,"FLOAT",14,6,-1,"FLOAT"],
[8,"DOUBLE",28,8,-1,"DOUBLE"],
[91,"DATE",10,9,-1,"DATE"],
[92,"TIME",8,9,-1,"TIME"],
[93,"TIMESTAMP",19,9,-1,"TIMESTAMP"],
[-5,"BIGINT",19,4,-1,"BIGINT"],
[93,"DATETIME",23,9,-1,"DATETIME"],
[30,"BLOB",0,30,-1,"BLOB"],
[40,"CLOB",0,40,-1,"CLOB"]
);
my $i=0;
foreach my $type2 (@type[1 .. $#type]){
   my $j=0;
   is($type2->[$sql],$values[$i][$j++],"type_info_all ok");
   is($type2->[$name],$values[$i][$j++],"type_info_all ok");
   #is($type2->[$cubrid],$values[$i][$j++],"type_info_all ok");
   is($type2->[$columnsize],$values[$i][$j++],"type_info_all ok");
   is($type2->[$SQL_DATA_TYPE],$values[$i][$j++],"type_info_all ok");
   is($type2->[$MAXIMUM_SCALE],$values[$i][$j++],"type_info_all ok");
   is($type2->[$cubrid],$values[$i][$j++],"type_info_all ok");
   $i++;
}

done_testing();
$dbh->disconnect();





