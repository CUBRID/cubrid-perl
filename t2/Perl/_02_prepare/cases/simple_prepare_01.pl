#!perl -w

# Test insert normally and insert error data.
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

my $data_source="dbi:cubrid:database=".$db.";host=".$hostname.";port=".$port;
my $dbh;

eval {$dbh=DBI->connect($data_source, $user, $pass,
	{RaiseError => 1, AutoCommit => 1});};
if($@)
{
   print "An error occurred ($@), continuing \n";
}

eval {$dbh -> do("drop table if EXISTS color;")};
if($@){
	print "An error occurred($@) when drop an exists table! \n";
}

eval {$dbh -> do("create table color(id int auto_increment,name varchar(10), color enum('red','green','purple','yellow','black'));")};

if($@){
	print "An error occurred($@) when create a new table !\n";
}

plan tests=>6;

# cubrid perl driver 8.4.4 do not support enum type
=pod
ok(my $sth=$dbh->prepare("insert into color(name, color) values(?,?);"), " not prepare ok");
ok($sth->execute('a','red'),"prepare of insert succeed");
ok($sth->execute('b','green'),"prepare of insert succeed");
ok($sth->execute('c','purple'),"prepare of insert succeed");
ok($sth->execute('d','yellow'),"prepare of insert succeed");
is($sth->execute('d','aaa'),undef,"error data");
$sth->finish();
$dbh->disconnect();
=cut

