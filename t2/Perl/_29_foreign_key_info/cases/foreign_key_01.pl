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
$dbh->do("drop table if EXISTS track;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS album_01;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE album_01(id_1 char(10) , id_2 char(10) , id_3 char(10) , id_4 char(10) , id_5 char(10) ,
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
 title varchar(100), artist  VARCHAR(100), CONSTRAINT \"pk_album_01_id\" PRIMARY KEY (id_1, id_2, id_3, id_4, id_5, id_6, id_7, id_8, id_9, id_10,id_11, id_12, id_13, id_14, id_15, id_16, id_17, id_18, id_19, id_20,
       id_21, id_22, id_23, id_24, id_25, id_26, id_27, id_28, id_29, id_30,
       id_31, id_32, id_33, id_34, id_35, id_36, id_37, id_38, id_39, id_40,
       id_41, id_42, id_43, id_44, id_45, id_46, id_47, id_48, id_49, id_50,
       id_51, id_52, id_53, id_54, id_55, id_56, id_57, id_58, id_59, id_60,
       id_61, id_62, id_63, id_64, id_65 ));") or die "create error: $dbh->errstr";
$dbh->do("CREATE TABLE track(
  album_01_1 char(10) , album_01_2 char(10) , album_01_3 char(10) , album_01_4 char(10) , album_01_5 char(10) ,
 album_01_6 char(10) , album_01_7 char(10) , album_01_8 char(10) , album_01_9 char(10) , album_01_10 char(10) ,
 album_01_11 char(10) , album_01_12 char(10) , album_01_13 char(10) , album_01_14 char(10) , album_01_15 char(10) ,
 album_01_16 char(10) , album_01_17 char(10) , album_01_18 char(10) , album_01_19 char(10) , album_01_20 char(10) ,
 album_01_21 char(10) , album_01_22 char(10) , album_01_23 char(10) , album_01_24 char(10) , album_01_25 char(10) ,
 album_01_26 char(10) , album_01_27 char(10) , album_01_28 char(10) , album_01_29 char(10) , album_01_30 char(10) ,
 album_01_31 char(10) , album_01_32 char(10) , album_01_33 char(10) , album_01_34 char(10) , album_01_35 char(10) ,
 album_01_36 char(10) , album_01_37 char(10) , album_01_38 char(10) , album_01_39 char(10) , album_01_40 char(10) ,
 album_01_41 char(10) , album_01_42 char(10) , album_01_43 char(10) , album_01_44 char(10) , album_01_45 char(10) ,
 album_01_46 char(10) , album_01_47 char(10) , album_01_48 char(10) , album_01_49 char(10) , album_01_50 char(10) ,
 album_01_51 char(10) , album_01_52 char(10) , album_01_53 char(10) , album_01_54 char(10) , album_01_55 char(10) ,
 album_01_56 char(10) , album_01_57 char(10) , album_01_58 char(10) , album_01_59 char(10) , album_01_60 char(10) ,
 album_01_61 char(10) , album_01_62 char(10) , album_01_63 char(10) , album_01_64 char(10) , album_01_65 char(10) ,
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255),
  FOREIGN KEY (album_01_1, album_01_2, album_01_3, album_01_4, album_01_5, album_01_6, album_01_7, album_01_8, album_01_9, album_01_10,
               album_01_11, album_01_12, album_01_13, album_01_14, album_01_15, album_01_16, album_01_17, album_01_18, album_01_19, album_01_20,
album_01_21, album_01_22, album_01_23, album_01_24, album_01_25, album_01_26, album_01_27, album_01_28, album_01_29, album_01_30,
album_01_31, album_01_32, album_01_33, album_01_34, album_01_35, album_01_36, album_01_37, album_01_38, album_01_39, album_01_40,
album_01_41, album_01_42, album_01_43, album_01_44, album_01_45, album_01_46, album_01_47, album_01_48, album_01_49, album_01_50,
album_01_51, album_01_52, album_01_53, album_01_54, album_01_55, album_01_56, album_01_57, album_01_58, album_01_59, album_01_60,
album_01_61, album_01_62, album_01_63, album_01_64, album_01_65)
REFERENCES album_01(id_1, id_2, id_3, id_4, id_5, id_6, id_7, id_8, id_9, id_10,
                id_11, id_12, id_13, id_14, id_15, id_16, id_17, id_18, id_19, id_20,
id_21, id_22, id_23, id_24, id_25, id_26, id_27, id_28, id_29, id_30,
id_31, id_32, id_33, id_34, id_35, id_36, id_37, id_38, id_39, id_40,
id_41, id_42, id_43, id_44, id_45, id_46, id_47, id_48, id_49, id_50,
id_51, id_52, id_53, id_54, id_55, id_56, id_57, id_58, id_59, id_60,
id_61, id_62, id_63, id_64, id_65)
);") or die "inser error: $dbh->errstr";


my $sth=$dbh->foreign_key_info(undef,undef,'album_01',undef,undef,'track') or die "primary_key_info error: $dbh->errstr";

my $all_ref =$sth->fetchall_arrayref() or die "all_ref error: $dbh->errstr";
my $i=0;

my @values=(undef,undef,"album_01","id_1",undef,undef,"track","album_01_1",1,1,1,
"fk_track_album_01_1_album_01_2_album_01_3_album_01_4_album_01_5_album_01_6_album_01_7_album_01_8_album_01_9_album_01_10_album_01_11_album_01_12_album_01_13_album_01_14_album_01_15_album_01_16_album_01_17_album_01_18_album_01_19_album_01_20_album_01_21_album_01_22_album_01_23_album_01_24_album_01_25_album_01_26_album_01_27_album_01_28_album_01_29_album_01_30_album_01_31_album_01_32_album_01_33_album_01_34_album_01_35_album_01_36_album_01_37_album_01_38_album_01_39_album_01_40_album_01_41_album_01_42_album_01_43_album_01_44_album_01_45_album_01_46_album_01_47_album_01_48_album_01_49_album_01_50_album_01_51_album_01_52_album_01_53_album_01_54_album_01_55_album_01_56_album_01_57_album_01_58_album_01_59_album_01_60_album_01_61_album_01_62_album_01_63_album_01_64_album_01_65",
"pk_album_01_id",undef,);
for my $j(0 .. $#{$all_ref->[$i]}){
      is($all_ref->[0][$j],$values[$i++],"foreign_key_info ok");
      $j++ ;
   }
done_testing();

$dbh->do("drop table if EXISTS track;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS album_01;") or die "drop error: $dbh->errstr";

$sth->finish();
$dbh->disconnect();


