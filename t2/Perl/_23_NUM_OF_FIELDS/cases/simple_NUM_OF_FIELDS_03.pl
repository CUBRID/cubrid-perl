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
$dbh -> do("drop table if EXISTS coo;") or die "drop error: $dbh->errstr";
$dbh->do("create class coo(char_c char(2), varchar_c varchar(10), bit_c bit(8), bitvarying_c bit varying(8), numeric_c numeric(13,2), decimal_c decimal(10,3), int_c int, float_c float, double_c double, date_c date, time_c time, timestamp_c timestamp, datetime_c datetime, blob_c blob, clob_c clob)" ) or die $dbh->errstr . " :create error";

my $sth=$dbh->prepare("select * from coo") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";

my @values=("char_c",1,"varchar_c",2,"bit_c",5, "bitvarying_c",6,"numeric_c",7,"decimal_c",7,"int_c",8,"float_c",11,"double_c",12,"date_c",13,"time_c",14,"timestamp_c",15,"datetime_c",22,"blob_c",23,"clob_c",24);
my $fieldNumber=$sth->{NUM_OF_FIELDS};
print "Number of field is $fieldNumber\n";
my $j=0;
for (my $i=0;$i<$fieldNumber; $i++){
   is($sth->{NAME}->[$i],$values[$j++],"NUM_OF_FIELDS ok");
   is($sth->{TYPE}->[$i],$values[$j++],"NUM_OF_FIELDS ok");
}
done_testing();

$sth->finish();
$dbh -> disconnect();



