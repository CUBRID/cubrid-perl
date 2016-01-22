#!perl -w

#Test insert quote data by prepare.
use strict;
use Test::More;
use DBI;
use lib 't', '.';
require 'lib.pl';
use vars qw($table $test_dsn $test_user $test_passwd);

$|= 1;

my $dbh;
eval {$dbh= DBI->connect($test_dsn, $test_user, $test_passwd,
                      { RaiseError => 1, PrintError => 1, AutoCommit => 0 });};
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
my @a=(qq('single quote('') test'),"'new line(\n) test'","'carrage return (\r) test'","'backslash (\\) test'","'backslash quote(\\'') test'");
foreach my $row(@$arry){
  is($row->{'id'},$id[$i],"fetchall_arrayref({}) ok");
  is($row->{'a'},$a[$i],"fetchall_arrayref({}) ok");
    $i++;
}

$sth->finish();
done_testing();
$dbh->disconnect();




