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
$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb (id int NOT NULL PRIMARY KEY,bigint_c bigint, bit_c bit, blob_c blob,clob_c clob, float_c float, monetery_t monetary,smallint_c smallint, date_c date, time_c time, datetime_c datetime, decimal_c decimal(15,3),varchar_c varchar(15),bitvarying_c bit varying, charactervarying_c character varying, double_c double,  multiset_c multiset(int,char(1)), nation_c national character);") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("select * from tdb") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";
my $fieldNumber=$sth->{NUM_OF_FIELDS};
print "Number of field is $fieldNumber\n";

my @values=("id",8,"bigint_c",21,"bit_c",5,"blob_c",23,"clob_c",24,"float_c",11,"monetery_t",10,"smallint_c",9,"date_c",13,"time_c",14,"datetime_c",22,"decimal_c",7,"varchar_c",2,"bitvarying_c",6,"charactervarying_c",2,"double_c",12,"multiset_c",64,"nation_c", 3);
my $j=0;
for (my $i=0;$i<$fieldNumber; $i++){
   is($sth->{NAME}->[$i],$values[$j++],"NUM_OF_FIELDS ok");
   is($sth->{TYPE}->[$i],$values[$j++],"NUM_OF_FIELDS ok");
}
done_testing();
$sth->finish();
$dbh -> disconnect();



