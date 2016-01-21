#!perl -w

#Test insert data include quote.The table only has many column
use DBI;
use DBD::cubrid;
use Test::More;
use strict;

use vars qw($db $port $hostname); 
$db=$ARGV[0];
$port=$ARGV[2];
my $user="dba";
my $pass="";

my $data_source="dbi:cubrid:database=$db;host=localhost;port=$port";
my $dbh;
$dbh=DBI->connect($data_source, $user, $pass,{PrintError => 1, RaiseError=>0}) or warn("$DBI::errstr");
$dbh -> do("drop table if EXISTS t1;") or warn("drop error: $DBI::errstr");
$dbh -> do("create table t1(id int,a string);") or warn("create error: $DBI::errstr");

sub escape_string_test{
    my @inser_sql=@_;
    #print "insert: ". $inser_sql[0] ."\n\n";
    my $sth=$dbh->prepare($inser_sql[0]) or warn("prepare insert error: $DBI::errstr");
    $sth->execute() or warn("insert error: $DBI::errstr");

}

my $sql1=sprintf"insert into t1 values (1,%s);",$dbh->quote("single quote(') test");
my $sql2=sprintf"insert into t1 values (2,%s);",$dbh->quote("new line(\n) test");
my $sql3=sprintf"insert into t1 values (3,%s);",$dbh->quote("carrage return (\r) test");
my $sql4=sprintf"insert into t1 values (4,%s);",$dbh->quote("backslash (\\) test");
my $sql5=sprintf"insert into t1 values (5,%s);",$dbh->quote("backslash quote(\\') test");

my @arr_sql=($sql1, $sql2, $sql3, $sql4, $sql5);

for(my $i=0; $i<@arr_sql; $i++){
    #print "arr_sql[$i]: " . $arr_sql[$i]."\n";
    escape_string_test($arr_sql[$i]);
}

my $sel_sql="select * from t1";
my $sth=$dbh->prepare($sel_sql) or warn("create error: $DBI::errstr");
$sth->execute() or warn("create error: $DBI::errstr");

my $arry=$sth->fetchall_arrayref({}) or die "Arry error:$dbh->errstr";

my $i=0;
my @id=(1,2,3,4,5);
my @aa=(qq(single quote(') test),"new line(\n) test","carrage return (\r) test","backslash (\\) test","backslash quote(\\') test");
foreach my $row(@$arry){
   is($row->{'id'},$id[$i],"fetchall_arrayref({}) ok");
   is($row->{'a'},$aa[$i],"fetchall_arrayref({}) ok");
    $i++;
}

done_testing();
$dbh -> disconnect();
