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

$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb(id int, name char(20));") or die "create error: $dbh->errstr";
$dbh -> do("insert into tdb values(1,'Johny'),(2,'lisi'),(3,'wangwu'),(4,'mazi');") or die "insert error:$dbh->errstr";

my $sth=$dbh->prepare("select id,name from tdb") or die "delete error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";

ok($sth->bind_col(1, \$title),"bind_col ok");
ok($sth->bind_col(2, \$author),"bind_col ok");
while($sth->fetch( )) {

   print "$title by $author \n";

}
done_testing();
$sth->finish();
$dbh -> disconnect();
