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


$dbh->do("drop table if EXISTS a_tbl;") or die "drop error: $dbh->errstr";

$dbh->do("CREATE TABLE a_tbl(id INT NOT NULL,phone VARCHAR(10));") or die "create error: $dbh->errstr";
$dbh->do("INSERT INTO a_tbl VALUES(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, NULL), (5, NULL);") or die "insert error: $dbh->errstr ";
$dbh->do("CREATE VIEW b_view AS SELECT * FROM a_tbl WHERE phone IS NOT NULL WITH CHECK OPTION;") or die "create view error: $dbh->errstr";


my @tables=$dbh->tables(undef,undef,'%','VIEW');
my $counter=@tables;
is( $counter,18,"tables ok");
my $true1=0;
foreach my $table (@tables){
   if($table=="b_view"){
      $true1=1;
   }
}
is( $true1,1,"tables ok");
done_testing();

$dbh->do("drop view b_view;") or die "drop error: $dbh->errstr";

$dbh->disconnect();
