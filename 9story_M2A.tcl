# --------------------------------------------------------------------------------------------------
# 2D Portal Frame--  9-Story Moment Frame with Distributed Plasticity Build Model with IK modified material behaviour (Lignos, 2009)
#			Filipe Ribeiro, 2018


#   Units: m, kN, sec. 
#
# source external files
	source LibUnits.tcl;			# define system units
	source DisplayModel2D.tcl;			# procedure for displaying a 2D perspective of model
	source DisplayPlane.tcl;			# procedure for displaying a plane in the model
	source Wsection.tcl;		# procedure for defining bilinear plastic hinge section
	source rotPanelZone2D.tcl;   # procedure for defining Panel Zone springs
	source elemPanelZone2D.tcl;			# procedure for defining 8 elements to create a rectangular panel zone

# INPUTs
set Qake "GM_.AT2";
set Qake_factor "$g*1.";
set npts_accelerogram 2999;   
set dt_accelerogram 0.01;	

# OUTPUTs
#set file_results [open "Peak_Results.out" "w"];

# RUN MODEL

# SET UP ----------------------------------------------------------------------------
wipe;						# clear memory of all past model definitions
model BasicBuilder -ndm 2 -ndf 3;	# Define the model builder, $ndm-D, $ndf dofs

# ## results directory
 set dataDir Data;		# set up name of directory where output will be written to
 file mkdir $dataDir; 			# create directory
	
# define GEOMETRY -------------------------------------------------------------
set LCol1 [expr 3.65*$m]; 			# column length
set LCol2 [expr 5.49*$m]; 			# column length
set LCol3 [expr 3.96*$m]; 			# column length
set LBeam [expr 9.15*$m];			# beam length
set Weight_PisoG [expr 5.0488E6*$N]; 		# superstructure weight
set Weight_Piso1 [expr 5.0488E6*$N]; 
set Weight_Piso2 [expr 4.9625E6*$N]; 
set Weight_Piso3 [expr 5.346E6*$N]; 
set mass_PisoG [expr $Weight_PisoG/$g];
set mass_Piso1 [expr $Weight_Piso1/$g];
set mass_Piso2 [expr $Weight_Piso2/$g];
set mass_Piso3 [expr $Weight_Piso3/$g];

# calculated parameters
set PFloorG_ext [expr $Weight_PisoG/10 ]; 			# nodal dead-load weight 	
set PFloorG_int [expr $Weight_PisoG/5 ]; 			# nodal dead-load weight 	
set PFloor1_ext [expr $Weight_Piso1/10 ]; 			# nodal dead-load weight 	
set PFloor1_int [expr $Weight_Piso1/5 ]; 			# nodal dead-load weight 	
set PFloor2_ext [expr $Weight_Piso2/10]; 			# nodal dead-load weight  
set PFloor2_int [expr $Weight_Piso2/5 ]; 			# nodal dead-load weight  
set PFloor3_ext [expr $Weight_Piso3/10]; 			# nodal dead-load weight 
set PFloor3_int [expr $Weight_Piso3/5 ]; 			# nodal dead-load weight

set massG_ext [expr $mass_PisoG/10]; 			# nodal dead-load weight 	
set massG_int [expr $mass_PisoG/5 ]; 			# nodal dead-load weight 	
set mass1_ext [expr $mass_Piso1/10]; 			# nodal dead-load weight 	
set mass1_int [expr $mass_Piso1/5 ]; 			# nodal dead-load weight 	
set mass2_ext [expr $mass_Piso2/10]; 			# nodal dead-load weight  
set mass2_int [expr $mass_Piso2/5 ]; 			# nodal dead-load weight  
set mass3_ext [expr $mass_Piso3/10]; 			# nodal dead-load weight 
set mass3_int [expr $mass_Piso3/5 ]; 			# nodal dead-load weight 


# nodal coordinates:
source nodes.tcl
puts "nodes done!"

# Single point constraints -- Boundary Conditions
fix	1410008	1 1 0;
fix	1420008	1 1 0;		
fix	1430008	1 1 0;		
fix	1440008	1 1 0;		
fix	1450008	1 1 0;		
fix	1460008	1 1 0;		
fix	1470008	1 1 0;		
fix	1480008	1 1 0;		
fix	1490008	1 1 0;		
fix	14100008	1 1 0;		
fix	14110008	1 1 0;		
fix	14120008	1 1 0;

fix 1110 1 0 0;
fix 6110 1 0 0;
fix 7110 1 0 0;
fix 12110 1 0 0;

# Truss elements #
uniaxialMaterial Elastic 100 [expr 1E6*$GPa];
source rigid_links.tcl
puts "rigid links done!"

###################################################################################################
#          Define Section Properties and Elements													  
###################################################################################################
# define material properties
	set Es [expr 200.*$GPa];			# modulus of steel
	set G [expr 89.*$GPa];
	set Fy_column [expr 397.7*$MPa];
	set Fy_beam [expr 339.3*$MPa];
	
	#plastic hinge lengths and ratios
	set Lp_Col1 [expr  $LCol1/6  ];
	set Lp_Col2 [expr  $LCol2/6  ];
	set Lp_Col3 [expr  $LCol3/6  ];
	set Lp_Beam [expr $LBeam/6  ];
	
	set Bs 0.03;				# strain-hardening ratio 
	set R0 18;				# control the transition from elastic to plastic branches
	set cR1 0.925;				# control the transition from elastic to plastic branches
	set cR2 0.15;				# control the transition from elastic to plastic branches
	
	set IDSteel_Fy 1
	uniaxialMaterial Steel02 $IDSteel_Fy $Fy_column $Es $Bs $R0 $cR1 $cR2;
	set IDSteel_2xFy 2
	uniaxialMaterial Steel02 $IDSteel_2xFy [expr 2.0*$Fy_column] [expr 2.0*$Es] $Bs $R0 $cR1 $cR2;	
	set IDSteel_191xFy 3
	uniaxialMaterial Steel02 $IDSteel_191xFy [expr 1.91*$Fy_column] [expr 1.91*$Es] $Bs $R0 $cR1 $cR2;
	set IDSteel_178xFy 4
	uniaxialMaterial Steel02 $IDSteel_178xFy [expr 1.78*$Fy_column] [expr 1.78*$Es] $Bs $R0 $cR1 $cR2;
	
	
