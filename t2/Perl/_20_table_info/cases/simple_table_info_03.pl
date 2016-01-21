#!perl -w

use DBI;
use Test::More;
use strict;

use vars qw($db $port $hostname); 

#####create view#####

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


my $sth=$dbh->table_info('','','%');
my $table_counter=0;
my $true1=0;
my $true2=0;
while (my  @row=$sth->fetchrow_array()){
   my $catalog=$row[0];
   my $schema=$row[1];
   my $table=$row[2];
   if($table eq 'a_tbl'){
      $true1=1;
   }
   if($table eq 'b_view'){
      $true2=1;
   }

   $table_counter++;
   printf("Table %d %s \n", $table_counter,$table );
}
#print "true1: $true1\t true2: $true2\n";

plan tests=>2;
ok($true1 eq 1, "table_info ok");
ok($true2 eq 1, "table_info ok");

$dbh->do("drop table if EXISTS a_tbl;") or die "drop error: $dbh->errstr";
$dbh->do("drop view b_view;") or die "drop error: $dbh->errstr";

$sth->finish;
$dbh->disconnect();

