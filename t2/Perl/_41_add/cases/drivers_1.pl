#!perl -w 

use DBI;
use Test::More;
use DBI qw(:sql_types);
use vars qw($db $port $hostname); 

my @drvlist = DBI->available_drivers();

my $i=0;
foreach my $drvname (@drvlist)
{
   print ("drvname $drvname\n");
} 



