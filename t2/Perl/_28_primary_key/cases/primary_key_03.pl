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
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die  $dbh->errstr . " connect error\n";
=pod
eval{my @primary1=$dbh->primary_key(undef,undef,'nothistable')};

if($@){
        print "An error occurred($@) when create a new table !\n";
}
=cut;
my @primary1=$dbh->primary_key(undef,undef,'nothistable');

if (@primary1 ){
   print "def\n";
}else{
   print "undef\n";
}

print @primary1 ."  :Length\n";
print "primary1: @primary1\n";
print @primary1 . ": Length1\n\n";
is(@primary1,0,"no table");
done_testing();
$dbh->disconnect;
