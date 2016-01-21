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
$dbh->do("drop table if EXISTS album;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE album(id_1 char(10) , id_2 char(10) , id_3 char(10) , id_4 char(10) , id_5 char(10) ,
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
 title varchar(100), artist  VARCHAR(100), CONSTRAINT \"pk_album_id\" PRIMARY KEY (id_1, id_2, id_3, id_4, id_5, id_6, id_7, id_8, id_9, id_10,id_11, id_12, id_13, id_14, id_15, id_16, id_17, id_18, id_19, id_20,
       id_21, id_22, id_23, id_24, id_25, id_26, id_27, id_28, id_29, id_30,
       id_31, id_32, id_33, id_34, id_35, id_36, id_37, id_38, id_39, id_40,
       id_41, id_42, id_43, id_44, id_45, id_46, id_47, id_48, id_49, id_50,
       id_51, id_52, id_53, id_54, id_55, id_56, id_57, id_58, id_59, id_60,
       id_61, id_62, id_63, id_64, id_65 ));") or die "create error: $dbh->errstr";
$dbh->do("CREATE TABLE track(
  album_1 char(10) , album_2 char(10) , album_3 char(10) , album_4 char(10) , album_5 char(10) ,
 album_6 char(10) , album_7 char(10) , album_8 char(10) , album_9 char(10) , album_10 char(10) ,
 album_11 char(10) , album_12 char(10) , album_13 char(10) , album_14 char(10) , album_15 char(10) ,
 album_16 char(10) , album_17 char(10) , album_18 char(10) , album_19 char(10) , album_20 char(10) ,
 album_21 char(10) , album_22 char(10) , album_23 char(10) , album_24 char(10) , album_25 char(10) ,
 album_26 char(10) , album_27 char(10) , album_28 char(10) , album_29 char(10) , album_30 char(10) ,
 album_31 char(10) , album_32 char(10) , album_33 char(10) , album_34 char(10) , album_35 char(10) ,
 album_36 char(10) , album_37 char(10) , album_38 char(10) , album_39 char(10) , album_40 char(10) ,
 album_41 char(10) , album_42 char(10) , album_43 char(10) , album_44 char(10) , album_45 char(10) ,
 album_46 char(10) , album_47 char(10) , album_48 char(10) , album_49 char(10) , album_50 char(10) ,
 album_51 char(10) , album_52 char(10) , album_53 char(10) , album_54 char(10) , album_55 char(10) ,
 album_56 char(10) , album_57 char(10) , album_58 char(10) , album_59 char(10) , album_60 char(10) ,
 album_61 char(10) , album_62 char(10) , album_63 char(10) , album_64 char(10) , album_65 char(10) ,
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255),
  FOREIGN KEY (album_1, album_2, album_3, album_4, album_5, album_6, album_7, album_8, album_9, album_10,
               album_11, album_12, album_13, album_14, album_15, album_16, album_17, album_18, album_19, album_20,
album_21, album_22, album_23, album_24, album_25, album_26, album_27, album_28, album_29, album_30,
album_31, album_32, album_33, album_34, album_35, album_36, album_37, album_38, album_39, album_40,
album_41, album_42, album_43, album_44, album_45, album_46, album_47, album_48, album_49, album_50,
album_51, album_52, album_53, album_54, album_55, album_56, album_57, album_58, album_59, album_60,
album_61, album_62, album_63, album_64, album_65)
REFERENCES album(id_1, id_2, id_3, id_4, id_5, id_6, id_7, id_8, id_9, id_10,
                id_11, id_12, id_13, id_14, id_15, id_16, id_17, id_18, id_19, id_20,
id_21, id_22, id_23, id_24, id_25, id_26, id_27, id_28, id_29, id_30,
id_31, id_32, id_33, id_34, id_35, id_36, id_37, id_38, id_39, id_40,
id_41, id_42, id_43, id_44, id_45, id_46, id_47, id_48, id_49, id_50,
id_51, id_52, id_53, id_54, id_55, id_56, id_57, id_58, id_59, id_60,
id_61, id_62, id_63, id_64, id_65)
);") or die "inser error: $dbh->errstr";


my $sth=$dbh->foreign_key_info(undef,undef,'album',undef,undef,'track') or die "primary_key_info error: $dbh->errstr";

my $all_ref =$sth->fetchall_arrayref() or die "all_ref error: $dbh->errstr";
my $i=0;

my @values=(undef,undef,"album","id_1",undef,undef,"track","album_1",1,1,1,
"fk_track_album_1_album_2_album_3_album_4_album_5_album_6_album_7_album_8_album_9_album_10_album_11_album_12_album_13_album_14_album_15_album_16_album_17_album_18_album_19_album_20_album_21_album_22_album_23_album_24_album_25_album_26_album_27_album_28_album_29_album_30_album_31_album_32_album_33_album_34_album_35_album_36_album_37_album_38_album_39_album_40_album_41_album_42_album_43_album_44_album_45_album_46_album_47_album_48_album_49_album_50_album_51_album_52_album_53_album_54_album_55_album_56_album_57_album_58_album_59_album_60_album_61_album_62_album_63_album_64_album_65",
"pk_album_id",undef,);
for my $j(0 .. $#{$all_ref->[$i]}){
      is($all_ref->[0][$j],$values[$i++],"foreign_key_info ok");
      $j++ ;
   }
done_testing();

$dbh->do("drop table if EXISTS track;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS album;") or die "drop error: $dbh->errstr";

$sth->finish();
$dbh->disconnect();


