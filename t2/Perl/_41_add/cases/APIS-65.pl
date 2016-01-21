#!perl -w

use DBI;
use Test::More;
use DBI qw(:sql_types);
#use strict;

use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

my %map;
foreach(@{$DBI::EXPORT_TAGS{sql_types}}){
   $map{&{"DBI::$_"}}=$_;
}

$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb (dc decimal(5,2),vc varchar(15),c char(10),it int,bl blob, dt date, dtt datetime,db double);") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("select * from tdb where 1=0;");
$sth->execute;

my $fields=$sth->{NAME};
my $types=$sth->{TYPE};
print "fields: $fields \t types:$types\n\n";

foreach(0 .. $#$fields){
   printf("%8s  %3d %s\n", $fields->[$_],$types->[$_],$map{$types->[$_]});
}


$sth->finish();
$dbh->disconnect();

