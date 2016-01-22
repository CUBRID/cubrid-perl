#!/bin/env perl
  
use DBI ();
use DBI qw(:sql_types);
use DBI::Const::GetInfoType;
use Test::More;
use vars qw($table $test_dsn $test_user $test_passwd);
use lib '.', 't';
require 'lib.pl';
  
my $dbh = DBI->connect(
    $test_dsn, $test_user, $test_passwd,
    {   AutoCommit  => 1,
        RaiseError  => 0,
        PrintError  => 1,
        HandleError => sub { print "!!! Handle Error !!!\n"; },
        Callbacks   => {
            connected => sub {
                print "*** Connected! *** \n";
                return;
            },
        },
    }
) or die $DBI::errstr;


plan tests => 1;
my $sth = $dbh->prepare("select * from code where s_name=?");
ok $sth->execute();
$sth->finish();
$dbh -> disconnect();