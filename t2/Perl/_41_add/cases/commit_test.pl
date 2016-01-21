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

my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1, AutoCommit => 0}) or die "connect error: $dbh->errstr";
$dbh->do("drop table if EXISTS a") or die "drop error: $dbh->errstr";
$dbh -> do("create table a(id int);") or die "create error: $dbh->errstr";
$dbh->do("insert into a values(1),(2),(3),(4),(5)") or die "insert error: $dbh->errstr";
$dbh->do("drop table if EXISTS b") or die "drop error: $dbh->errstr";
$dbh -> do("create table b(bid int);") or die "create error: $dbh->errstr";

my $sql= "select * from a";
my $sql2 = "insert into b values (?)";
my $sth=$dbh->prepare($sql) or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute select: $dbh->errstr\n";

while(my $row_ref =$sth->fetchrow_arrayref()){
   my $req=$dbh->prepare($sql2) ;
   $req->bind_param(1,$row_ref->[0]) or die "bind error: $dbh->errstr";
   $req->execute or die "execute sql2: $dbh->errstr";
   #$dbh->commit or die "commit error: $dbh->errstr" ;
   $req->finish();
   
}

#$req->finish();
$sth->finish();
$dbh -> disconnect();



