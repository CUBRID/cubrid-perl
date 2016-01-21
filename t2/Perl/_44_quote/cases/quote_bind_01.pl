#!perl -w

# Test insert quote data by bind.
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
ok ($sth->bind_param(1,1),"bind 1");
ok ($sth->bind_param(2,$dbh->quote("single quote(') test")),"bind '");
ok ($sth->execute(),"execute 1");

ok ($sth->bind_param(1,2),"bind 2");
ok ($sth->bind_param(2,$dbh->quote("new line(\n) test")),"bind \\n");
ok ($sth->execute(),"execute 2");

ok ($sth->bind_param(1,3),"bind 3");
ok ($sth->bind_param(2,$dbh->quote("carrage return (\r) test")),"bind \\r");
ok ($sth->execute(),"execute 3");

ok ($sth->bind_param(1,4),"bind 4");
ok ($sth->bind_param(2,$dbh->quote("backslash (\\) test")),"bind \\\\");
ok ($sth->execute(),"execute 4");

ok ($sth->bind_param(1,5),"bind 5");
ok ($sth->bind_param(2,$dbh->quote("backslash quote(\\') test")),"bind \\\\\'");
ok ($sth->execute(),"execute 5");

my $sel_sql="select * from q1";
my $sth=$dbh->prepare($sel_sql) or warn("create error: $DBI::errstr");
$sth->execute() or warn("create error: $DBI::errstr");
my $arry=$sth->fetchall_arrayref({}) or die "Arry error:$dbh->errstr";

my $i=0;
my @id=(1,2,3,4,5);
my @a=(qq('single quote('') test'),"'new line(\n) test'","'carrage return (\r) test'","'backslash (\\) test'","'backslash quote(\\'') test'");
foreach my $row(@$arry){
  is($row->{'id'},$id[$i],"fetchall_arrayref({}) ok");
  is($row->{'a'},$a[$i],"fetchall_arrayref({}) ok");
    $i++;
}

$sth->finish();
done_testing();
$dbh->disconnect();




