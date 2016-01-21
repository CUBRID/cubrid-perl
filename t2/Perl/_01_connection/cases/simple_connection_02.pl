#!perl -w

use DBI;
use Test::More;

##Test dbi connection with the correct parameter
$db=$ARGV[0];
$hostname=$ARGV[1];
$port=$ARGV[2];

@ary=DBI->available_drivers;

%driver=DBI->installed_drivers();

print "installed_drivers\n";
print %driver."\n";

print "available_drivers\n";
foreach my $ary (@ary)
{
  print $ary."\n";
}
