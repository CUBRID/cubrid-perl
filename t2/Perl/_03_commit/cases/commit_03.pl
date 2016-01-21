#!perl -w

use DBI;
use Test::More;
use strict;

use vars qw($port $hostname);

my $db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1, AutoCommit => 0}) or die "connect error: $dbh->errstr";
$dbh->do("drop table if EXISTS a") or die "drop error: $dbh->errstr";
$dbh -> do("create table a(name CHARACTER VARYING(1073741823), id int, pwd db_password, drg  SET OF db_user, gr  SET OF db_user, au db_authorization, tr SEQUENCE OF object);") or die "create error: $dbh->errstr";

my $sql= "select * from db_user";
my $sql2 = "insert into a values (?,?,?,?,?,?,?)";
my $sth=$dbh->prepare($sql) or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute select: $dbh->errstr\n";

$dbh->{PrintError}=1;
$dbh->{RaiseError}=0;
while(my $row_ref =$sth->fetchrow_arrayref()){
   my $req=$dbh->prepare($sql2) ;
   $req->bind_param(1,$row_ref->[0]) or die "bind error: $dbh->errstr";
   $req->bind_param(2,$row_ref->[1]) or die "bind error: $dbh->errstr";
   $req->bind_param(3,$row_ref->[2]) or die "bind error: $dbh->errstr";
   $req->bind_param(4,$row_ref->[3]) or die "bind error: $dbh->errstr";
   $req->bind_param(5,$row_ref->[4]) or die "bind error: $dbh->errstr";
   $req->bind_param(6,$row_ref->[5]) or die "bind error: $dbh->errstr";
   $req->bind_param(7,$row_ref->[6]) or die "bind error: $dbh->errstr";
   $req->execute;# or die "execute sql2: $dbh->errstr";
   like($DBI::errstr,qr/Cannot coerce host var to type object/,"error coerce to object"); 
   $req->finish();
}

$sth->finish();
$dbh -> disconnect();