# define column sections
set W14X500 500;
set AW14x500 [expr 147*pow($in,2)];
set IzW14x500 [expr 8210*pow($in,4)];
set d [expr 19.6*$in];
set bf [expr 17.01*$in];
set tf [expr 3.5*$in];
set tw [expr 2.19*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X500 $IDSteel_Fy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X500_WA_CF 5002; 

	set dw [expr $d - 2 * $tf]
	set y1 [expr -$d/2]
	set y2 [expr -$dw/2]
	set y3 [expr  $dw/2]
	set y4 [expr  $d/2]
  
	set z1 [expr -$bf/2]
	set z2 [expr -$tw/2]
	set z3 [expr  $tw/2]
	set z4 [expr  $bf/2]
  
	section fiberSec  $W14X500_WA_CF  {
   	#                     nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   	patch quadr  $IDSteel_2xFy  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   	patch quadr  $IDSteel_2xFy  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   	patch quadr  $IDSteel_2xFy  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}
	
set W14X455 455;
set AW14x455  [expr 134*pow($in,2)];
set IzW14x455  [expr 7190*pow($in,4)];
set d [expr 19.02*$in];
set bf [expr 16.835*$in];
set tf [expr 3.21*$in];
set tw [expr 2.015*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X455 $IDSteel_Fy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X455_WA_CF 4552; 

	set dw [expr $d - 2 * $tf]
	set y1 [expr -$d/2]
	set y2 [expr -$dw/2]
	set y3 [expr  $dw/2]
	set y4 [expr  $d/2]
  
	set z1 [expr -$bf/2]
	set z2 [expr -$tw/2]
	set z3 [expr  $tw/2]
	set z4 [expr  $bf/2]
  
	section fiberSec  $W14X455_WA_CF  {
   	#                     nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   	patch quadr  $IDSteel_2xFy  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   	patch quadr  $IDSteel_2xFy  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   	patch quadr  $IDSteel_2xFy  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}

set W14X370 370; 
set AW14x370    [expr 109*pow($in,2)];
set IzW14x370     [expr 5440*pow($in,4)];
set d [expr 17.92*$in];
set bf [expr 16.475*$in];
set tf [expr 2.66*$in];
set tw [expr 1.655*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X370 $IDSteel_Fy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X370_WA 371; 
set AW14x370_WA    [expr 109*pow($in,2)];
set IzW14x370_WA     [expr 1990*pow($in,4)];

	set dw [expr $d - 2 * $tf]
	set y1 [expr -$d/2]
	set y2 [expr -$dw/2]
	set y3 [expr  $dw/2]
	set y4 [expr  $d/2]
  
	set z1 [expr -$bf/2]
	set z2 [expr -$tw/2]
	set z3 [expr  $tw/2]
	set z4 [expr  $bf/2]
  
	section fiberSec  $W14X370_WA  {
   	#                     nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   	patch quadr  $IDSteel_Fy  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   	patch quadr  $IDSteel_Fy  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   	patch quadr  $IDSteel_Fy  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}
	
set W14X370_WA_CF 3712; 
 
	section fiberSec  $W14X370_WA_CF  {
   	#                     nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   	patch quadr  $IDSteel_2xFy  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   	patch quadr  $IDSteel_2xFy  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   	patch quadr  $IDSteel_2xFy  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}

set W14X283 283; 
set AW14x283  [expr 83.3*pow($in,2)];
set IzW14x283  [expr 3840*pow($in,4)];
set d [expr 16.74*$in];
set bf [expr 16.11*$in];
set tf [expr 2.07*$in];
set tw [expr 1.29*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X283 $IDSteel_Fy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X283_WA 2840; 
set AW14x283_WA  [expr 83.3*pow($in,2)];
set IzW14x283_WA  [expr 3840*pow($in,4)];

	set dw [expr $d - 2 * $tf]
	set y1 [expr -$d/2]
	set y2 [expr -$dw/2]
	set y3 [expr  $dw/2]
	set y4 [expr  $d/2]
  
	set z1 [expr -$bf/2]
	set z2 [expr -$tw/2]
	set z3 [expr  $tw/2]
	set z4 [expr  $bf/2]
  
	section fiberSec  $W14X283_WA  {
   	#                     nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   	patch quadr  $IDSteel_Fy  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   	patch quadr  $IDSteel_Fy  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   	patch quadr  $IDSteel_Fy  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}

set W14X283_WA_CF 2842; 
 
	section fiberSec  $W14X283_WA_CF  {
   	#                     nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   	patch quadr  $IDSteel_2xFy  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   	patch quadr  $IDSteel_2xFy  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   	patch quadr  $IDSteel_2xFy  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}

set W14X257 257; 
set AW14x257  [expr 75.6*pow($in,2)];
set IzW14x257  [expr 3400*pow($in,4)];
set d [expr 16.38*$in];
set bf [expr 15.995*$in];
set tf [expr 1.89*$in];
set tw [expr 1.175*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X257 $IDSteel_Fy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X257_WA 258; 
set AW14x257_WA  [expr 75.6*pow($in,2)];
set IzW14x257_WA  [expr 3400*pow($in,4)];

	set dw [expr $d - 2 * $tf]
	set y1 [expr -$d/2]
	set y2 [expr -$dw/2]
	set y3 [expr  $dw/2]
	set y4 [expr  $d/2]
  
	set z1 [expr -$bf/2]
	set z2 [expr -$tw/2]
	set z3 [expr  $tw/2]
	set z4 [expr  $bf/2]
  
	section fiberSec  $W14X257_WA  {
   	#                     nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   	patch quadr  $IDSteel_Fy  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   	patch quadr  $IDSteel_Fy  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   	patch quadr  $IDSteel_Fy  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}

set W14X257_WA_CF 2582; 
  
	section fiberSec  $W14X257_WA_CF  {
   	#                     nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   	patch quadr  $IDSteel_2xFy  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   	patch quadr  $IDSteel_2xFy  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   	patch quadr  $IDSteel_2xFy  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}
	
set W14X233 233; 
set AW14x233  [expr 68.5*pow($in,2)];
set IzW14x233  [expr 3010*pow($in,4)];
set d [expr 16.0*$in];
set bf [expr 15.9*$in];
set tf [expr 1.72*$in];
set tw [expr 1.07*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X233 $IDSteel_Fy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X233_WA 2340; 
set AW14x233_WA  [expr 68.5*pow($in,2)];
set IzW14x233_WA [expr 1150*pow($in,4)];

	set dw [expr $d - 2 * $tf]
	set y1 [expr -$d/2]
	set y2 [expr -$dw/2]
	set y3 [expr  $dw/2]
	set y4 [expr  $d/2]
  
	set z1 [expr -$bf/2]
	set z2 [expr -$tw/2]
	set z3 [expr  $tw/2]
	set z4 [expr  $bf/2]
  
	section fiberSec  $W14X233_WA  {
   	#                     nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
   	patch quadr  $IDSteel_Fy  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   	patch quadr  $IDSteel_Fy  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   	patch quadr  $IDSteel_Fy  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}

set W14X211_CF 2112; 
set d [expr 15.72*$in];
set bf [expr 15.8*$in];
set tf [expr 1.56*$in];
set tw [expr 0.98*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X211_CF $IDSteel_191xFy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X193_CF 1932; 
set d [expr 15.48*$in];
set bf [expr 15.71*$in];
set tf [expr 1.44*$in];
set tw [expr 0.89*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X193_CF $IDSteel_2xFy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X159_CF 1592; 
set d [expr 14.98*$in];
set bf [expr 15.56*$in];
set tf [expr 1.19*$in];
set tw [expr 0.75*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X159_CF $IDSteel_191xFy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X145_CF 1452; 
set d [expr 14.78*$in];
set bf [expr 15.5*$in];
set tf [expr 1.09*$in];
set tw [expr 0.68*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X145_CF $IDSteel_2xFy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X120_CF 1202; 
set d [expr 14.48*$in];
set bf [expr 14.67*$in];
set tf [expr 0.94*$in];
set tw [expr 0.59*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X120_CF $IDSteel_191xFy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X109_CF 1092; 
set d [expr 14.32*$in];
set bf [expr 14.64*$in];
set tf [expr 0.86*$in];
set tw [expr 0.53*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X109_CF $IDSteel_2xFy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X90_CF 9002; 
set d [expr 14.02*$in];
set bf [expr 14.52*$in];
set tf [expr 0.71*$in];
set tw [expr 0.44*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X90_CF $IDSteel_191xFy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X82_CF 8202; 
set d [expr 14.31*$in];
set bf [expr 10.13*$in];
set tf [expr 0.86*$in];
set tw [expr 0.51*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X82_CF $IDSteel_2xFy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X61_CF 6102; 
set d [expr 13.89*$in];
set bf [expr 9.99*$in];
set tf [expr 0.65*$in];
set tw [expr 0.38*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X61_CF $IDSteel_178xFy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14X48_CF 4802; 
set d [expr 13.79*$in];
set bf [expr 8.03*$in];
set tf [expr 0.59*$in];
set tw [expr 0.34*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14X48_CF $IDSteel_2xFy $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

puts "column sections done!"

# define element type and connectivity:
# element beamWithHinges $eleTag $iNode $jNode $secTagI      $Lpi  $secTagJ   $Lpj  $E $A $Iz $transfTag <-mass $massDens> <-iter $maxIters $tol>
set numIntgrPts 8;

# define geometric transformation: performs a Linear geometric transformation of beam stiffness and resisting force from the basic system to the global-coordinate system
set TransfTag 1; 				# associate a tag to column transformation
geomTransf PDelta $TransfTag; 		
	
#columns
#Moment Resisting Frame								
element	forceBeamColumn	40011	1410008	116	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40021	1420008	216	$TransfTag	Lobatto	$W14X500	$numIntgrPts
element	forceBeamColumn	40031	1430008	316	$TransfTag	Lobatto	$W14X500	$numIntgrPts
element	forceBeamColumn	40041	1440008	416	$TransfTag	Lobatto	$W14X500	$numIntgrPts
element	forceBeamColumn	40051	1450008	516	$TransfTag	Lobatto	$W14X500	$numIntgrPts
element	forceBeamColumn	40061	1460008	616	$TransfTag	Lobatto	$W14X370_WA	$numIntgrPts
								
element	forceBeamColumn	40012	117	126	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40022	217	226	$TransfTag	Lobatto	$W14X500	$numIntgrPts
element	forceBeamColumn	40032	317	326	$TransfTag	Lobatto	$W14X500	$numIntgrPts
element	forceBeamColumn	40042	417	426	$TransfTag	Lobatto	$W14X500	$numIntgrPts
element	forceBeamColumn	40052	517	526	$TransfTag	Lobatto	$W14X500	$numIntgrPts
element	forceBeamColumn	40062	617	626	$TransfTag	Lobatto	$W14X370_WA	$numIntgrPts
								
element	forceBeamColumn	40013	127	136	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40023	227	236	$TransfTag	Lobatto	$W14X455	$numIntgrPts
element	forceBeamColumn	40033	327	336	$TransfTag	Lobatto	$W14X455	$numIntgrPts
element	forceBeamColumn	40043	427	436	$TransfTag	Lobatto	$W14X455	$numIntgrPts
element	forceBeamColumn	40053	527	536	$TransfTag	Lobatto	$W14X455	$numIntgrPts
element	forceBeamColumn	40063	627	636	$TransfTag	Lobatto	$W14X370_WA	$numIntgrPts
								
element	forceBeamColumn	40014	137	146	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40024	237	246	$TransfTag	Lobatto	$W14X455	$numIntgrPts
element	forceBeamColumn	40034	337	346	$TransfTag	Lobatto	$W14X455	$numIntgrPts
element	forceBeamColumn	40044	437	446	$TransfTag	Lobatto	$W14X455	$numIntgrPts
element	forceBeamColumn	40054	537	546	$TransfTag	Lobatto	$W14X455	$numIntgrPts
element	forceBeamColumn	40064	637	646	$TransfTag	Lobatto	$W14X370_WA	$numIntgrPts
								
element	forceBeamColumn	40015	147	156	$TransfTag	Lobatto	$W14X283	$numIntgrPts
element	forceBeamColumn	40025	247	256	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40035	347	356	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40045	447	456	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40055	547	556	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40065	647	656	$TransfTag	Lobatto	$W14X283_WA	$numIntgrPts
								
element	forceBeamColumn	40016	157	166	$TransfTag	Lobatto	$W14X283	$numIntgrPts
element	forceBeamColumn	40026	257	266	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40036	357	366	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40046	457	466	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40056	557	566	$TransfTag	Lobatto	$W14X370	$numIntgrPts
element	forceBeamColumn	40066	657	666	$TransfTag	Lobatto	$W14X283_WA	$numIntgrPts
								
element	forceBeamColumn	40017	167	176	$TransfTag	Lobatto	$W14X257	$numIntgrPts
element	forceBeamColumn	40027	267	276	$TransfTag	Lobatto	$W14X283	$numIntgrPts
element	forceBeamColumn	40037	367	376	$TransfTag	Lobatto	$W14X283	$numIntgrPts
element	forceBeamColumn	40047	467	476	$TransfTag	Lobatto	$W14X283	$numIntgrPts
element	forceBeamColumn	40057	567	576	$TransfTag	Lobatto	$W14X283	$numIntgrPts
element	forceBeamColumn	40067	667	676	$TransfTag	Lobatto	$W14X257_WA	$numIntgrPts
								
element	forceBeamColumn	40018	177	186	$TransfTag	Lobatto	$W14X257	$numIntgrPts
element	forceBeamColumn	40028	277	286	$TransfTag	Lobatto	$W14X283	$numIntgrPts
element	forceBeamColumn	40038	377	386	$TransfTag	Lobatto	$W14X283	$numIntgrPts
element	forceBeamColumn	40048	477	486	$TransfTag	Lobatto	$W14X283	$numIntgrPts
element	forceBeamColumn	40058	577	586	$TransfTag	Lobatto	$W14X283	$numIntgrPts
element	forceBeamColumn	40068	677	686	$TransfTag	Lobatto	$W14X257_WA	$numIntgrPts
								
element	forceBeamColumn	40019	187	196	$TransfTag	Lobatto	$W14X233	$numIntgrPts
element	forceBeamColumn	40029	287	296	$TransfTag	Lobatto	$W14X257	$numIntgrPts
element	forceBeamColumn	40039	387	396	$TransfTag	Lobatto	$W14X257	$numIntgrPts
element	forceBeamColumn	40049	487	496	$TransfTag	Lobatto	$W14X257	$numIntgrPts
element	forceBeamColumn	40059	587	596	$TransfTag	Lobatto	$W14X257	$numIntgrPts
element	forceBeamColumn	40069	687	696	$TransfTag	Lobatto	$W14X233_WA	$numIntgrPts
								
element	forceBeamColumn	4001100	197	11006	$TransfTag	Lobatto	$W14X233	$numIntgrPts
element	forceBeamColumn	4002100	297	21006	$TransfTag	Lobatto	$W14X257	$numIntgrPts
element	forceBeamColumn	4003100	397	31006	$TransfTag	Lobatto	$W14X257	$numIntgrPts
element	forceBeamColumn	4004100	497	41006	$TransfTag	Lobatto	$W14X257	$numIntgrPts
element	forceBeamColumn	4005100	597	51006	$TransfTag	Lobatto	$W14X257	$numIntgrPts
element	forceBeamColumn	4006100	697	61006	$TransfTag	Lobatto	$W14X233_WA	$numIntgrPts
								
#Consolidated Frame								
element	forceBeamColumn	40071	1470008	     716	$TransfTag	Lobatto	$W14X500_WA_CF	$numIntgrPts
element	forceBeamColumn	40081	1480008	     816	$TransfTag	Lobatto	$W14X211_CF	$numIntgrPts
element	forceBeamColumn	40091	1490008	     916	$TransfTag	Lobatto	$W14X211_CF	$numIntgrPts
element	forceBeamColumn	400101	14100008	1016	$TransfTag	Lobatto	$W14X211_CF	$numIntgrPts
element	forceBeamColumn	400111	14110008	1116	$TransfTag	Lobatto	$W14X193_CF	$numIntgrPts
element	forceBeamColumn	400121	14120008	1216	$TransfTag	Lobatto	$W14X500_WA_CF	$numIntgrPts
								
element	forceBeamColumn	40072	717	726	$TransfTag	Lobatto	$W14X500_WA_CF	$numIntgrPts
element	forceBeamColumn	40082	817	826	$TransfTag	Lobatto	$W14X211_CF	$numIntgrPts
element	forceBeamColumn	40092	917	926	$TransfTag	Lobatto	$W14X211_CF	$numIntgrPts
element	forceBeamColumn	400102	1017	1026	$TransfTag	Lobatto	$W14X211_CF	$numIntgrPts
element	forceBeamColumn	400112	1117	1126	$TransfTag	Lobatto	$W14X193_CF	$numIntgrPts
element	forceBeamColumn	400122	1217	1226	$TransfTag	Lobatto	$W14X500_WA_CF	$numIntgrPts
								
element	forceBeamColumn	40073	727	736	$TransfTag	Lobatto	$W14X455_WA_CF	$numIntgrPts
element	forceBeamColumn	40083	827	836	$TransfTag	Lobatto	$W14X159_CF	$numIntgrPts
element	forceBeamColumn	40093	927	936	$TransfTag	Lobatto	$W14X159_CF	$numIntgrPts
element	forceBeamColumn	400103	1027	1036	$TransfTag	Lobatto	$W14X159_CF	$numIntgrPts
element	forceBeamColumn	400113	1127	1136	$TransfTag	Lobatto	$W14X145_CF	$numIntgrPts
element	forceBeamColumn	400123	1227	1236	$TransfTag	Lobatto	$W14X455_WA_CF	$numIntgrPts
								
element	forceBeamColumn	40074	737	746	$TransfTag	Lobatto	$W14X455_WA_CF	$numIntgrPts
element	forceBeamColumn	40084	837	846	$TransfTag	Lobatto	$W14X159_CF	$numIntgrPts
element	forceBeamColumn	40094	937	946	$TransfTag	Lobatto	$W14X159_CF	$numIntgrPts
element	forceBeamColumn	400104	1037	1046	$TransfTag	Lobatto	$W14X159_CF	$numIntgrPts
element	forceBeamColumn	400114	1137	1146	$TransfTag	Lobatto	$W14X145_CF	$numIntgrPts
element	forceBeamColumn	400124	1237	1246	$TransfTag	Lobatto	$W14X455_WA_CF	$numIntgrPts
								
element	forceBeamColumn	40075	747	756	$TransfTag	Lobatto	$W14X370_WA_CF	$numIntgrPts
element	forceBeamColumn	40085	847	856	$TransfTag	Lobatto	$W14X120_CF	$numIntgrPts
element	forceBeamColumn	40095	947	956	$TransfTag	Lobatto	$W14X120_CF	$numIntgrPts
element	forceBeamColumn	400105	1047	1056	$TransfTag	Lobatto	$W14X120_CF	$numIntgrPts
element	forceBeamColumn	400115	1147	1156	$TransfTag	Lobatto	$W14X109_CF	$numIntgrPts
element	forceBeamColumn	400125	1247	1256	$TransfTag	Lobatto	$W14X370_WA_CF	$numIntgrPts
								
element	forceBeamColumn	40076	757	766	$TransfTag	Lobatto	$W14X370_WA_CF	$numIntgrPts
element	forceBeamColumn	40086	857	866	$TransfTag	Lobatto	$W14X120_CF	$numIntgrPts
element	forceBeamColumn	40096	957	966	$TransfTag	Lobatto	$W14X120_CF	$numIntgrPts
element	forceBeamColumn	400106	1057	1066	$TransfTag	Lobatto	$W14X120_CF	$numIntgrPts
element	forceBeamColumn	400116	1157	1166	$TransfTag	Lobatto	$W14X109_CF	$numIntgrPts
element	forceBeamColumn	400126	1257	1266	$TransfTag	Lobatto	$W14X370_WA_CF	$numIntgrPts
								
element	forceBeamColumn	40077	767	776	$TransfTag	Lobatto	$W14X283_WA_CF	$numIntgrPts
element	forceBeamColumn	40087	867	876	$TransfTag	Lobatto	$W14X90_CF	$numIntgrPts
element	forceBeamColumn	40097	967	976	$TransfTag	Lobatto	$W14X90_CF	$numIntgrPts
element	forceBeamColumn	400107	1067	1076	$TransfTag	Lobatto	$W14X90_CF	$numIntgrPts
element	forceBeamColumn	400117	1167	1176	$TransfTag	Lobatto	$W14X82_CF	$numIntgrPts
element	forceBeamColumn	400127	1267	1276	$TransfTag	Lobatto	$W14X283_WA_CF	$numIntgrPts
								
element	forceBeamColumn	40078	777	786	$TransfTag	Lobatto	$W14X283_WA_CF	$numIntgrPts
element	forceBeamColumn	40088	877	886	$TransfTag	Lobatto	$W14X90_CF	$numIntgrPts
element	forceBeamColumn	40098	977	986	$TransfTag	Lobatto	$W14X90_CF	$numIntgrPts
element	forceBeamColumn	400108	1077	1086	$TransfTag	Lobatto	$W14X90_CF	$numIntgrPts
element	forceBeamColumn	400118	1177	1186	$TransfTag	Lobatto	$W14X82_CF	$numIntgrPts
element	forceBeamColumn	400128	1277	1286	$TransfTag	Lobatto	$W14X283_WA_CF	$numIntgrPts
								
element	forceBeamColumn	40079	787	796	$TransfTag	Lobatto	$W14X257_WA_CF	$numIntgrPts
element	forceBeamColumn	40089	887	896	$TransfTag	Lobatto	$W14X61_CF	$numIntgrPts
element	forceBeamColumn	40099	987	996	$TransfTag	Lobatto	$W14X61_CF	$numIntgrPts
element	forceBeamColumn	400109	1087	1096	$TransfTag	Lobatto	$W14X61_CF	$numIntgrPts
element	forceBeamColumn	400119	1187	1196	$TransfTag	Lobatto	$W14X48_CF	$numIntgrPts
element	forceBeamColumn	400129	1287	1296	$TransfTag	Lobatto	$W14X257_WA_CF	$numIntgrPts
								
element	forceBeamColumn	 4007100	 797	 71006	$TransfTag	Lobatto	$W14X257_WA_CF	$numIntgrPts
element	forceBeamColumn	 4008100	 897	 81006	$TransfTag	Lobatto	$W14X61_CF	$numIntgrPts
element	forceBeamColumn	 4009100	 997	 91006	$TransfTag	Lobatto	$W14X61_CF	$numIntgrPts
element	forceBeamColumn	40010100	1097	101006	$TransfTag	Lobatto	$W14X61_CF	$numIntgrPts
element	forceBeamColumn	40011100	1197	111006	$TransfTag	Lobatto	$W14X48_CF	$numIntgrPts
element	forceBeamColumn	40012100	1297	121006	$TransfTag	Lobatto	$W14X257_WA_CF	$numIntgrPts

puts "column definition done!"

# define beam sections

#HingeRadau
set Locations "0 [expr (8.0/3*$Lp_Beam)/$LBeam] [expr (4.0*$Lp_Beam+($LBeam-8*$Lp_Beam)/2*(1-1/sqrt(3)))/$LBeam] [expr (4.0*$Lp_Beam+ ($LBeam-8*$Lp_Beam)/2*(1+1/sqrt(3)))/$LBeam] [expr ($LBeam-8.0/3*$Lp_Beam)/$LBeam] 1.0";
set weights "[expr $Lp_Beam/$LBeam] [expr 3.0*$Lp_Beam/$LBeam] [expr (($LBeam-8.0*$Lp_Beam)/2)/$LBeam] [expr (($LBeam-8.0*$Lp_Beam)/2) /$LBeam] [expr 3.0*$Lp_Beam/$LBeam] [expr $Lp_Beam/$LBeam]";


set W36X160 1602;
set A     [expr 47*pow($in,2)];
set I     [expr 1.46*9760*pow($in,4)];
set d [expr 36.01*$in];
set bf [expr 12*$in];
set tf [expr 1.02*$in];
set tw [expr 0.65*$in];
set W [expr 624*pow($in,3)];
set My [expr $W*$Fy_beam];
#Lignos parameters
set LS [expr 0.978/$Lp_Beam];			# basic strength deterioration (a very large # = no cyclic deterioration)
set LK [expr 0.978/$Lp_Beam];			# unloading stiffness deterioration (a very large # = no cyclic deterioration)
set LA [expr 0.978/$Lp_Beam];			# accelerated reloading stiffness deterioration (a very large # = no cyclic deterioration)
set LD [expr 0.978/$Lp_Beam];			# post-capping strength deterioration (a very large # = no deterioration)
set cS 1.0;				# exponent for basic strength deterioration (c = 1.0 for no deterioration)
set cK 1.0;				# exponent for unloading stiffness deterioration (c = 1.0 for no deterioration)
set cA 1.0;				# exponent for accelerated reloading stiffness deterioration (c = 1.0 for no deterioration)
set cD 1.0;				# exponent for post-capping strength deterioration (c = 1.0 for no deterioration)
set th_pP [expr 0.0256/$Lp_Beam];		# plastic rot capacity for pos loading
set th_pN [expr 0.0256/$Lp_Beam];		# plastic rot capacity for neg loading
set th_pcP [expr 0.146/$Lp_Beam];			# post-capping rot capacity for pos loading
set th_pcN [expr 0.146/$Lp_Beam];			# post-capping rot capacity for neg loading
set ResP [expr 0.3];			# residual strength ratio for pos loading
set ResN [expr 0.3];			# residual strength ratio for neg loading
set th_uP [expr 0.4/$Lp_Beam];			# ultimate rot capacity for pos loading
set th_uN [expr 0.4/$Lp_Beam];			# ultimate rot capacity for neg loading
set DP 1.0;				# rate of cyclic deterioration for pos loading
set DN 1.0;				# rate of cyclic deterioration for neg loading
#definition of the moment-curvature elastic stiffness and strain-hardening
set Kspr [expr 6*$Es*$I/$LBeam*$Lp_Beam];
set strhard [expr (1.0*$My*(1.1 - 1.0)) / ($Kspr*$th_pP)];
#elastic material for axial and shear behavior
uniaxialMaterial Elastic [expr 200*$W36X160] [expr $Es*$A]   ;#elastic material to describe axial behavior
uniaxialMaterial Elastic [expr 300*$W36X160] [expr $G*$A]  ;#elastic material to describe shear behavior
#without deterioration
#uniaxialMaterial Steel01 [expr 400*$W36X160] [expr 1.0*$My] $Kspr [expr 0.03*6*$Es*$I/$LBeam/$Kspr] ;
#with deterioration
uniaxialMaterial Bilin02  [expr 400*$W36X160] $Kspr $strhard $strhard [expr 1.0*$My] [expr -1.0*$My] $LS $LK $LA $LD $cS $cK $cA $cD $th_pP $th_pN $th_pcP $th_pcN $ResP $ResN $th_uP $th_uN $DP $DN;
#sections for plastic hinges and middle element
section Aggregator $W36X160 [expr 200*$W36X160] P [expr 300*$W36X160] Vy [expr 400*$W36X160] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W36X160] $Es $A [expr 1.0*$I]  ;

set W36X135 1352;
set A   [expr 39.7*pow($in,2)];
set I   [expr 1.52*7800*pow($in,4)];
set d [expr 35.55*$in];
set bf [expr 11.95*$in];
set tf [expr 0.79*$in];
set tw [expr 0.6*$in];
set W [expr 509*pow($in,3)];
set My [expr $W*$Fy_beam];
#Lignos parameters
set LS [expr 0.757/$Lp_Beam];			# basic strength deterioration (a very large # = no cyclic deterioration)
set LK [expr 0.757/$Lp_Beam];			# unloading stiffness deterioration (a very large # = no cyclic deterioration)
set LA [expr 0.757/$Lp_Beam];			# accelerated reloading stiffness deterioration (a very large # = no cyclic deterioration)
set LD [expr 0.757/$Lp_Beam];			# post-capping strength deterioration (a very large # = no deterioration)
set cS 1.0;				# exponent for basic strength deterioration (c = 1.0 for no deterioration)
set cK 1.0;				# exponent for unloading stiffness deterioration (c = 1.0 for no deterioration)
set cA 1.0;				# exponent for accelerated reloading stiffness deterioration (c = 1.0 for no deterioration)
set cD 1.0;				# exponent for post-capping strength deterioration (c = 1.0 for no deterioration)
set th_pP [expr 0.0243/$Lp_Beam];		# plastic rot capacity for pos loading
set th_pN [expr 0.0243/$Lp_Beam];		# plastic rot capacity for neg loading
set th_pcP [expr 0.1148/$Lp_Beam];			# post-capping rot capacity for pos loading
set th_pcN [expr 0.1148/$Lp_Beam];			# post-capping rot capacity for neg loading
set ResP [expr 0.3];			# residual strength ratio for pos loading
set ResN [expr 0.3];			# residual strength ratio for neg loading
set th_uP [expr 0.4/$Lp_Beam];			# ultimate rot capacity for pos loading
set th_uN [expr 0.4/$Lp_Beam];			# ultimate rot capacity for neg loading
set DP 1.0;				# rate of cyclic deterioration for pos loading
set DN 1.0;				# rate of cyclic deterioration for neg loading
#definition of the moment-curvature elastic stiffness and strain-hardening
set Kspr [expr 6*$Es*$I/$LBeam*$Lp_Beam];
set strhard [expr (1.0*$My*(1.1 - 1.0)) / ($Kspr*$th_pP)];
#elastic material for axial and shear behavior
uniaxialMaterial Elastic [expr 200*$W36X135] [expr $Es*$A]   ;#elastic material to describe axial behavior
uniaxialMaterial Elastic [expr 300*$W36X135] [expr $G*$A]  ;#elastic material to describe shear behavior
#without deterioration
#uniaxialMaterial Steel01 [expr 400*$W36X135] [expr 1.0*$My] $Kspr [expr 0.03*6*$Es*$I/$LBeam/$Kspr] ;
#with deterioration
uniaxialMaterial Bilin02  [expr 400*$W36X135] $Kspr $strhard $strhard [expr 1.0*$My] [expr -1.0*$My] $LS $LK $LA $LD $cS $cK $cA $cD $th_pP $th_pN $th_pcP $th_pcN $ResP $ResN $th_uP $th_uN $DP $DN;
#sections for plastic hinges and middle element
section Aggregator $W36X135 [expr 200*$W36X135] P [expr 300*$W36X135] Vy [expr 400*$W36X135] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W36X135] $Es $A [expr 1.0*$I]  ;

set W30X99 9902;
set A   [expr 29.1*pow($in,2)];
set I   [expr 1.59*3990*pow($in,4)];
set d [expr 29.65*$in];
set bf [expr 10.45*$in];
set tf [expr 0.67*$in];
set tw [expr 0.52*$in];
set W [expr 312*pow($in,3)];
set My [expr $W*$Fy_beam];
#Lignos parameters
set LS [expr 0.783/$Lp_Beam];			# basic strength deterioration (a very large # = no cyclic deterioration)
set LK [expr 0.783/$Lp_Beam];			# unloading stiffness deterioration (a very large # = no cyclic deterioration)
set LA [expr 0.783/$Lp_Beam];			# accelerated reloading stiffness deterioration (a very large # = no cyclic deterioration)
set LD [expr 0.783/$Lp_Beam];			# post-capping strength deterioration (a very large # = no deterioration)
set cS 1.0;				# exponent for basic strength deterioration (c = 1.0 for no deterioration)
set cK 1.0;				# exponent for unloading stiffness deterioration (c = 1.0 for no deterioration)
set cA 1.0;				# exponent for accelerated reloading stiffness deterioration (c = 1.0 for no deterioration)
set cD 1.0;				# exponent for post-capping strength deterioration (c = 1.0 for no deterioration)
set th_pP [expr 0.0298/$Lp_Beam];		# plastic rot capacity for pos loading
set th_pN [expr 0.0298/$Lp_Beam];		# plastic rot capacity for neg loading
set th_pcP [expr 0.12/$Lp_Beam];			# post-capping rot capacity for pos loading
set th_pcN [expr 0.12/$Lp_Beam];			# post-capping rot capacity for neg loading
set ResP [expr 0.3];			# residual strength ratio for pos loading
set ResN [expr 0.3];			# residual strength ratio for neg loading
set th_uP [expr 0.4/$Lp_Beam];			# ultimate rot capacity for pos loading
set th_uN [expr 0.4/$Lp_Beam];			# ultimate rot capacity for neg loading
set DP 1.0;				# rate of cyclic deterioration for pos loading
set DN 1.0;				# rate of cyclic deterioration for neg loading
#definition of the moment-curvature elastic stiffness and strain-hardening
set Kspr [expr 6*$Es*$I/$LBeam*$Lp_Beam];
set strhard [expr (1.0*$My*(1.1 - 1.0)) / ($Kspr*$th_pP)];
#elastic material for axial and shear behavior
uniaxialMaterial Elastic [expr 200*$W30X99] [expr $Es*$A]   ;#elastic material to describe axial behavior
uniaxialMaterial Elastic [expr 300*$W30X99] [expr $G*$A]  ;#elastic material to describe shear behavior
#without deterioration
#uniaxialMaterial Steel01 [expr 400*$W30X99] [expr 1.0*$My] $Kspr [expr 0.03*6*$Es*$I/$LBeam/$Kspr] ;
#with deterioration
uniaxialMaterial Bilin02  [expr 400*$W30X99] $Kspr $strhard $strhard [expr 1.0*$My] [expr -1.0*$My] $LS $LK $LA $LD $cS $cK $cA $cD $th_pP $th_pN $th_pcP $th_pcN $ResP $ResN $th_uP $th_uN $DP $DN;
#sections for plastic hinges and middle element
section Aggregator $W30X99 [expr 200*$W30X99] P [expr 300*$W30X99] Vy [expr 400*$W30X99] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W30X99] $Es $A [expr 1.0*$I]  ;

set W27X84 9402;
set A  [expr 24.8*pow($in,2)];
set I  [expr 1.61*2850*pow($in,4)];
set d [expr 26.71*$in];
set bf [expr 9.96*$in];
set tf [expr 0.64*$in];
set tw [expr 0.46*$in];
set W [expr 244*pow($in,3)];
set My [expr $W*$Fy_beam];
#Lignos parameters
set LS [expr 0.768/$Lp_Beam];			# basic strength deterioration (a very large # = no cyclic deterioration)
set LK [expr 0.768/$Lp_Beam];			# unloading stiffness deterioration (a very large # = no cyclic deterioration)
set LA [expr 0.768/$Lp_Beam];			# accelerated reloading stiffness deterioration (a very large # = no cyclic deterioration)
set LD [expr 0.768/$Lp_Beam];			# post-capping strength deterioration (a very large # = no deterioration)
set cS 1.0;				# exponent for basic strength deterioration (c = 1.0 for no deterioration)
set cK 1.0;				# exponent for unloading stiffness deterioration (c = 1.0 for no deterioration)
set cA 1.0;				# exponent for accelerated reloading stiffness deterioration (c = 1.0 for no deterioration)
set cD 1.0;				# exponent for post-capping strength deterioration (c = 1.0 for no deterioration)
set th_pP [expr 0.03316/$Lp_Beam];		# plastic rot capacity for pos loading
set th_pN [expr 0.03316/$Lp_Beam];		# plastic rot capacity for neg loading
set th_pcP [expr 0.123/$Lp_Beam];			# post-capping rot capacity for pos loading
set th_pcN [expr 0.123/$Lp_Beam];			# post-capping rot capacity for neg loading
set ResP [expr 0.3];			# residual strength ratio for pos loading
set ResN [expr 0.3];			# residual strength ratio for neg loading
set th_uP [expr 0.4/$Lp_Beam];			# ultimate rot capacity for pos loading
set th_uN [expr 0.4/$Lp_Beam];			# ultimate rot capacity for neg loading
set DP 1.0;				# rate of cyclic deterioration for pos loading
set DN 1.0;				# rate of cyclic deterioration for neg loading
#definition of the moment-curvature elastic stiffness and strain-hardening
set Kspr [expr 6*$Es*$I/$LBeam*$Lp_Beam];
set strhard [expr (1.0*$My*(1.1 - 1.0)) / ($Kspr*$th_pP)];
#elastic material for axial and shear behavior
uniaxialMaterial Elastic [expr 200*$W27X84] [expr $Es*$A]   ;#elastic material to describe axial behavior
uniaxialMaterial Elastic [expr 300*$W27X84] [expr $G*$A]  ;#elastic material to describe shear behavior
#without deterioration
#uniaxialMaterial Steel01 [expr 400*$W27X84] [expr 1.0*$My] $Kspr [expr 0.03*6*$Es*$I/$LBeam/$Kspr] ;
#with deterioration
uniaxialMaterial Bilin02  [expr 400*$W27X84] $Kspr $strhard $strhard [expr 1.0*$My] [expr -1.0*$My] $LS $LK $LA $LD $cS $cK $cA $cD $th_pP $th_pN $th_pcP $th_pcN $ResP $ResN $th_uP $th_uN $DP $DN;
#sections for plastic hinges and middle element
section Aggregator $W27X84 [expr 200*$W27X84] P [expr 300*$W27X84] Vy [expr 400*$W27X84] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W27X84] $Es $A [expr 1.0*$I]  ;

set W24X68 6802;
set A   [expr 20.1*pow($in,2)];
set I   [expr 1.66*1830*pow($in,4)];
set d [expr 23.73*$in];
set bf [expr 8.965*$in];
set tf [expr 0.585*$in];
set tw [expr 0.415*$in];
set W [expr 177*pow($in,3)];
set My [expr $W*$Fy_beam];
#Lignos parameters
set LS [expr 0.793/$Lp_Beam];			# basic strength deterioration (a very large # = no cyclic deterioration)
set LK [expr 0.793/$Lp_Beam];			# unloading stiffness deterioration (a very large # = no cyclic deterioration)
set LA [expr 0.793/$Lp_Beam];			# accelerated reloading stiffness deterioration (a very large # = no cyclic deterioration)
set LD [expr 0.793/$Lp_Beam];			# post-capping strength deterioration (a very large # = no deterioration)
set cS 1.0;				# exponent for basic strength deterioration (c = 1.0 for no deterioration)
set cK 1.0;				# exponent for unloading stiffness deterioration (c = 1.0 for no deterioration)
set cA 1.0;				# exponent for accelerated reloading stiffness deterioration (c = 1.0 for no deterioration)
set cD 1.0;				# exponent for post-capping strength deterioration (c = 1.0 for no deterioration)
set th_pP [expr 0.0379/$Lp_Beam];		# plastic rot capacity for pos loading
set th_pN [expr 0.0379/$Lp_Beam];		# plastic rot capacity for neg loading
set th_pcP [expr 0.13/$Lp_Beam];			# post-capping rot capacity for pos loading
set th_pcN [expr 0.13/$Lp_Beam];			# post-capping rot capacity for neg loading
set ResP [expr 0.3];			# residual strength ratio for pos loading
set ResN [expr 0.3];			# residual strength ratio for neg loading
set th_uP [expr 0.4/$Lp_Beam];			# ultimate rot capacity for pos loading
set th_uN [expr 0.4/$Lp_Beam];			# ultimate rot capacity for neg loading
set DP 1.0;				# rate of cyclic deterioration for pos loading
set DN 1.0;				# rate of cyclic deterioration for neg loading
#definition of the moment-curvature elastic stiffness and strain-hardening
set Kspr [expr 6*$Es*$I/$LBeam*$Lp_Beam];
set strhard [expr (1.0*$My*(1.1 - 1.0)) / ($Kspr*$th_pP)];
#elastic material for axial and shear behavior
uniaxialMaterial Elastic [expr 200*$W24X68] [expr $Es*$A]   ;#elastic material to describe axial behavior
uniaxialMaterial Elastic [expr 300*$W24X68] [expr $G*$A]  ;#elastic material to describe shear behavior
#without deterioration
#uniaxialMaterial Steel01 [expr 400*$W24X68] [expr 1.0*$My] $Kspr [expr 0.03*6*$Es*$I/$LBeam/$Kspr] ;
#with deterioration
uniaxialMaterial Bilin02  [expr 400*$W24X68] $Kspr $strhard $strhard [expr 1.0*$My] [expr -1.0*$My] $LS $LK $LA $LD $cS $cK $cA $cD $th_pP $th_pN $th_pcP $th_pcN $ResP $ResN $th_uP $th_uN $DP $DN;
#sections for plastic hinges and middle element
section Aggregator $W24X68 [expr 200*$W24X68] P [expr 300*$W24X68] Vy [expr 400*$W24X68] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W24X68] $Es $A [expr 1.0*$I]  ;

puts "beam sections done!"

#beams

#Moment Resisting Frame													
element	forceBeamColumn	60011	1105	2110	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60021	2105	3110	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60031	3105	4110	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60041	4105	5110	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60051	5105	6111	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
													
element	forceBeamColumn	60012	1205	2210	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60022	2205	3210	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60032	3205	4210	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60042	4205	5210	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60052	5205	6211	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
													
element	forceBeamColumn	60013	1305	2310	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60023	2305	3310	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60033	3305	4310	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60043	4305	5310	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
element	forceBeamColumn	60053	5305	6311	$TransfTag	HingeRadau	$W36X160	$Lp_Beam	$W36X160	$Lp_Beam	[expr	500*$W36X160	];
													
element	forceBeamColumn	60014	1405	2410	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60024	2405	3410	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60034	3405	4410	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60044	4405	5410	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60054	5405	6411	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
													
element	forceBeamColumn	60015	1505	2510	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60025	2505	3510	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60035	3505	4510	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60045	4505	5510	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60055	5505	6511	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
													
element	forceBeamColumn	60016	1605	2610	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60026	2605	3610	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60036	3605	4610	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60046	4605	5610	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60056	5605	6611	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
													
element	forceBeamColumn	60017	1705	2710	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60027	2705	3710	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60037	3705	4710	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60047	4705	5710	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
element	forceBeamColumn	60057	5705	6711	$TransfTag	HingeRadau	$W36X135	$Lp_Beam	$W36X135	$Lp_Beam	[expr	500*$W36X135	];
													
element	forceBeamColumn	60018	1805	2810	$TransfTag	HingeRadau	$W30X99	$Lp_Beam	$W30X99	$Lp_Beam	[expr	500*$W30X99	];
element	forceBeamColumn	60028	2805	3810	$TransfTag	HingeRadau	$W30X99	$Lp_Beam	$W30X99	$Lp_Beam	[expr	500*$W30X99	];
element	forceBeamColumn	60038	3805	4810	$TransfTag	HingeRadau	$W30X99	$Lp_Beam	$W30X99	$Lp_Beam	[expr	500*$W30X99	];
element	forceBeamColumn	60048	4805	5810	$TransfTag	HingeRadau	$W30X99	$Lp_Beam	$W30X99	$Lp_Beam	[expr	500*$W30X99	];
element	forceBeamColumn	60058	5805	6811	$TransfTag	HingeRadau	$W30X99	$Lp_Beam	$W30X99	$Lp_Beam	[expr	500*$W30X99	];
													
element	forceBeamColumn	60019	1905	2910	$TransfTag	HingeRadau	$W27X84	$Lp_Beam	$W27X84	$Lp_Beam	[expr	500*$W27X84	];
element	forceBeamColumn	60029	2905	3910	$TransfTag	HingeRadau	$W27X84	$Lp_Beam	$W27X84	$Lp_Beam	[expr	500*$W27X84	];
element	forceBeamColumn	60039	3905	4910	$TransfTag	HingeRadau	$W27X84	$Lp_Beam	$W27X84	$Lp_Beam	[expr	500*$W27X84	];
element	forceBeamColumn	60049	4905	5910	$TransfTag	HingeRadau	$W27X84	$Lp_Beam	$W27X84	$Lp_Beam	[expr	500*$W27X84	];
element	forceBeamColumn	60059	5905	6911	$TransfTag	HingeRadau	$W27X84	$Lp_Beam	$W27X84	$Lp_Beam	[expr	500*$W27X84	];
													
element	forceBeamColumn	6001100	110005	210010	$TransfTag	HingeRadau	$W24X68	$Lp_Beam	$W24X68	$Lp_Beam	[expr	500*$W24X68	];
element	forceBeamColumn	6002100	210005	310010	$TransfTag	HingeRadau	$W24X68	$Lp_Beam	$W24X68	$Lp_Beam	[expr	500*$W24X68	];
element	forceBeamColumn	6003100	310005	410010	$TransfTag	HingeRadau	$W24X68	$Lp_Beam	$W24X68	$Lp_Beam	[expr	500*$W24X68	];
element	forceBeamColumn	6004100	410005	510010	$TransfTag	HingeRadau	$W24X68	$Lp_Beam	$W24X68	$Lp_Beam	[expr	500*$W24X68	];
element	forceBeamColumn	6005100	510005	610011	$TransfTag	HingeRadau	$W24X68	$Lp_Beam	$W24X68	$Lp_Beam	[expr	500*$W24X68	];
								
								
#Consolidated Frame					$A $E $Iz $transfTag 								
element	elasticBeamColumn 	60071	7111	8111	0.01677416	$Es	0.001269216	$TransfTag					
element	elasticBeamColumn 	60081	8112	9111	0.01677416	$Es	0.001269216	$TransfTag					
element	elasticBeamColumn 	60091	9112	10111	0.01677416	$Es	0.001269216	$TransfTag					
element	elasticBeamColumn 	600101	10112	11111	0.01677416	$Es	0.001269216	$TransfTag					
element	elasticBeamColumn 	600111	11112	12111	0.01677416	$Es	0.001269216	$TransfTag					
													
element	elasticBeamColumn 	60072	7211	8211	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60082	8212	9211	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60092	9212	10211	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600102	10212	11211	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600112	11212	12211	0.013290296	$Es	0.000794562	$TransfTag					
													
element	elasticBeamColumn 	60073	7311	8311	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60083	8312	9311	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60093	9312	10311	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600103	10312	11311	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600113	11312	12311	0.013290296	$Es	0.000794562	$TransfTag					
													
element	elasticBeamColumn 	60074	7411	8411	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60084	8412	9411	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60094	9412	10411	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600104	10412	11411	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600114	11412	12411	0.013290296	$Es	0.000794562	$TransfTag					
													
element	elasticBeamColumn 	60075	7511	8511	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60085	8512	9511	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60095	9512	10511	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600105	10512	11511	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600115	11512	12511	0.013290296	$Es	0.000794562	$TransfTag					
													
element	elasticBeamColumn 	60076	7611	8611	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60086	8612	9611	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60096	9612	10611	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600106	10612	11611	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600116	11612	12611	0.013290296	$Es	0.000794562	$TransfTag					
													
element	elasticBeamColumn 	60077	7711	8711	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60087	8712	9711	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60097	9712	10711	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600107	10712	11711	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600117	11712	12711	0.013290296	$Es	0.000794562	$TransfTag					
													
element	elasticBeamColumn 	60078	7811	8811	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60088	8812	9811	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60098	9812	10811	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600108	10812	11811	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600118	11812	12811	0.013290296	$Es	0.000794562	$TransfTag					
													
element	elasticBeamColumn 	60079	7911	8911	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60089	8912	9911	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	60099	9912	10911	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600109	10912	11911	0.013290296	$Es	0.000794562	$TransfTag					
element	elasticBeamColumn 	600119	11912	12911	0.013290296	$Es	0.000794562	$TransfTag					
													
element	elasticBeamColumn 	 6007100	 710011	 810011	0.009909658	$Es	0.000495303	$TransfTag					
element	elasticBeamColumn 	 6008100	 810012	 910011	0.013341909	$Es	0.000882259	$TransfTag					
element	elasticBeamColumn 	 6009100	 910012	1010011	0.013341909	$Es	0.000882259	$TransfTag					
element	elasticBeamColumn 	60010100	1010012	1110011	0.009909658	$Es	0.000495303	$TransfTag					
element	elasticBeamColumn 	60011100	1110012	1210011	0.009909658	$Es	0.000495303	$TransfTag					

puts "beam definition done!"

# define shear connections - reduced strength according to Gupta and Krawinkler (1999)
source shear_conn.tcl		
puts "shear conn done!"

# define panel zones - following Gupta and Krawinkler (1999)
source panel_zones.tcl
puts "panel zones done!"


# display the model with the node numbers
#	DisplayModel2D NodeNumbers


# Define RECORDERS -------------------------------------------------------------
#Nodal Displacements	
set Disp1 [recorder Node -file  $dataDir/Disp1.out -time -node  1110 -dof 1 2 3 disp];	
set Disp2 [recorder Node -file  $dataDir/Disp2.out -time -node  1210 -dof 1 2 3  disp];	
set Disp3 [recorder Node -file  $dataDir/Disp3.out -time -node  1310 -dof 1 2 3  disp];	
set Disp4 [recorder Node -file  $dataDir/Disp4.out -time -node  1410 -dof 1 2 3  disp];	
set Disp5 [recorder Node -file  $dataDir/Disp5.out -time -node  1510 -dof 1  2 3 disp];	
set Disp6 [recorder Node -file  $dataDir/Disp6.out -time -node  1610 -dof 1 2 3  disp];	
set Disp7 [recorder Node -file  $dataDir/Disp7.out -time -node  1710 -dof 1 2 3  disp];	
set Disp8 [recorder Node -file  $dataDir/Disp8.out -time -node  1810 -dof 1 2 3  disp];	
set Disp9 [recorder Node -file  $dataDir/Disp9.out -time -node  1910 -dof 1 2 3  disp];
set Disp10 [recorder Node -file $dataDir/Disp10.out -time -node 110010  -dof 1 2 3  disp];

#Base Reactions
set ReaMRF1 [recorder Node -file $dataDir/BaseReaMRF1.out -time -node 710008 -dof 1 2 3 reaction];
set ReaMRF2 [recorder Node -file $dataDir/BaseReaMRF2.out -time -node 720008 -dof 1 2 3 reaction];
set ReaMRF3 [recorder Node -file $dataDir/BaseReaMRF3.out -time -node 730008 -dof 1 2 3 reaction];
set ReaMRF4 [recorder Node -file $dataDir/BaseReaMRF4.out -time -node 740008 -dof 1 2 3 reaction];
set ReaMRF5 [recorder Node -file $dataDir/BaseReaMRF5.out -time -node 750008 -dof 1 2 3 reaction];
set ReaMRF6 [recorder Node -file $dataDir/BaseReaMRF6.out -time -node 760008 -dof 1 2 3 reaction];
set ReaCF1 [recorder Node -file $dataDir/BaseReaCF1.out -time -node 770008 -dof 1 2 3 reaction];
set ReaCF2 [recorder Node -file $dataDir/BaseReaCF2.out -time -node 780008 -dof 1 2 3 reaction];
set ReaCF3 [recorder Node -file $dataDir/BaseReaCF3.out -time -node 790008 -dof 1 2 3 reaction];
set ReaCF4 [recorder Node -file $dataDir/BaseReaCF4.out -time -node 7100008 -dof 1 2 3 reaction];
set ReaCF5 [recorder Node -file $dataDir/BaseReaCF5.out -time -node 7110008 -dof 1 2 3 reaction];
set ReaCF6 [recorder Node -file $dataDir/BaseReaCF6.out -time -node 7120008 -dof 1 2 3 reaction];
set ReaGr1 [recorder Node -file $dataDir/BaseReaGR1.out -time -node 1110  -dof 1  reaction];
set ReaGr2 [recorder Node -file $dataDir/BaseReaGR2.out -time -node 6110  -dof 1  reaction];
set ReaGr3 [recorder Node -file $dataDir/BaseReaGR3.out -time -node 7110  -dof 1  reaction];
set ReaGr4 [recorder Node -file $dataDir/BaseReaGR4.out -time -node 12110 -dof 1  reaction];

#Lateral Drift
set Drift1 [recorder Drift -file $dataDir/Drift1.out -time -iNode 710008 -jNode 1110 -dof 1  -perpDirn 2];		
set Drift2 [recorder Drift -file $dataDir/Drift2.out -time -iNode 1110   -jNode 1210   -dof 1  -perpDirn 2];
set Drift3 [recorder Drift -file $dataDir/Drift3.out -time -iNode 1210   -jNode 1310   -dof 1  -perpDirn 2];
set Drift4 [recorder Drift -file $dataDir/Drift4.out -time -iNode 1310     -jNode 1410 -dof 1  -perpDirn 2];
set Drift5 [recorder Drift -file $dataDir/Drift5.out -time -iNode 1410     -jNode 1510 -dof 1  -perpDirn 2];
set Drift6 [recorder Drift -file $dataDir/Drift6.out -time -iNode 1510     -jNode 1610 -dof 1  -perpDirn 2];
set Drift7 [recorder Drift -file $dataDir/Drift7.out -time -iNode 1610     -jNode 1710 -dof 1  -perpDirn 2];
set Drift8 [recorder Drift -file $dataDir/Drift8.out -time -iNode 1710     -jNode 1810 -dof 1  -perpDirn 2];
set Drift9 [recorder Drift -file $dataDir/Drift9.out -time -iNode 1810     -jNode 1910  -dof 1  -perpDirn 2];
set Drift10 [recorder Drift -file $dataDir/Drift10.out -time -iNode 1910     -jNode 110010  -dof 1  -perpDirn 2];

#Column Forces
set COL11 [recorder Element -file $dataDir/FColMRF11.out -time -ele 40011 globalForce];	
set COL21 [recorder Element -file $dataDir/FColMRF21.out -time -ele 40021 globalForce];	
set COL71 [recorder Element -file $dataDir/FColGF11.out -time -ele 40071 globalForce];	
set COL81 [recorder Element -file $dataDir/FColGF21.out -time -ele 40081 globalForce];	
set COL12 [recorder Element -file $dataDir/FColMRF12.out -time -ele 40012 globalForce];	
set COL22 [recorder Element -file $dataDir/FColMRF22.out -time -ele 40022 globalForce];	
set COL72 [recorder Element -file $dataDir/FColGF12.out -time -ele 40072 globalForce];	
set COL82 [recorder Element -file $dataDir/FColGF22.out -time -ele 40082 globalForce];	
set COL13 [recorder Element -file $dataDir/FColMRF13.out -time -ele 40013 globalForce];	
set COL23 [recorder Element -file $dataDir/FColMRF23.out -time -ele 40023 globalForce];	
set COL73 [recorder Element -file $dataDir/FColGF13.out -time -ele 40073 globalForce];	
set COL83 [recorder Element -file $dataDir/FColGF23.out -time -ele 40083 globalForce];	
set COL14 [recorder Element -file $dataDir/FColMRF14.out -time -ele 40014 globalForce];	
set COL24 [recorder Element -file $dataDir/FColMRF24.out -time -ele 40024 globalForce];	
set COL74 [recorder Element -file $dataDir/FColGF14.out -time -ele 40074 globalForce];	
set COL84 [recorder Element -file $dataDir/FColGF24.out -time -ele 40084 globalForce];	
set COL15 [recorder Element -file $dataDir/FColMRF15.out -time -ele 40015 globalForce];	
set COL25 [recorder Element -file $dataDir/FColMRF25.out -time -ele 40025 globalForce];	
set COL75 [recorder Element -file $dataDir/FColGF15.out -time -ele 40075 globalForce];	
set COL85 [recorder Element -file $dataDir/FColGF25.out -time -ele 40085 globalForce];	
set COL16 [recorder Element -file $dataDir/FColMRF16.out -time -ele 40016 globalForce];	
set COL26 [recorder Element -file $dataDir/FColMRF26.out -time -ele 40026 globalForce];	
set COL76 [recorder Element -file  $dataDir/FColGF16.out -time -ele 40076 globalForce];	
set COL86 [recorder Element -file  $dataDir/FColGF26.out -time -ele 40086 globalForce];	
set COL17 [recorder Element -file $dataDir/FColMRF17.out -time -ele 40017 globalForce];	
set COL27 [recorder Element -file $dataDir/FColMRF27.out -time -ele 40027 globalForce];	
set COL77 [recorder Element -file  $dataDir/FColGF17.out -time -ele 40077 globalForce];	
set COL87 [recorder Element -file  $dataDir/FColGF27.out -time -ele 40087 globalForce];	
set COL18 [recorder Element -file $dataDir/FColMRF18.out -time -ele 40018 globalForce];	
set COL28 [recorder Element -file $dataDir/FColMRF28.out -time -ele 40028 globalForce];	
set COL78 [recorder Element -file  $dataDir/FColGF18.out -time -ele 40078 globalForce];	
set COL88 [recorder Element -file  $dataDir/FColGF28.out -time -ele 40088 globalForce];	
set COL19 [recorder Element -file $dataDir/FColMRF19.out -time -ele 40019 globalForce];	
set COL29 [recorder Element -file $dataDir/FColMRF29.out -time -ele 40029 globalForce];	
set COL79 [recorder Element -file  $dataDir/FColGF19.out -time -ele 40079 globalForce];	
set COL89 [recorder Element -file  $dataDir/FColGF29.out -time -ele 40089 globalForce];	
set COL110 [recorder Element -file $dataDir/FColMRF110.out -time -ele 4001100 globalForce];	
set COL210 [recorder Element -file $dataDir/FColMRF210.out -time -ele 4002100 globalForce];	
set COL710 [recorder Element -file  $dataDir/FColGF110.out -time -ele 4007100 globalForce];	
set COL810 [recorder Element -file  $dataDir/FColGF210.out -time -ele 4008100 globalForce];	

#Column stress-strain deformation
set COL21Sec1 [recorder Element -file $dataDir/FColMRF21Sec1_SS.out -time -ele 40021 section 1 fiber 0.50 0.10 stressStrain];
set COL22Sec1 [recorder Element -file $dataDir/FColMRF22Sec1_SS.out -time -ele 40022 section 1 fiber 0.50 0.10 stressStrain];
set COL23Sec1 [recorder Element -file $dataDir/FColMRF23Sec1_SS.out -time -ele 40023 section 1 fiber 0.50 0.10 stressStrain];
set COL24Sec1 [recorder Element -file $dataDir/FColMRF24Sec1_SS.out -time -ele 40024 section 1 fiber 0.50 0.10 stressStrain];
set COL25Sec1 [recorder Element -file $dataDir/FColMRF25Sec1_SS.out -time -ele 40025 section 1 fiber 0.50 0.10 stressStrain];
set COL26Sec1 [recorder Element -file $dataDir/FColMRF26Sec1_SS.out -time -ele 40026 section 1 fiber 0.50 0.10 stressStrain];
set COL27Sec1 [recorder Element -file $dataDir/FColMRF27Sec1_SS.out -time -ele 40027 section 1 fiber 0.50 0.10 stressStrain];
set COL28Sec1 [recorder Element -file $dataDir/FColMRF28Sec1_SS.out -time -ele 40028 section 1 fiber 0.50 0.10 stressStrain];
set COL29Sec1 [recorder Element -file $dataDir/FColMRF29Sec1_SS.out -time -ele 40029 section 1 fiber 0.50 0.10 stressStrain];
set COL210Sec1 [recorder Element -file $dataDir/FColMRF210Sec1_SS.out -time -ele 4002100 section 1 fiber 0.50 0.10 stressStrain];
set COL81Sec1 [recorder Element -file $dataDir/FColGF81Sec1_SS.out -time -ele 40081 section 1 fiber 0.50 0.10 stressStrain];
set COL82Sec1 [recorder Element -file $dataDir/FColGF82Sec1_SS.out -time -ele 40082 section 1 fiber 0.50 0.10 stressStrain];
set COL83Sec1 [recorder Element -file $dataDir/FColGF83Sec1_SS.out -time -ele 40083 section 1 fiber 0.50 0.10 stressStrain];
set COL84Sec1 [recorder Element -file $dataDir/FColGF84Sec1_SS.out -time -ele 40084 section 1 fiber 0.50 0.10 stressStrain];
set COL85Sec1 [recorder Element -file $dataDir/FColGF85Sec1_SS.out -time -ele 40085 section 1 fiber 0.50 0.10 stressStrain];
set COL86Sec1 [recorder Element -file $dataDir/FColGF86Sec1_SS.out -time -ele 40086 section 1 fiber 0.50 0.10 stressStrain];
set COL87Sec1 [recorder Element -file $dataDir/FColGF87Sec1_SS.out -time -ele 40087 section 1 fiber 0.50 0.10 stressStrain];
set COL88Sec1 [recorder Element -file $dataDir/FColGF88Sec1_SS.out -time -ele 40088 section 1 fiber 0.50 0.10 stressStrain];
set COL89Sec1 [recorder Element -file $dataDir/FColGF89Sec1_SS.out -time -ele 40089 section 1 fiber 0.50 0.10 stressStrain];
set COL810Sec1 [recorder Element -file $dataDir/FColGF810Sec1_SS.out -time -ele 4008100 section 1 fiber 0.50 0.10 stressStrain];

#Beam Forces
set Beam21 [recorder Element -file $dataDir/FBeamMRF21.out -time -ele 60021 globalForce];
set Beam22 [recorder Element -file $dataDir/FBeamMRF22.out -time -ele 60022 globalForce];
set Beam23 [recorder Element -file $dataDir/FBeamMRF23.out -time -ele 60023 globalForce];
set Beam24 [recorder Element -file $dataDir/FBeamMRF24.out -time -ele 60024 globalForce];
set Beam25 [recorder Element -file $dataDir/FBeamMRF25.out -time -ele 60025 globalForce];
set Beam26 [recorder Element -file $dataDir/FBeamMRF26.out -time -ele 60026 globalForce];
set Beam27 [recorder Element -file $dataDir/FBeamMRF27.out -time -ele 60027 globalForce];
set Beam28 [recorder Element -file $dataDir/FBeamMRF28.out -time -ele 60028 globalForce];
set Beam29 [recorder Element -file $dataDir/FBeamMRF29.out -time -ele 60029 globalForce];
set Beam210 [recorder Element -file $dataDir/FBeamMRF210.out -time -ele 6002100 globalForce];

#Beam Section Deformation	
set SectDefo21Sec1 [recorder Element -file $dataDir/BeamDefMRF21Sec1.out -time -ele 60021 section 1 deformation];	
set SectDefo21Sec6 [recorder Element -file $dataDir/BeamDefMRF21Sec6.out -time -ele 60021 section 6 deformation];
set SectDefo22Sec1 [recorder Element -file $dataDir/BeamDefMRF22Sec1.out -time -ele 60022 section 1 deformation];	
set SectDefo22Sec6 [recorder Element -file $dataDir/BeamDefMRF22Sec6.out -time -ele 60022 section 6 deformation];
set SectDefo23Sec1 [recorder Element -file $dataDir/BeamDefMRF23Sec1.out -time -ele 60023 section 1 deformation];	
set SectDefo23Sec6 [recorder Element -file $dataDir/BeamDefMRF23Sec6.out -time -ele 60023 section 6 deformation];
set SectDefo24Sec1 [recorder Element -file $dataDir/BeamDefMRF24Sec1.out -time -ele 60024 section 1 deformation];	
set SectDefo24Sec6 [recorder Element -file $dataDir/BeamDefMRF24Sec6.out -time -ele 60024 section 6 deformation];
set SectDefo25Sec1 [recorder Element -file $dataDir/BeamDefMRF25Sec1.out -time -ele 60025 section 1 deformation];	
set SectDefo25Sec6 [recorder Element -file $dataDir/BeamDefMRF25Sec6.out -time -ele 60025 section 6 deformation];
set SectDefo26Sec1 [recorder Element -file $dataDir/BeamDefMRF26Sec1.out -time -ele 60026 section 1 deformation];	
set SectDefo26Sec6 [recorder Element -file $dataDir/BeamDefMRF26Sec6.out -time -ele 60026 section 6 deformation];
set SectDefo27Sec1 [recorder Element -file $dataDir/BeamDefMRF27Sec1.out -time -ele 60027 section 1 deformation];	
set SectDefo27Sec6 [recorder Element -file $dataDir/BeamDefMRF27Sec6.out -time -ele 60027 section 6 deformation];
set SectDefo28Sec1 [recorder Element -file $dataDir/BeamDefMRF28Sec1.out -time -ele 60028 section 1 deformation];	
set SectDefo28Sec6 [recorder Element -file $dataDir/BeamDefMRF28Sec6.out -time -ele 60028 section 6 deformation];
set SectDefo29Sec1 [recorder Element -file $dataDir/BeamDefMRF29Sec1.out -time -ele 60029 section 1 deformation];	
set SectDefo29Sec6 [recorder Element -file $dataDir/BeamDefMRF29Sec6.out -time -ele 60029 section 6 deformation];
set SectDefo210Sec1 [recorder Element -file $dataDir/BeamDefMRF210Sec1.out -time -ele 6002100 section 1 deformation];	
set SectDefo210Sec6 [recorder Element -file $dataDir/BeamDefMRF210Sec6.out -time -ele 6002100 section 6 deformation];

#Panel Zone Forces and Distortion
set PZForce21 [recorder Element -file $dataDir/ForcePZMRF21.out -time -ele 42100 force];
set PZForce22 [recorder Element -file $dataDir/ForcePZMRF22.out -time -ele 42200 force];
set PZForce23 [recorder Element -file $dataDir/ForcePZMRF23.out -time -ele 42300 force];
set PZForce24 [recorder Element -file $dataDir/ForcePZMRF24.out -time -ele 42400 force];
set PZForce25 [recorder Element -file $dataDir/ForcePZMRF25.out -time -ele 42500 force];
set PZForce26 [recorder Element -file $dataDir/ForcePZMRF26.out -time -ele 42600 force];
set PZForce27 [recorder Element -file $dataDir/ForcePZMRF27.out -time -ele 42700 force];
set PZForce28 [recorder Element -file $dataDir/ForcePZMRF28.out -time -ele 42800 force];
set PZForce29 [recorder Element -file $dataDir/ForcePZMRF29.out -time -ele 42900 force];
set PZForce210 [recorder Element -file $dataDir/ForcePZMRF210.out -time -ele 4210000 force];
set PZForce81 [recorder Element -file $dataDir/ForcePZGF81.out -time -ele 48100 force];
set PZForce82 [recorder Element -file $dataDir/ForcePZGF82.out -time -ele 48200 force];
set PZForce83 [recorder Element -file $dataDir/ForcePZGF83.out -time -ele 48300 force];
set PZForce84 [recorder Element -file $dataDir/ForcePZGF84.out -time -ele 48400 force];
set PZForce85 [recorder Element -file $dataDir/ForcePZGF85.out -time -ele 48500 force];
set PZForce86 [recorder Element -file $dataDir/ForcePZGF86.out -time -ele 48600 force];
set PZForce87 [recorder Element -file $dataDir/ForcePZGF87.out -time -ele 48700 force];
set PZForce88 [recorder Element -file $dataDir/ForcePZGF88.out -time -ele 48800 force];
set PZForce89 [recorder Element -file $dataDir/ForcePZGF89.out -time -ele 48900 force];
set PZForce810 [recorder Element -file $dataDir/ForcePZGF810.out -time -ele 4810000 force];

set PZDist21 [recorder Element -file $dataDir/DistPZMRF21.out -time -ele 42100 deformation];
set PZDist22 [recorder Element -file $dataDir/DistPZMRF22.out -time -ele 42200 deformation];
set PZDist23 [recorder Element -file $dataDir/DistPZMRF23.out -time -ele 42300 deformation];
set PZDist24 [recorder Element -file $dataDir/DistPZMRF24.out -time -ele 42400 deformation];
set PZDist25 [recorder Element -file $dataDir/DistPZMRF25.out -time -ele 42500 deformation];
set PZDist26 [recorder Element -file $dataDir/DistPZMRF26.out -time -ele 42600 deformation];
set PZDist27 [recorder Element -file $dataDir/DistPZMRF27.out -time -ele 42700 deformation];
set PZDist28 [recorder Element -file $dataDir/DistPZMRF28.out -time -ele 42800 deformation];
set PZDist29 [recorder Element -file $dataDir/DistPZMRF29.out -time -ele 42900 deformation];
set PZDist210 [recorder Element -file $dataDir/DistPZMRF210.out -time -ele 4210000 deformation];
set PZDist81 [recorder Element -file $dataDir/DistPZGF81.out -time -ele 48100 deformation];
set PZDist82 [recorder Element -file $dataDir/DistPZGF82.out -time -ele 48200 deformation];
set PZDist83 [recorder Element -file $dataDir/DistPZGF83.out -time -ele 48300 deformation];
set PZDist84 [recorder Element -file $dataDir/DistPZGF84.out -time -ele 48400 deformation];
set PZDist85 [recorder Element -file $dataDir/DistPZGF85.out -time -ele 48500 deformation];
set PZDist86 [recorder Element -file $dataDir/DistPZGF86.out -time -ele 48600 deformation];
set PZDist87 [recorder Element -file $dataDir/DistPZGF87.out -time -ele 48700 deformation];
set PZDist88 [recorder Element -file $dataDir/DistPZGF88.out -time -ele 48800 deformation];
set PZDist89 [recorder Element -file $dataDir/DistPZGF89.out -time -ele 48900 deformation];
set PZDist810 [recorder Element -file $dataDir/DistPZGF810.out -time -ele 4810000 deformation];

#Shear Connection Forces and Distortion
set SCForce21 [recorder Element -file $dataDir/ForceSCMRF21.out -time -ele 72100 force];
set SCForce22 [recorder Element -file $dataDir/ForceSCMRF22.out -time -ele 72200 force];
set SCForce23 [recorder Element -file $dataDir/ForceSCMRF23.out -time -ele 72300 force];
set SCForce24 [recorder Element -file $dataDir/ForceSCMRF24.out -time -ele 72400 force];
set SCForce25 [recorder Element -file $dataDir/ForceSCMRF25.out -time -ele 72500 force];
set SCForce26 [recorder Element -file $dataDir/ForceSCMRF26.out -time -ele 72600 force];
set SCForce27 [recorder Element -file $dataDir/ForceSCMRF27.out -time -ele 72700 force];
set SCForce28 [recorder Element -file $dataDir/ForceSCMRF28.out -time -ele 72800 force];
set SCForce29 [recorder Element -file $dataDir/ForceSCMRF29.out -time -ele 72900 force];
set SCForce210 [recorder Element -file $dataDir/ForceSCMRF210.out -time -ele 7210000 force];
set SCForce81 [recorder Element -file $dataDir/ForceSCGF81.out -time -ele 78100 force];
set SCForce82 [recorder Element -file $dataDir/ForceSCGF82.out -time -ele 78200 force];
set SCForce83 [recorder Element -file $dataDir/ForceSCGF83.out -time -ele 78300 force];
set SCForce84 [recorder Element -file $dataDir/ForceSCGF84.out -time -ele 78400 force];
set SCForce85 [recorder Element -file $dataDir/ForceSCGF85.out -time -ele 78500 force];
set SCForce86 [recorder Element -file $dataDir/ForceSCGF86.out -time -ele 78600 force];
set SCForce87 [recorder Element -file $dataDir/ForceSCGF87.out -time -ele 78700 force];
set SCForce88 [recorder Element -file $dataDir/ForceSCGF88.out -time -ele 78800 force];
set SCForce89 [recorder Element -file $dataDir/ForceSCGF89.out -time -ele 78900 force];
set SCForce810 [recorder Element -file $dataDir/ForceSCGF810.out -time -ele 7810000 force];

set SCRot21 [recorder Element -file $dataDir/RotSCMRF21.out -time -ele 72100 deformation];
set SCRot22 [recorder Element -file $dataDir/RotSCMRF22.out -time -ele 72200 deformation];
set SCRot23 [recorder Element -file $dataDir/RotSCMRF23.out -time -ele 72300 deformation];
set SCRot24 [recorder Element -file $dataDir/RotSCMRF24.out -time -ele 72400 deformation];
set SCRot25 [recorder Element -file $dataDir/RotSCMRF25.out -time -ele 72500 deformation];
set SCRot26 [recorder Element -file $dataDir/RotSCMRF26.out -time -ele 72600 deformation];
set SCRot27 [recorder Element -file $dataDir/RotSCMRF27.out -time -ele 72700 deformation];
set SCRot28 [recorder Element -file $dataDir/RotSCMRF28.out -time -ele 72800 deformation];
set SCRot29 [recorder Element -file $dataDir/RotSCMRF29.out -time -ele 72900 deformation];
set SCRot210 [recorder Element -file $dataDir/RotSCMRF210.out -time -ele 7210000 deformation];
set SCRot81 [recorder Element -file $dataDir/RotSCGF81.out -time -ele 78100 deformation];
set SCRot82 [recorder Element -file $dataDir/RotSCGF82.out -time -ele 78200 deformation];
set SCRot83 [recorder Element -file $dataDir/RotSCGF83.out -time -ele 78300 deformation];
set SCRot84 [recorder Element -file $dataDir/RotSCGF84.out -time -ele 78400 deformation];
set SCRot85 [recorder Element -file $dataDir/RotSCGF85.out -time -ele 78500 deformation];
set SCRot86 [recorder Element -file $dataDir/RotSCGF86.out -time -ele 78600 deformation];
set SCRot87 [recorder Element -file $dataDir/RotSCGF87.out -time -ele 78700 deformation];
set SCRot88 [recorder Element -file $dataDir/RotSCGF88.out -time -ele 78800 deformation];
set SCRot89 [recorder Element -file $dataDir/RotSCGF89.out -time -ele 78900 deformation];
set SCRot810 [recorder Element -file $dataDir/RotSCGF810.out -time -ele 7810000 deformation];

puts "recorders done!"

# define GRAVITY -------------------------------------------------------------
source loads.tcl
puts "load definition done!"

# ------------------------------------------------- apply gravity load ------
set Tol 1.0e-6;			# convergence tolerance for test
constraints Transformation;     		
numberer RCM;			
system ProfileSPD;		
test NormDispIncr $Tol 10 0; 	
algorithm Newton;		# use Newton's solution algorithm: updates tangent stiffness at every iteration
integrator LoadControl 0.1;	# use load increment of 0.1 times the applied linear load pattern;
analysis Static;		# define type of analysis static or transient
analyze 10;			# apply gravity in 10 steps
# ------------------------------------------------- maintain constant gravity loads and reset time to zero
loadConst -time 0.0     	
						# keep previous loading constant and reset pseudo-time to zero

puts "Model Built"


###
##	Eigen Analysis
###

	set pi [expr 2.0*asin(1.0)];						# Definition of pi
	set nEigenI 1;										# mode i = 1
	set nEigenJ 5;										# mode j = 2
	set lambdaN [eigen [expr $nEigenJ]];				# eigenvalue analysis for nEigenJ modes
	set lambda1 [lindex $lambdaN [expr $nEigenI-1]];	# eigenvalue mode i = 1
	set lambda2 [lindex $lambdaN [expr $nEigenI]];	# eigenvalue mode i = 1
	set lambda3 [lindex $lambdaN [expr $nEigenI+1]];	# eigenvalue mode i = 1
	set lambda4 [lindex $lambdaN [expr $nEigenI+2]];	# eigenvalue mode i = 1
	set lambda5 [lindex $lambdaN [expr $nEigenI+3]];	# eigenvalue mode i = 1
	set w1 [expr pow($lambda1,0.5)];					# w1 (1st mode circular frequency)
	set w2 [expr pow($lambda2,0.5)];					# w2 (2nd mode circular frequency)
	set w3 [expr pow($lambda3,0.5)];					# w1 (1st mode circular frequency)
	set w4 [expr pow($lambda4,0.5)];					# w1 (1st mode circular frequency)
	set w5 [expr pow($lambda5,0.5)];					# w1 (1st mode circular frequency)
	set T1 [expr 2.0*$pi/$w1];							# 1st mode period of the structure
	set T2 [expr 2.0*$pi/$w2];							# 2nd mode period of the structure
	set T3 [expr 2.0*$pi/$w3];							# 1st mode period of the structure
	set T4 [expr 2.0*$pi/$w4];							# 1st mode period of the structure
	set T5 [expr 2.0*$pi/$w5];							# 1st mode period of the structure
	puts "EigenValue Analysis:";
	puts "T1 = $T1 s";									# display the first mode period in the command window
	puts "T2 = $T2 s";									# display the second mode period in the command window
	puts "T3 = $T3 s";									# display the first mode period in the command window
	puts "T4 = $T4 s";									# display the first mode period in the command window
	puts "T5 = $T5 s";									# display the first mode period in the command window

	
set analisys_type 1; # pushover = 1; dynamic = 2

####################################################################################################################################################################
## Pushover Analysis
####################################################################################################################################################################

if { $analisys_type == 1 } {

puts "running pushover...";
set Hload "1";		# define the lateral load

pattern Plain 200 Linear {;			# define load pattern
#load 1110 [expr $Hload*0.03] 0 0  ;
load 1210 [expr $Hload*0.03] 0 0 ;
load 1310 [expr $Hload*0.05] 0 0 ;
load 1410 [expr $Hload*0.07] 0 0 ;
load 1510 [expr $Hload*0.09] 0 0 ;
load 1610 [expr $Hload*0.11] 0 0 ;
load 1710 [expr $Hload*0.13] 0 0 ;
load 1810 [expr $Hload*0.15] 0 0 ;
load 1910 [expr $Hload*0.17] 0 0 ;
load 110010 [expr $Hload*0.20] 0 0 ;
}

#  ---------------------------------    perform Static Pushover Analysis

# integrator   DisplControl  $tagnode  $dof  $displacement increment for each step
integrator DisplacementControl 110010 1 0.001
test NormDispIncr 1.0e-6 20 0
system ProfileSPD
numberer RCM
constraints Transformation
algorithm KrylovNewton
analysis Static

analyze 4000

} elseif { $analisys_type == 2 } {
####################################################################################################################################################################
##  Dynamic Analysis
####################################################################################################################################################################

puts "Running dynamic analysis..."
		# display deformed shape:
		#set ViewScale 10;	# amplify display of deformed shape
		#DisplayModel2D DeformedShape $ViewScale;	# display deformed shape, the scaling factor needs to be adjusted for each model
	
	# source ReadSMDfile.tcl;		# procedure for reading GM file and converting it to proper format

#	# Bidirectional Uniform Earthquake ground motion (uniform acceleration input at all support nodes)
	# set iGMfile $Qake ;		# ground-motion filename
	# set iGMfact $Qake_factor;			# ground-motion scaling factor
#
	set iGMdirection "1";			# ground-motion direction
	# set up ground-motion-analysis parameters
	set DtAnalysis	[expr 0.005*$sec];	# time-step Dt for lateral analysis

	
# DYNAMIC ANALYSIS PARAMETERS
constraints Transformation ; 
numberer RCM
system ProfileSPD
set Tol 1.e-6;                        # Convergence Test: tolerance
test NormDispIncr $Tol 100 0;
algorithm Newton;        
set NewmarkGamma 0.5;	# Newmark-integrator gamma parameter (also HHT)
set NewmarkBeta 0.25;	# Newmark-integrator beta parameter
integrator Newmark $NewmarkGamma $NewmarkBeta 
analysis Transient

	
# define DAMPING--------------------------------------------------------------------------------------
# apply Rayleigh DAMPING from $xDamp
# D=$alphaM*M + $betaKcurr*Kcurrent + $betaKcomm*KlastCommit + $beatKinit*$Kinitial
set xDamp 0.02;				# 2% damping ratio
set MpropSwitch 1.0;
set KcurrSwitch 0.0;
set KcommSwitch 0.0;
set KinitSwitch 1.0;
set nEigenI 1; # mode 1
set nEigenJ 6; # mode 6
set nEigenModes 8;
set lambdaN [eigen -generalized $nEigenModes]; # eigenvalue analysis for nEigenJ modes
set lambda0 [lindex $lambdaN 0]; # eigenvalue mode i
set lambda1 [lindex $lambdaN 1]; # eigenvalue mode i
set lambda2 [lindex $lambdaN 2]; # eigenvalue mode i
set lambda3 [lindex $lambdaN 3]; # eigenvalue mode i
set lambda4 [lindex $lambdaN 4]; # eigenvalue mode i
set lambda5 [lindex $lambdaN 5]; # eigenvalue mode i
set lambda6 [lindex $lambdaN 6]; # eigenvalue mode i
set lambda7 [lindex $lambdaN 7]; # eigenvalue mode i
set omega0 [expr pow($lambda0,0.5)];
set omega1 [expr pow($lambda1,0.5)];
set omega2 [expr pow($lambda2,0.5)];
set omega3 [expr pow($lambda3,0.5)];
set omega4 [expr pow($lambda4,0.5)];
set omega5 [expr pow($lambda5,0.5)];
set omega6 [expr pow($lambda6,0.5)];
set omega7 [expr pow($lambda7,0.5)];
set T0 [expr (2.*$PI)/$omega0];
set T1 [expr (2.*$PI)/$omega1];
set T2 [expr (2.*$PI)/$omega2];
set T3 [expr (2.*$PI)/$omega3];
set T4 [expr (2.*$PI)/$omega4];
set T5 [expr (2.*$PI)/$omega5];
set T6 [expr (2.*$PI)/$omega6];
set T7 [expr (2.*$PI)/$omega7];
set omega1 [expr (2.*$PI)/$T0];
set omega5 [expr (2.*$PI)/0.2];
puts "T = $T0 $T1 $T2 $T3 $T4 $T5 $T6 $T7 ";
set alphaM    [expr $MpropSwitch*$xDamp*(2*$omega1*$omega5)/($omega1+$omega5)]; # M-prop. damping; D = alphaM*M
set betaKcurr [expr $KcurrSwitch*2.*$xDamp/($omega1+$omega5)];         # current-K;      +beatKcurr*KCurrent
set betaKcomm [expr $KcommSwitch*2.*$xDamp/($omega1+$omega5)];   # last-committed K;   +betaKcomm*KlastCommitt
set betaKinit [expr $KinitSwitch*2.*$xDamp/($omega1+$omega5)];         # initial-K;     +beatKinit*Kini
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; # RAYLEIGH damping




	#  ---------------------------------    perform Dynamic Ground-Motion Analysis
	# the following commands are unique to the Uniform Earthquake excitation
	set IDloadTag 400;	# for uniformSupport excitation
	# Uniform EXCITATION: acceleration input
	# foreach GMdirection $iGMdirection GMfile $Qake GMfact $Qake_factor {
	# incr IDloadTag;
	# set inFile $GMfile
	# set outFile $GMfile.g3;			# set variable holding new filename (PEER files have .at2/dt2 extension)
	# ReadSMDFile $inFile $outFile dt;			# call procedure to convert the ground-motion file
	# set GMfatt [expr $GMfact];			# data in input file is in g Unifts -- ACCELERATION TH
	timeSeries Path $IDloadTag -dt 0.02 -filePath $Qake -factor  $Qake_factor;		# time series information
	pattern UniformExcitation  $IDloadTag  1 -accel  $IDloadTag  ;	# create Unifform excitation
	# }
	set TmaxAnalysis	[expr 2674*0.02*$sec  + 0.0*$sec];	# maximum duration of ground-motion analysis 


#Nodal veloccity
#set VelG1 [recorder Node -file VelG1.out -timeSeries $IDloadTag -time -node 1 -dof 1 vel];
#set VelG [recorder Node -file VelG.out -timeSeries $IDloadTag -time -node 7 -dof 1 vel];
#set Vel1 [recorder Node -file Vel1.out -timeSeries $IDloadTag -time -node 13 -dof 1 vel];
#set Vel2 [recorder Node -file Vel2.out -timeSeries $IDloadTag -time -node 19 -dof 1 vel];
#set Vel3 [recorder Node -file Vel3.out -timeSeries $IDloadTag -time -node 25 -dof 1 vel];
#set Vel4 [recorder Node -file Vel4.out -timeSeries $IDloadTag -time -node 31 -dof 1 vel];
#set Vel5 [recorder Node -file Vel5.out -timeSeries $IDloadTag -time -node 37 -dof 1 vel];
#set Vel6 [recorder Node -file Vel6.out -timeSeries $IDloadTag -time -node 43 -dof 1 vel];
#set Vel7 [recorder Node -file Vel7.out -timeSeries $IDloadTag -time -node 49 -dof 1 vel];
#set Vel8 [recorder Node -file Vel8.out -timeSeries $IDloadTag -time -node 55 -dof 1 vel];
#set Vel9 [recorder Node -file Vel9.out -timeSeries $IDloadTag -time -node 61 -dof 1 vel];

#Nodal acceleration
#set AcelG1 [recorder Node -file AcelG1.out -timeSeries $IDloadTag -time -node 1 -dof 1 accel];
#set AcelG [recorder Node -file AcelG.out -timeSeries $IDloadTag -time -node 7 -dof 1 accel];
#set Acel1 [recorder Node -file Acel1.out -timeSeries $IDloadTag -time -node 13 -dof 1 accel];
#set Acel2 [recorder Node -file Acel2.out -timeSeries $IDloadTag -time -node 19 -dof 1 accel];
#set Acel3 [recorder Node -file Acel3.out -timeSeries $IDloadTag -time -node 25 -dof 1 accel];
#set Acel4 [recorder Node -file Acel4.out -timeSeries $IDloadTag -time -node 31 -dof 1 accel];
#set Acel5 [recorder Node -file Acel5.out -timeSeries $IDloadTag -time -node 37 -dof 1 accel];
#set Acel6 [recorder Node -file Acel6.out -timeSeries $IDloadTag -time -node 43 -dof 1 accel];
#set Acel7 [recorder Node -file Acel7.out -timeSeries $IDloadTag -time -node 49 -dof 1 accel];
#set Acel8 [recorder Node -file Acel8.out -timeSeries $IDloadTag -time -node 55 -dof 1 accel];
#set Acel9 [recorder Node -file Acel9.out -timeSeries $IDloadTag -time -node 61 -dof 1 accel];


#--------------------------------  perform analysis-------------------------
set NumSteps [expr int($TmaxAnalysis/$DtAnalysis)];
	
set Niter 1;
set disp_61 0;
set drift1 0;
set drift2 0;
set drift3 0;
set drift4 0;
set drift5 0;
set drift6 0;
set drift7 0;
set drift8 0;
set drift9 0;
set acel10 0;
set acel2 0;
set acel3 0;
set acel4 0;
set acel5 0;
set acel6 0;
set acel7 0;
set acel8 0;
set acel9 0;
set corte_basal 0;
set curvatura 0;
set rotura 0;
set time_ajust 0;
set time 0;
set ok 0;

puts "running mainshock..." ;

while {$time < $TmaxAnalysis  &&  $ok == 0} {    

	algorithm Newton;
	test NormDispIncr $Tol 1000 0;
	set ok [analyze 1 $DtAnalysis];	# ok = 0 if analysis was completed
	

if {$ok != 0} {      					# analysis was not successful.
	# --------------------------------------------------------------------------------------------------
	# change some analysis parameters to achieve convergence
	# performance is slower inside this loop
	#    Time-controlled analysis
	set ok 0;
	set controlTime [getTime];
	test NormDispIncr $Tol 1000 0;
#	set controlTime [getTime];
#	while {$controlTime < $GMtime && $ok == 0} 
#		set controlTime [getTime]
		puts "trying with a smaller time-step";
		set dt_analysis_2 [expr $DtAnalysis/20];
		set ok [analyze 20 $dt_analysis_2];
		if {$ok != 0} {
		puts "trying with a larger tolerance";
			set Tol_2 [expr $Tol*10000];
			algorithm Newton;
			test NormDispIncr $Tol_2 1000 1;
			set ok [analyze 1 $DtAnalysis]
		}
		if {$ok != 0} {
			puts "Trying with Modified Newton..."
			algorithm ModifiedNewton;
			test NormDispIncr $Tol 2000 1;
			set ok [analyze 1 $DtAnalysis]
		}
		if {$ok != 0} {
			puts "Trying with Newton with Initial Tangent .."
			algorithm Newton -initial;
			test NormDispIncr $Tol 2000 1;
			set ok [analyze 1 $DtAnalysis]
		}		
if {$ok == 0} {
puts "problem solved; time: [getTime]";
}
};			# end if ok !0

	if { $ok < 0 } {
	puts "Análise Dinâmica imcompleta - Colapso durante o sismo principal (mainshock)";
	set Niter [expr $NumSteps+1];
	set time_ajust 1E5;
	}
		
#	set disp_inic_7  [nodeDisp   7  1 ];
#	set disp_inic_13 [nodeDisp   13 1];
#	set disp_inic_19 [nodeDisp   19  1];
#	set disp_inic_25 [nodeDisp   25  1];
#	set disp_inic_31 [nodeDisp   31 1];
#	set disp_inic_37 [nodeDisp   37 1];
#	set disp_inic_43 [nodeDisp   43 1];
#	set disp_inic_49 [nodeDisp   49 1];
#	set disp_inic_55 [nodeDisp   55  1];
#	set disp_inic_61 [nodeDisp   61  1];
#	
#	set acel_inic_2 [ nodeAccel  13 1];
#	set acel_inic_3 [ nodeAccel  19  1];
#	set acel_inic_4 [ nodeAccel  25  1];
#	set acel_inic_5 [ nodeAccel  31 1];
#	set acel_inic_6 [ nodeAccel  37 1];
#	set acel_inic_7 [ nodeAccel  43 1];
#	set acel_inic_8 [ nodeAccel  49 1];
#	set acel_inic_9 [ nodeAccel  55  1];
#	set acel_inic_10 [ nodeAccel  61  1];
#
#	
#	if { [expr abs($disp_inic_61)] > [expr abs($disp_61)] } {
#		set disp_61 $disp_inic_61;
#	}
#	
#		set drift_inic_1 [expr $disp_inic_13 - $disp_inic_7];
#		set drift_inic_2 [expr $disp_inic_19 - $disp_inic_13];
#		set drift_inic_3 [expr $disp_inic_25 - $disp_inic_19];	
#		set drift_inic_4 [expr $disp_inic_31 - $disp_inic_25];
#		set drift_inic_5 [expr $disp_inic_37 - $disp_inic_31];
#		set drift_inic_6 [expr $disp_inic_43 - $disp_inic_37];	
#		set drift_inic_7 [expr $disp_inic_49 - $disp_inic_43];
#		set drift_inic_8 [expr $disp_inic_55 - $disp_inic_49];
#		set drift_inic_9 [expr $disp_inic_61 - $disp_inic_55];	
#	
#	if { [expr abs($drift_inic_1)] > [expr abs($drift1)] } {
#		set drift1 [expr $drift_inic_1];
#	}
#	if { [expr abs($drift_inic_2)] > [expr abs($drift2)] } {
#		set drift2 [expr $drift_inic_2];
#	}
#	if { [expr abs($drift_inic_3)] > [expr abs($drift3)] } {
#		set drift3 [expr $drift_inic_3];
#	}
#	if { [expr abs($drift_inic_4)] > [expr abs($drift4)] } {
#		set drift4 [expr $drift_inic_4];
#	}
#	if { [expr abs($drift_inic_5)] > [expr abs($drift5)] } {
#		set drift5 [expr $drift_inic_5];
#	}
#	if { [expr abs($drift_inic_6)] > [expr abs($drift6)] } {
#		set drift6 [expr $drift_inic_6];
#	}
#	if { [expr abs($drift_inic_7)] > [expr abs($drift7)] } {
#		set drift7 [expr $drift_inic_7];
#	}
#	if { [expr abs($drift_inic_8)] > [expr abs($drift8)] } {
#		set drift8 [expr $drift_inic_8];
#	}
#	if { [expr abs($drift_inic_9)] > [expr abs($drift9)] } {
#		set drift9 [expr $drift_inic_9];
#	}
#	
#	if { [expr abs($acel_inic_10)] > [expr abs($acel10)] } {
#		set acel10 [expr $acel_inic_10];
#	}
#	if { [expr abs($acel_inic_2)] > [expr abs($acel2)] } {
#		set acel2 [expr $acel_inic_2];
#	}
#	if { [expr abs($acel_inic_3)] > [expr abs($acel3)] } {
#		set acel3 [expr $acel_inic_3];
#	}
#	if { [expr abs($acel_inic_4)] > [expr abs($acel4)] } {
#		set acel4 [expr $acel_inic_4];
#	}
#	if { [expr abs($acel_inic_5)] > [expr abs($acel5)] } {
#		set acel5 [expr $acel_inic_5];
#	}
#	if { [expr abs($acel_inic_6)] > [expr abs($acel6)] } {
#		set acel6 [expr $acel_inic_6];
#	}
#	if { [expr abs($acel_inic_7)] > [expr abs($acel7)] } {
#		set acel7 [expr $acel_inic_7];
#	}
#	if { [expr abs($acel_inic_8)] > [expr abs($acel8)] } {
#		set acel8 [expr $acel_inic_8];
#	}
#	if { [expr abs($acel_inic_9)] > [expr abs($acel9)] } {
#		set acel9 [expr $acel_inic_9];
#	}
	
	#set listofforces1 [eleResponse 1 forces];
	#set listofforces2 [eleResponse 2 forces];
	#set listofforces3 [eleResponse 3 forces];
	#set listofforces4 [eleResponse 4 forces];
	#set listofforces5 [eleResponse 5 forces];
	#set listofforces6 [eleResponse 6 forces];
	#set listofforces71 [eleResponse 1 forces];
	#set listofforces72 [eleResponse 7 forces];
	#set listofforces73 [eleResponse 61 forces];
	#set listofforces74 [eleResponse 11011 forces];
	#set listofforces121 [eleResponse 6 forces];
	#set listofforces122 [eleResponse 12 forces];
	#set listofforces123 [eleResponse 65 forces];
	#set listofforces124 [eleResponse 11015 forces];
	#set V1 [lindex $listofforces1 0];
	#set V2 [lindex $listofforces2 0];
	#set V3 [lindex $listofforces3 0];
	#set V4 [lindex $listofforces4 0];
	#set V5 [lindex $listofforces5 0];
	#set V6 [lindex $listofforces6 0];
	#set V71 [lindex $listofforces71  3];
	#set V72 [lindex $listofforces72  0];
	#set V73 [lindex $listofforces73  0];
	#set V74 [lindex $listofforces74  0];
	#set V121 [lindex $listofforces121  3];
	#set V122 [lindex $listofforces122  0];
	#set V123 [lindex $listofforces123  3];
	#set V124 [lindex $listofforces124  3];
	#set V7 [expr $V71+$V72+$V73+$V74];
	#set V12 [expr $V121+$V122+$V123+$V124];
	#
	#set corte_basal_inic [expr $V1+$V2+$V3+$V4+$V5+$V6+$V7+$V12];
	#if { [expr abs($corte_basal_inic)] > [expr abs($corte_basal)] } {
	#	set corte_basal $corte_basal_inic;
	#}
	
	
	#set listofforces6 [eleResponse 2 section 1 deformations];
	#set curvatura_inic [lindex $listofforces6 1];
	#if { [expr abs($curvatura_inic)] > [expr abs($curvatura)] } {
	#	set curvatura $curvatura_inic;
	#}
	

	#if { [expr abs($disp_61)] > [expr 0.05*($LCol2+$LCol3*8)] } {
	#set rotura 1;
	#puts "Análise Dinâmica imcompleta - Colapso durante o sismo principal (mainshock) (disp61)";
	#} elseif { [expr abs($drift1)] > [expr 0.06*$LCol2] } {
	#set rotura 1;
	#puts "Análise Dinâmica imcompleta - Colapso durante o sismo principal (mainshock) (drift1)";
	#} elseif { [expr abs($drift2)] > [expr 0.06*$LCol3] } {
	#set rotura 1;
	#puts "Análise Dinâmica imcompleta - Colapso durante o sismo principal (mainshock) (drift2)";
	#} elseif { [expr abs($drift3)] > [expr 0.06*$LCol3] } {
	#set rotura 1;
	#puts "Análise Dinâmica imcompleta - Colapso durante o sismo principal (mainshock) (drift3)";
	#} elseif { [expr abs($drift4)] > [expr 0.06*$LCol3] } {
	#set rotura 1;
	#puts "Análise Dinâmica imcompleta - Colapso durante o sismo principal (mainshock) (drift4)";
	#} elseif { [expr abs($drift5)] > [expr 0.06*$LCol3] } {
	#set rotura 1;
	#puts "Análise Dinâmica imcompleta - Colapso durante o sismo principal (mainshock) (drift5)";
	#} elseif { [expr abs($drift6)] > [expr 0.06*$LCol3] } {
	#set rotura 1;
	#puts "Análise Dinâmica imcompleta - Colapso durante o sismo principal (mainshock) (drift6)";
	#} elseif { [expr abs($drift7)] > [expr 0.06*$LCol3] } {
	#set rotura 1;
	#puts "Análise Dinâmica imcompleta - Colapso durante o sismo principal (mainshock) (drift7)";
	#} elseif { [expr abs($drift8)] > [expr 0.06*$LCol3] } {
	#set rotura 1;
	#puts "Análise Dinâmica imcompleta - Colapso durante o sismo principal (mainshock) (drift8)";
	#} elseif { [expr abs($drift9)] > [expr 0.06*$LCol3] } {
	#set rotura 1;
	#puts "Análise Dinâmica imcompleta - Colapso durante o sismo principal (mainshock) (drift9)";
	#}
	#
	#if { [expr abs($disp_61)] > [expr 0.15*($LCol2+$LCol3*8)] || [expr abs($drift1)] > [expr 0.15*$LCol2] || [expr abs($drift2)] > [expr 0.15*$LCol3] || [expr abs($drift3)] > [expr 0.15*$LCol3] } {
	#set Niter [expr $NumSteps+1];
	#set time_ajust 1E5;
	#}
	
	set Niter [expr $Niter +1 ];
	set time [expr [getTime] + $time_ajust];
	}
	
	
		#file escrecer resultados
		#set collapse_mainshock "Collapse_mainshock.txt";
		#set Collapse_mainshock [open $collapse_mainshock "w"];


if {$ok == 0} {
			if {$rotura == 0} {
			puts "Dynamic analysis complete";
			#puts $Collapse_mainshock " Nao houve rotura ";
			} else {
			puts "Dynamic analysis imcomplete - excessive deformation";
			#puts $Collapse_mainshock " Ocorreu rotura ";
			}
		} else {
			puts "Dynamic analysis did not converge";
			#puts $Collapse_mainshock " Ocorreu rotura ";
		}	
		
			#escrever resultados
		#set displacements_mainshock "Displacements_mainshock.txt";
		#set Displacements_mainshock [open $displacements_mainshock "w"];
		
		#puts "$disp_61	$drift1	$drift2	$drift3	$drift4	$drift5	$drift6	$drift7	$drift8	$drift9	$acel10	$acel2	$acel3	$acel4	$acel5	$acel6	$acel7	$acel8	$acel9	$corte_basal	$curvatura	";
		#puts $Displacements_mainshock "$disp_61	$drift1	$drift2	$drift3	$drift4	$drift5	$drift6	$drift7	$drift8	$drift9	$acel10	$acel2	$acel3	$acel4	$acel5	$acel6	$acel7	$acel8	$acel9	$corte_basal	$curvatura	";
		#close $Displacements_mainshock		
		#close $Collapse_mainshock

# output time at end of analysis	
set currentTime [getTime];	# get current analysis time	(after dynamic analysis)
puts "The current time is: $currentTime (Total time: $TmaxAnalysis)";




};
wipe;
