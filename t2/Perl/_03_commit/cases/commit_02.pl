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
my $user="dba";
my $pass="";

my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1, AutoCommit => 0}) or die "connect error: $dbh->errstr";

my $sql= "select * from db_user";
my $sql2 = "select * from db_class where owner_name = ?";
my $req=$dbh->prepare($sql2) or die "prepare error: $dbh->errstr";
my $sth=$dbh->prepare($sql) or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute select: $dbh->errstr\n";


while(my $row_ref =$sth->fetchrow_arrayref()){
   $req->bind_param(1,$row_ref->[0]) or die "bind error: $dbh->errstr";
   $req->execute or die "execute sql2: $dbh->errstr\n";
   while(my $row_ref2 =$req->fetchrow_arrayref()){
      print "class_name: $row_ref2->[0]\t";
      print "owner_name: $row_ref2->[1]\t";
      print "class_type: $row_ref2->[2]\n\n\n";
   }
   
}

#$req->finish();
$sth->finish();
$dbh -> disconnect();



