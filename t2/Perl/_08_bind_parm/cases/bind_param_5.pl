#!perl -w 

use DBI;
use Test::More;
use DBI qw(:sql_types);
use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect err: $dbh->errstr";

$dbh -> do("drop table if EXISTS image_t;") or die "drop error: $dbh->errstr";
$dbh -> do("CREATE TABLE image_t (doc_id VARCHAR(64) PRIMARY KEY, image BLOB);") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("insert into image_t values(?,?);") or die "delete error: $dbh->errstr";

my $bdRs1=$sth->bind_param(1,'id1') or die "bind_param error: $dbh->errstr";
my $bdRs2=$sth->bind_param(2,"BIT_TO_BLOB(X'000010')",SQL_BLOB) or die "bind_param error: $dbh->errstr";

print  "bdRs: $bdRs1\t  $bdRs2\n";

is($bdRs1,1,"bind 1 ok");
is($bdRs2,1,"bind 2 ok");
=head;
if( $bdRs == 0){
   print "undefined: $bdRs \n";
}else{
   print "define\n";
}
=cut;

$sth->execute() or die "execute error: $dbh->errstr";
done_testing();
$sth->finish();
$dbh -> disconnect();
