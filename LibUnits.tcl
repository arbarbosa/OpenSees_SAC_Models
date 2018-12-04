# --------------------------------------------------------------------------------------------------
# LibUnits.tcl -- define system of units
#			Filipe Ribeiro, 2010
#
# define UNITS ----------------------------------------------------------------------------
set m 1.; 				# define basic units -- output units
set kN 1.; 				# define basic units -- output units
set sec 1.; 				# define basic units -- output units

set kNpm2 [expr $kN/pow($m,2)];		# define engineering units
set kNm [expr $kN*$m]
set kNm2 [expr $kN*$m*$m];		
set m2 [expr $m*$m]; 			
set m3 [expr $m*$m*$m];			
set m4 [expr $m*$m*$m*$m];
set cm2 [expr $m2/10000];
set mm [expr $m/1000];
set N [expr $kN/1000];
set cm [expr $m/100];
set mm2 [expr $m2/1000000];
set mm3 [expr $m3/(1e9)];
set mm4 [expr $m4/(1e12)];

set in [expr 2.54*$cm];
set in2 [expr pow($in,2)];
set in3 [expr pow($in,3)];
set in4 [expr pow($in,4)];


set MPa [expr 1e3*$kNpm2];
set GPa [expr 1e6*$kNpm2];

set PI [expr 2*asin(1.0)]; 		# define constant PI
set g [expr 9.81*$m/pow($sec,2)]; 	# gravitational acceleration
set Ubig 1.e10; 			# a really large number
set Usmall [expr 1/$Ubig]; 		# a really small number
