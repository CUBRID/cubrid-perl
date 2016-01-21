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

$dbh->do("drop table if EXISTS aaa;") or die "drop error: $dbh->errstr";
#$dbh->do("drop view aaa_view;") or die "drop error: $dbh->errstr";

$dbh->do("CREATE TABLE aaa(id INT NOT NULL,phone VARCHAR(10));") or die "create error: $dbh->errstr";
$dbh->do("INSERT INTO aaa VALUES(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, NULL), (5, NULL);") or die "insert error: $dbh->errstr ";
$dbh->do("CREATE VIEW aaa_view AS SELECT * FROM aaa WHERE phone IS NOT NULL WITH CHECK OPTION;") or die "create view error: $dbh->errstr";


my $sth=$dbh->table_info('','','aaa%','nothistype')   or die $dbh->errstr ."  :table_info error\n";
my $table_counter=1;
my $true1=0;
my $true2=0;
while (my  @row=$sth->fetchrow_array()){
   my $catalog=$row[0];
   my $schema=$row[1];
   my $table=$row[2];
   my $type=$row[3];
   my $remarks=$row[4];
   printf("TableName: %d %s \t", $table_counter,$table );
   printf("TableType: %s \t", $type );
   printf("Schema: %s \t", $schema );
   printf("Catalog: %s \t", $catalog );
   printf("Remarks: %s \t", $remarks);
   print "\n\n\n";

   $table_counter++;

}


$dbh->do("drop view aaa_view;") or die "drop error: $dbh->errstr";

$sth->finish;
$dbh->disconnect();

