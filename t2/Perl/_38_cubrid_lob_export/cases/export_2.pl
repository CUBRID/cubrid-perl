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
$dbh -> do("drop table if EXISTS image_t;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE image_t (image_id VARCHAR(36) PRIMARY KEY, doc_id VARCHAR(64) NOT NULL, image BLOB);") or die "create error:  $dbh->errstr";
$dbh->do("INSERT INTO image_t VALUES ('image-0', 'doc-0', BIT_TO_BLOB(X'000001'));") or die "insert error: $dbh->errstr";

my $sth=$dbh->prepare("select  * from image_t") or die "prepare error: $dbh->errstr";
$sth->execute() or die  $dbh->errstr. "  execute error\n";

my  $value=$sth->cubrid_lob_get(3) or die $dbh->errstr ."  lob_get error\n";# fetch the second column
print "value: $value\n";

my $export=$sth->cubrid_lob_export(3,"null1.txt");# or die $dbh->errstr ."   cubrid_lob_export error\n";

my $err=$dbh->errstr; 
if($err){
   print "$err\n";
}else{
   print "no errror\n";
}


my $closeValue=$sth->cubrid_lob_close();
print "closeValue: $closeValue\n";



$sth->finish();
$dbh -> disconnect();



