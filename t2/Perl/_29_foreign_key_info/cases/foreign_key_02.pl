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
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";
$dbh->do("drop table if EXISTS track;") ;
$dbh->do("drop table if EXISTS album_foreign_key02;") ;
$dbh->do("CREATE TABLE album_foreign_key02(id_1 char(10) , id_2 char(10) , id_3 char(10) , id_4 char(10) , id_5 char(10) ,
 id_6 char(10) , id_7 char(10) , id_8 char(10) , id_9 char(10) , id_10 char(10) ,
 id_11 char(10) , id_12 char(10) , id_13 char(10) , id_14 char(10) , id_15 char(10) ,
 id_16 char(10) , id_17 char(10) , id_18 char(10) , id_19 char(10) , id_20 char(10) ,
 id_21 char(10) , id_22 char(10) , id_23 char(10) , id_24 char(10) , id_25 char(10) ,
 id_26 char(10) , id_27 char(10) , id_28 char(10) , id_29 char(10) , id_30 char(10) ,
 id_31 char(10) , id_32 char(10) , id_33 char(10) , id_34 char(10) , id_35 char(10) ,
 id_36 char(10) , id_37 char(10) , id_38 char(10) , id_39 char(10) , id_40 char(10) ,
 id_41 char(10) , id_42 char(10) , id_43 char(10) , id_44 char(10) , id_45 char(10) ,
 id_46 char(10) , id_47 char(10) , id_48 char(10) , id_49 char(10) , id_50 char(10) ,
 id_51 char(10) , id_52 char(10) , id_53 char(10) , id_54 char(10) , id_55 char(10) ,
 id_56 char(10) , id_57 char(10) , id_58 char(10) , id_59 char(10) , id_60 char(10) ,
 id_61 char(10) , id_62 char(10) , id_63 char(10) , id_64 char(10) , id_65 char(10) ,
 title varchar(100), artist  VARCHAR(100), CONSTRAINT \"pk_album_foreign_key02_id\" PRIMARY KEY (id_1, id_2, id_3, id_4, id_5, id_6, id_7, id_8, id_9, id_10,id_11, id_12, id_13, id_14, id_15, id_16, id_17, id_18, id_19, id_20,
       id_21, id_22, id_23, id_24, id_25, id_26, id_27, id_28, id_29, id_30,
       id_31, id_32, id_33, id_34, id_35, id_36, id_37, id_38, id_39, id_40,
       id_41, id_42, id_43, id_44, id_45, id_46, id_47, id_48, id_49, id_50,
       id_51, id_52, id_53, id_54, id_55, id_56, id_57, id_58, id_59, id_60,
       id_61, id_62, id_63, id_64, id_65 ));") or die "create error: $dbh->errstr";
