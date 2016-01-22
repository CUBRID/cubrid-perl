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
my $cubrid=$type[0]->{cubrid_native_type};

my @values=([1,"CHAR","CHAR"],
[12,"VARCHAR","VARCHAR"],
[-2,"BIT","BIT"],
[-3,"BIT VARYING","BIT VARYING"],
[2,"NUMERIC","NUMERIC"],
[3,"DECIMAL","DECIMAL"],
[4,"INTEGER","INTEGER"],
[5,"SMALLINT","SMALLINT"],
[7,"REAL","REAL"],
[6,"FLOAT","FLOAT"],
[8,"DOUBLE","DOUBLE"],
[91,"DATE","DATE"],
[92,"TIME","TIME"],
[93,"TIMESTAMP","TIMESTAMP"],
[-5,"BIGINT","BIGINT"],
[93,"DATETIME","DATETIME"],
[12,"ENUM","ENUM"],
[30,"BLOB","BLOB"],
[40,"CLOB","CLOB"]
);
my $i=0;
foreach my $type2 (@type[1 .. $#type]){
   my $j=0;  
   is($type2->[$sql],$values[$i][$j++],"type_info_all ok");
   is($type2->[$name],$values[$i][$j++],"type_info_all ok");
   is($type2->[$cubrid],$values[$i][$j++],"type_info_all ok"); 
   print "\n";
   $i++
}
done_testing();

$dbh->disconnect();





