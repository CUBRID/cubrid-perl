#!perl -w
#Test the condition of update include quote.
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
$dbh -> do("insert into t1 values (1,'a'),(2,'b'),(3,'c'),(4,'d'),(5,'e')") or warn("create error:$DBI::errstr");

sub escape_string_test{
    my @update_sql=@_;
    my $sth=$dbh->prepare($update_sql[0]) or warn("prepare update error: $DBI::errstr");
    $sth->execute() or warn("update execute error: $DBI::errstr");
}

my $sql1=sprintf"update t1 set a=%s where id=1;",$dbh->quote("single quote(') test");
my $sql2=sprintf"update t1 set a=%s where id=2;",$dbh->quote("new line(\n) test");
my $sql3=sprintf"update t1 set a=%s where id=3;",$dbh->quote("carrage return (\r) test");
my $sql4=sprintf"update t1 set a=%s where id=4;",$dbh->quote("backslash (\\) test");
my $sql5=sprintf"update t1 set a=%s where id=5;",$dbh->quote("backslash quote(\\') test");

my @arr_sql=($sql1, $sql2, $sql3, $sql4, $sql5);

for(my $i=0; $i<@arr_sql; $i++){
    print "Arr_sql:".$arr_sql[$i]."\n";
    escape_string_test($arr_sql[$i]);
}

my $sel_sql="select * from t1";
my $sth=$dbh->prepare($sel_sql) or warn("prepare select error: $DBI::errstr");
$sth->execute() or warn("select execute error: $DBI::errstr");

my $arry=$sth->fetchall_arrayref({}) or die "Arry error:$dbh->errstr";
my $i=0;
my @id=(1,2,3,4,5);
my @a=(qq(single quote(') test),"new line(\n) test","carrage return (\r) test","backslash (\\) test","backslash quote(\\') test");
foreach my $row(@$arry){
   print("\n\n");
   is($row->{'id'},$id[$i],"$i fetchall_arrayref({}) ok");
   is($row->{'a'},$a[$i],"$i fetchall_arrayref({}) ok");
   $i++;
}

done_testing();
$dbh -> disconnect();
