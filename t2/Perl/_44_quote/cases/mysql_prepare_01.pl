#!perl -w

#Test insert quote data by prepare.
use DBI;
use DBD::cubrid;
use Test::More;
use strict;

use vars qw($db $port $hostname); 
$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $data_source="dbi:cubrid:database=$db;host=$hostname;port=$port";

my $dbh;
$dbh=DBI->connect($data_source, $user, $pass,{RaiseError => 1}) or die "connecr error: $dbh->errstr";

$dbh->do("drop table if EXISTS q1;") or die "drop error: $dbh->errstr";

$dbh->do("create table q1(id int, a string)") or die "create error: $dbh->errstr";

ok (my $sth=$dbh->prepare("insert into q1 values (?,?)"),"prepare ok");
ok ($sth->execute(1,$dbh->quote("single quote(') test")),"prepare of select succeed");
ok ($sth->execute(2,$dbh->quote("new line(\n) test")),"prepare of select succeed");
ok ($sth->execute(3,$dbh->quote("carrage return (\r) test")),"prepare of select succeed");
ok ($sth->execute(4,$dbh->quote("backslash (\\) test")),"prepare of select succeed");
ok ($sth->execute(5,$dbh->quote("backslash quote(\\') test")),"prepare of select succeed");

my $sel_sql="select * from q1";
$sth=$dbh->prepare($sel_sql) or warn("create error: $DBI::errstr");
$sth->execute() or warn("create error: $DBI::errstr");
my $arry=$sth->fetchall_arrayref({}) or die "Arry error:$dbh->errstr";

my $i=0;
my @id=(1,2,3,4,5);
#http://jira.cubrid.org/browse/APIS-468
my @a=(qq('single quote('') test'),qq('new line(\n) test'),qq('carrage return (\r) test'),qq('backslash (\\) test'),qq('backslash quote(\\'') test'));
foreach my $row(@$arry){
  is($row->{'id'},$id[$i],"fetchall_arrayref({}) ok");
  is($row->{'a'},$a[$i],"fetchall_arrayref({}) ok");
    $i++;
}

$sth->finish();
done_testing();
$dbh->disconnect();