$dbh->do("CREATE TABLE track(
  album_foreign_key02_1 char(10) , album_foreign_key02_2 char(10) , album_foreign_key02_3 char(10) , album_foreign_key02_4 char(10) , album_foreign_key02_5 char(10) ,
 album_foreign_key02_6 char(10) , album_foreign_key02_7 char(10) , album_foreign_key02_8 char(10) , album_foreign_key02_9 char(10) , album_foreign_key02_10 char(10) ,
 album_foreign_key02_11 char(10) , album_foreign_key02_12 char(10) , album_foreign_key02_13 char(10) , album_foreign_key02_14 char(10) , album_foreign_key02_15 char(10) ,
 album_foreign_key02_16 char(10) , album_foreign_key02_17 char(10) , album_foreign_key02_18 char(10) , album_foreign_key02_19 char(10) , album_foreign_key02_20 char(10) ,
 album_foreign_key02_21 char(10) , album_foreign_key02_22 char(10) , album_foreign_key02_23 char(10) , album_foreign_key02_24 char(10) , album_foreign_key02_25 char(10) ,
 album_foreign_key02_26 char(10) , album_foreign_key02_27 char(10) , album_foreign_key02_28 char(10) , album_foreign_key02_29 char(10) , album_foreign_key02_30 char(10) ,
 album_foreign_key02_31 char(10) , album_foreign_key02_32 char(10) , album_foreign_key02_33 char(10) , album_foreign_key02_34 char(10) , album_foreign_key02_35 char(10) ,
 album_foreign_key02_36 char(10) , album_foreign_key02_37 char(10) , album_foreign_key02_38 char(10) , album_foreign_key02_39 char(10) , album_foreign_key02_40 char(10) ,
 album_foreign_key02_41 char(10) , album_foreign_key02_42 char(10) , album_foreign_key02_43 char(10) , album_foreign_key02_44 char(10) , album_foreign_key02_45 char(10) ,
 album_foreign_key02_46 char(10) , album_foreign_key02_47 char(10) , album_foreign_key02_48 char(10) , album_foreign_key02_49 char(10) , album_foreign_key02_50 char(10) ,
 album_foreign_key02_51 char(10) , album_foreign_key02_52 char(10) , album_foreign_key02_53 char(10) , album_foreign_key02_54 char(10) , album_foreign_key02_55 char(10) ,
 album_foreign_key02_56 char(10) , album_foreign_key02_57 char(10) , album_foreign_key02_58 char(10) , album_foreign_key02_59 char(10) , album_foreign_key02_60 char(10) ,
 album_foreign_key02_61 char(10) , album_foreign_key02_62 char(10) , album_foreign_key02_63 char(10) , album_foreign_key02_64 char(10) , album_foreign_key02_65 char(10) ,
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255),
  FOREIGN KEY (album_foreign_key02_1, album_foreign_key02_2, album_foreign_key02_3, album_foreign_key02_4, album_foreign_key02_5, album_foreign_key02_6, album_foreign_key02_7, album_foreign_key02_8, album_foreign_key02_9, album_foreign_key02_10,
               album_foreign_key02_11, album_foreign_key02_12, album_foreign_key02_13, album_foreign_key02_14, album_foreign_key02_15, album_foreign_key02_16, album_foreign_key02_17, album_foreign_key02_18, album_foreign_key02_19, album_foreign_key02_20,
album_foreign_key02_21, album_foreign_key02_22, album_foreign_key02_23, album_foreign_key02_24, album_foreign_key02_25, album_foreign_key02_26, album_foreign_key02_27, album_foreign_key02_28, album_foreign_key02_29, album_foreign_key02_30,
album_foreign_key02_31, album_foreign_key02_32, album_foreign_key02_33, album_foreign_key02_34, album_foreign_key02_35, album_foreign_key02_36, album_foreign_key02_37, album_foreign_key02_38, album_foreign_key02_39, album_foreign_key02_40,
album_foreign_key02_41, album_foreign_key02_42, album_foreign_key02_43, album_foreign_key02_44, album_foreign_key02_45, album_foreign_key02_46, album_foreign_key02_47, album_foreign_key02_48, album_foreign_key02_49, album_foreign_key02_50,
album_foreign_key02_51, album_foreign_key02_52, album_foreign_key02_53, album_foreign_key02_54, album_foreign_key02_55, album_foreign_key02_56, album_foreign_key02_57, album_foreign_key02_58, album_foreign_key02_59, album_foreign_key02_60,
album_foreign_key02_61, album_foreign_key02_62, album_foreign_key02_63, album_foreign_key02_64, album_foreign_key02_65)
REFERENCES album_foreign_key02(id_1, id_2, id_3, id_4, id_5, id_6, id_7, id_8, id_9, id_10,
                id_11, id_12, id_13, id_14, id_15, id_16, id_17, id_18, id_19, id_20,
id_21, id_22, id_23, id_24, id_25, id_26, id_27, id_28, id_29, id_30,
id_31, id_32, id_33, id_34, id_35, id_36, id_37, id_38, id_39, id_40,
id_41, id_42, id_43, id_44, id_45, id_46, id_47, id_48, id_49, id_50,
id_51, id_52, id_53, id_54, id_55, id_56, id_57, id_58, id_59, id_60,
id_61, id_62, id_63, id_64, id_65)
);") or die "inser error: $dbh->errstr";


my $sth=$dbh->foreign_key_info(undef,undef,'',undef,undef,'track') or die "primary_key_info error: $dbh->errstr";

my $all_ref =$sth->fetchall_arrayref() or die "all_ref error: $dbh->errstr";
my $i=0;

my @values=(undef,undef,"album_foreign_key02","id_1",undef,undef,"track","album_foreign_key02_1",1,1,1,
"fk_track_album_foreign_key02_1_album_foreign_key02_2_album_foreign_key02_3_album_foreign_key02_4_album_foreign_key02_5_album_foreign_key02_6_album_foreign_key02_7_album_foreign_key02_8_album_foreign_key02_9_album_foreign_key02_10_album_foreign_key02_11_album_foreign_key02_12_album_foreign_key02_13_album_foreign_key02_14_album_foreign_key02_15_album_foreign_key02_16_album_foreign_key02_17_album_foreign_key02_18_album_foreign_key02_19_album_foreign_key02_20_album_foreign_key02_21_album_foreign_key02_22_album_foreign_key02_23_album_foreign_key02_24_album_foreign_key02_25_album_foreign_key02_26_album_foreign_key02_27_album_foreign_key02_28_album_foreign_key02_29_album_foreign_key02_30_album_foreign_key02_31_album_foreign_key02_32_album_foreign_key02_33_album_foreign_key02_34_album_foreign_key02_35_album_foreign_key02_36_album_foreign_key02_37_album_foreign_key02_38_album_foreign_key02_39_album_foreign_key02_40_album_foreign_key02_41_album_foreign_key02_42_album_foreign_key02_43_album_foreign_key02_44_album_foreign_key02_45_album_foreign_key02_46_album_foreign_key02_47_album_foreign_key02_48_album_foreign_key02_49_album_foreign_key02_50_album_foreign_key02_51_album_foreign_key02_52_album_foreign_key02_53_album_foreign_key02_54_album_foreign_key02_55_album_foreign_key02_56_album_foreign_key02_57_album_foreign_key02_58_album_foreign_key02_59_album_foreign_key02_60_album_foreign_key02_61_album_foreign_key02_62_album_foreign_key02_63_album_foreign_key02_64_album_foreign_key02_65",
"pk_album_foreign_key02_id",undef,);
for my $j(0 .. $#{$all_ref->[$i]}){
      is($all_ref->[0][$j],$values[$i++],"foreign_key_info ok");
      $j++ ;
   }
done_testing();

$dbh->do("drop table if EXISTS track;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS album_foreign_key02;") or die "drop error: $dbh->errstr";

$sth->finish();
$dbh->disconnect();


