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

my $dsn="dbi:cubrid:database=demodb;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

my $sth=$dbh->prepare("select * from db_class") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";
my $fieldNumber=$sth->{NUM_OF_FIELDS};

my @name=("class_name","owner_name","class_type","is_system_class","partitioned","is_reuse_oid_class");
my @type=(2,2,2,2,2,2);
my $i=0;
for (my $i=0;$i<$fieldNumber; $i++){
   is($sth->{NAME}->[$i],$name[$i],"NUM_OF_FIELDS ok");
   is($sth->{TYPE}->[$i],$type[$i],"NUM_OF_FIELDS ok");
}

done_testing();
$sth->finish();
$dbh -> disconnect();



