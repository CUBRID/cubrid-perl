#!perl -w -w

use strict;
use MyBench;
use Getopt::Std;
use Time::HiRes qw(gettimeofday tv_interval);
use DBI;

my %opt;
Getopt::Std::getopt('n:r:h:', \%opt);

my $num_kids  = $opt{n} || 10;
my $num_runs  = $opt{r} || 100000;
my $db        = "demodb";
my $user      = "dba";
my $pass      = "";
my $dsn       = "dbi:cubrid:database=$db;";

my $callback = sub
{
    my $id  = shift;
    my $dbh = DBI->connect($dsn, $user, $pass, { RaiseError => 1 });

    my $sth = $dbh->prepare("SELECT * FROM aoo WHERE a = ?");

    my $cnt = 0;
    my @times = ();

    ## wait for the parent to HUP me
    local $SIG{HUP} = sub { };
    sleep 600;

    while ($cnt < $num_runs)
    {
        #my $v = int(rand(100000));
        ## time the query
        my $t0 = [gettimeofday];
        $sth->execute($cnt) or  die  $dbh->errstr  ."  :execute error\n";
        my $t1 = tv_interval($t0, [gettimeofday]);
        push @times, $t1;
        $sth->finish();
        $cnt++;
    }

    ## cleanup
    $dbh->disconnect();
    my @r = ($id, scalar(@times), min(@times), max(@times), avg(@times), tot(@times));
    return @r;
};

my @results = MyBench::fork_and_work($num_kids, $callback);
MyBench::compute_results('test', @results);

exit;

