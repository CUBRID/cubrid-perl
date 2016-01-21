#!perl -w

use DBI;
use Cwd;
use File::Basename;
use Test::More;
use strict;

use vars qw($db $port $hostname);

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

=pod
print "$0\n";
my $dir=getcwd();
print "$dir\n";
=cut

my $cwd;
if ($0 =~ m{^/}) {
  $cwd = dirname($0);
} else {
  $cwd = dirname(getcwd()."/$0");
}
print "$cwd\n";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";
$dbh -> do("drop table if EXISTS import_1 ;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE import_1 (doc_id VARCHAR(64) PRIMARY KEY, content varchar(40));") or die "create error:  $dbh->errstr";

my $sth=$dbh->prepare("insert into import_1 values(?,?);") or die "prepare error: $dbh->errstr";
$sth->bind_param (1, 1) or die "bind_param error: $dbh->errstr";
my $importValue=$sth->cubrid_lob_import (2, "$cwd/import1.txt", DBI::SQL_CLOB) or die   $dbh->errstr . "  :cubrid_lob_import error\n";
print "importValue: $importValue\n";
=pod
my $err= $dbh->errstr;
print $err ."\n";
if($err){
   print "$err\n";
}else{
   print "no error\n";
}
=cut

$sth->execute();# or die $dbh->errstr ."  :execute error\n";
like($dbh->errstr,qr/Cannot coerce host var to type char varying/,"cannot import clob to varchar.");
=pod
my $errEx= $dbh->errstr;
if($errEx){
   print "$errEx    :execute error\n";
}else{
   print "no error\n";
}
=cut
my $closeValue=$sth->cubrid_lob_close();
done_testing();
$sth->finish();
$dbh -> disconnect();



