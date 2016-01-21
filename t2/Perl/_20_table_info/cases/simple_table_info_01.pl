#!perl -w

use DBI;
use Test::More;
use strict;

use vars qw($db $port $hostname); 

###user can't create any table in this DB, and this DB isn't demodb#######
$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=demodb;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";


my $sth=$dbh->table_info('','','%');
my $table_counter=0;
while (my  @row=$sth->fetchrow_array()){
   my $catalog=$row[0];
   my $schema=$row[1];
   my $table=$row[2];
   $table_counter++;
   printf("Table %d %s \n", $table_counter,$table );
}

plan tests=>1;
#ok($table_counter eq 41, "table_info ok" );
$sth->finish;
$dbh->disconnect();

