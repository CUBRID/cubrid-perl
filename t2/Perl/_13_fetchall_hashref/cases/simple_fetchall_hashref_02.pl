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
$dbh -> do("CREATE TABLE doc_t (id int , name varchar(8),age int);") or die "create error: $dbh->errstr";
$dbh->do("INSERT INTO doc_t values(1,'passsssssaaaa',33),(2,'dass',40),(3,'p',25),(4,'s',25);") or die "insert: $dbh->errstr";

my $sth=$dbh->prepare("SELECT * FROM doc_t;");
$sth->execute() or die "execute select: $dbh->errstr\n";
my $ref =$sth->fetchall_hashref([qw(id name)]) or die "all_ref error: $dbh->errstr";
my $value=$ref->{2}->{'dass'}->{age};
plan tests=>1;
ok($value eq 40, "fetchall_hashref([qw(id name)] ok ");

$sth->finish();
$dbh -> disconnect();

