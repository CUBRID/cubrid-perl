#!perl -w 

use DBI;
use Test::More;
use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";

my $driver = DBI->install_driver('cubrid');
if(!$driver) {
           $Connect_Error="Unable to load database driver ".$DBI::errstr;
           print "$Connect_Error\n";
} else {
           # Tell Cubrid to return longs in a big buffer.
           $Oraperl::ora_long = 8192;
           my $database = $driver->connect($dsn, $user, $pass,{RaiseError => 1});
           if(!$database) {
              $Connect_Error=$driver->errstr;
              print "$Connect_Error\n";
           } else {
              $connected = 1;
              print "connect ok!!\n";
           }
}

