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
$dbh -> do("drop table if EXISTS doc_t;") or die "drop error: $dbh->errstr";
$dbh -> do("CREATE TABLE doc_t (id int PRIMARY KEY, name varchar(8),age int);") or die "create error: $dbh->errstr";
$dbh->do("INSERT INTO doc_t values(1,'passsssssaaaa',33),(2,'dass',40),(3,'p',25);") or die "insert: $dbh->errstr";

plan tests=>6;
my $sth=$dbh->prepare("SELECT * FROM doc_t;");
$sth->execute() or die "execute select: $dbh->errstr\n";
my $ref =$sth->fetchall_hashref('id') or die "all_ref error: $dbh->errstr";
foreach my $key( keys(%{$ref}) ) {
   ok($ref->{$key}->{'name'},"fetchall_hashref ok");
   ok($ref->{$key}->{age},"fetchall_hashref ok");
}

$sth->finish();
$dbh -> disconnect();

