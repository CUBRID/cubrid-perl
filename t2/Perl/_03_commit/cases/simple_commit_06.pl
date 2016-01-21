#!/usr/local/bin/perl 

use DBI;
use Test::More;
use strict;

use vars qw($db $port $hostname);

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=localhost;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1,'PrintError' => 0, 'AutoCommit' => 1}) or die "connecr error: $dbh->errstr";

unless(defined($dbh)) {
	die($DBI::errstr);
}

plan tests=>4;
$dbh->do('DROP TABLE IF EXISTS tinnodb');
$dbh->do('CREATE TABLE tinnodb (id INTEGER  NOT NULL AUTO_INCREMENT PRIMARY KEY,dataN VARCHAR(25));');
my $first= $dbh->{'AutoCommit'};
ok($first eq 1, "AutoCommit ok");
$dbh->{'AutoCommit'} = 1;
do_stuff();
my $four=$dbh->{'AutoCommit'};
ok($four eq 1, "AutoCommit ok");

sub do_stuff {
	my $second=$dbh->{'AutoCommit'};
        ok($second eq 1, "AutoCommit ok");
        local $dbh->{'AutoCommit'} = 0; 
	my $third=$dbh->{'AutoCommit'};
        is($third,'', "Autocommit ok");
	my $sth = $dbh->prepare("INSERT INTO tinnodb (dataN) VALUES (?);") or die "prepare error:$dbh->errstr";
	$sth->execute('bla');
	$sth->execute('foo');
	$sth->finish();
	$dbh->commit();
	$dbh->disconnect();
}


