#!/usr/bin/perl
use strict;
use warnings;
 
use LWP::Simple;

my $callsign = "KB2PNM";



getData($callsign);


#################################  Subroutines ##################################


sub getData
	{	

		#Fetch the data for given call sign
   		my $call= shift;
		my $num = 0;
		my $grid;
		my $callLength = length($callsign);
		my $callCorrection = 144 + $callLength;
		my $left;
		my $date;
		my $time;
		my $offset = 0;
		my $result;
		my $callLocation;
		my $Lat;
		my $Lon;
		my @LatLon;
		my $LatLon;

	
   		my $url="http://wsprnet.org/olddb?mode=html&band=all&limit=25&findcall=$call&findreporter=&sort=date";
    		my $data = get($url);


		my $evenRow = index($data,"<tr id=\"evenrow\"><td align=left>&nbsp");
		
		 while ($evenRow != -1)
			{

				$date = substr($data,$evenRow+38,10);
				$time = substr($data,$evenRow+49,5);
	
				$callLocation= index ($data,$callsign,$evenRow);
				$grid= substr($data, $callLocation+$callCorrection,6);
				@LatLon = getLatLon($grid);
                                $Lat = $LatLon[0];
                                $Lon = $LatLon[1];
       
				$num = $num + 1;                 		

				print "Even Row record number: $num\nCallsign: $callsign\nDate: $date\nTime: $time\nGrid: $grid\nLat: $Lat\nLon: $Lon\n\n";


				 my $oddRow = index($data,"<tr id=\"oddrow\"><td align=left>&nbsp");


                		$date = substr($data,$oddRow+38,10);
                		$time = substr($data,$oddRow+48,5);

                		$callLocation= index ($data,$callsign,$oddRow);
                		$grid= substr($data, $callLocation+$callCorrection,6);
				$num = $num + 1;

                		print "Odd Row record number: $num\nCallsign: $callsign\nDate: $date\nTime: $time\nGrid: $grid\nLat: $Lat\nLon: $Lon\n\n";
				@LatLon = getLatLon($grid);
				$Lat = $LatLon[0];
				$Lon = $LatLon[1];
				$offset = $evenRow + 1;
    				$evenRow= index($data,"<tr id=\"evenrow\"><td align=left>&nbsp", $offset);

			}
	
	}
 

sub getLatLon
	{

		my @g= split (//, uc($_[0]));
		my  $lon;
		my $lat;


		$lon = (ord($g[0]) - ord('A')) * 20 - 180;
		$lat = (ord($g[1]) - ord('A')) * 10 - 90;
		$lon += (ord($g[2]) - ord('0')) * 2;
		$lat += (ord($g[3]) - ord('0')) * 1;
		$lon += ((ord($g[4])) - ord('A')) * 5/60;
		$lat += ((ord($g[5])) - ord('A')) * 2.5/60;
		# move to center of subsquare
		$lon += 2.5/60;
		$lat += 1.25/60;
		# not too precise
		my $formatter = "%.5f";
		$lat = sprintf($formatter, $lat);
		$lon = sprintf($formatter, $lon);
		my @pos = ($lat,$lon);

	}
 


