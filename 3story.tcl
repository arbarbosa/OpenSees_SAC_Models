# --------------------------------------------------------------------------------------------------
# 2D Portal Frame--  3-Story Moment Frame with Distributed Plasticity Model with:
#						a) modIMK (modified Ibarra-Medina-Krawinkler material behaviour (Lignos, 2011)
#					OR	b) elastic sections
	
# Created by: Filipe Ribeiro, 2012 (f.ribeiro@fct.unl.pt)

#   Units: m, kN, sec. 

## source external files
	source LibUnits.tcl;			# define system units
	#source DisplayModel2D.tcl;			# procedure for displaying a 2D perspective of model
	#source DisplayPlane.tcl;			# procedure for displaying a plane in the model
	source Wsection.tcl;		# procedure for defining bilinear plastic hinge section

## INPUTs
set Qake "GM.AT2";
set Qake_factor "$g*1.";
set npts_accelerogram 2995;   
set dt_accelerogram 0.01;	

## OUTPUTs
set file_results [open "Peak_Results.out" "w"];

## RUN MODEL

# SET UP ----------------------------------------------------------------------------
wipe;						# clear memory of all past model definitions
model BasicBuilder -ndm 2 -ndf 3;	# Define the model builder, $ndm-D, $ndf dofs

# ## results directory
 set dataDir Data;		# set up name of directory where output will be written to
 file mkdir $dataDir; 			# create directory
	
	
# define GEOMETRY -------------------------------------------------------------
set LCol [expr 3.96*$m]; 			# column length
set LBeam [expr 9.15*$m];		# beam length
set Weight_Piso1 [expr 4.784E6*$N]; 		# superstructure weight
set Weight_Piso2 [expr 4.784E6*$N]; 
set Weight_Piso3 [expr 5.185E6*$N]; 
set mass_Piso1 [expr $Weight_Piso1/$g];
set mass_Piso2 [expr $Weight_Piso2/$g];
set mass_Piso3 [expr $Weight_Piso3/$g];

# calculated parameters
set PFloor1_ext [expr $Weight_Piso1/8 ]; 			# nodal dead-load weight 	
set PFloor1_int [expr $Weight_Piso1/4 ]; 			# nodal dead-load weight 	
set PFloor2_ext [expr $Weight_Piso2/8 ]; 			# nodal dead-load weight  
set PFloor2_int [expr $Weight_Piso2/4 ]; 			# nodal dead-load weight  
set PFloor3_ext [expr $Weight_Piso3/8 ]; 			# nodal dead-load weight 
set PFloor3_int [expr $Weight_Piso3/4 ]; 			# nodal dead-load weight

set mass1_ext [expr $mass_Piso1/8 ]; 			# nodal mass
set mass1_int [expr $mass_Piso1/4 ]; 			# nodal mass 	
set mass2_ext [expr $mass_Piso2/8 ]; 			# nodal mass  
set mass2_int [expr $mass_Piso2/4 ]; 			# nodal mass  
set mass3_ext [expr $mass_Piso3/8 ]; 			# nodal mass 
set mass3_int [expr $mass_Piso3/4 ]; 			# nodal mass 


# nodal coordinates:
node 1 0 0;
node 2 $LBeam 0;			# node#, X, Y
node 3 [expr 2*$LBeam] 0;
node 4 [expr 3*$LBeam] 0;
node 5 [expr 4*$LBeam] 0;
node 6 0 $LCol  -mass $mass1_ext $Usmall $Usmall;
node 7 [expr $LBeam] $LCol  -mass $mass1_int $Usmall $Usmall;
node 8 [expr 2*$LBeam] $LCol  -mass $mass1_int $Usmall $Usmall;
node 9 [expr 3*$LBeam] $LCol  -mass $mass1_int $Usmall $Usmall;
node 92 [expr 3*$LBeam] $LCol ;		# the right end nodes are hinged so we create two nodes at the same location and then restrain only the translational DOFs
node 10 [expr 4*$LBeam] $LCol  -mass $mass1_ext $Usmall $Usmall;
node 102 [expr 4*$LBeam] $LCol ;
node 11 0 [expr 2*$LCol]  -mass $mass2_ext $Usmall $Usmall;
node 12 [expr $LBeam] [expr 2*$LCol]  -mass $mass2_int $Usmall $Usmall;
node 13 [expr 2*$LBeam] [expr 2*$LCol]  -mass $mass2_int $Usmall $Usmall;
node 14 [expr 3*$LBeam] [expr 2*$LCol]  -mass $mass2_int $Usmall $Usmall;
node 142 [expr 3*$LBeam] [expr 2*$LCol] ;
node 15 [expr 4*$LBeam] [expr 2*$LCol]  -mass $mass2_ext $Usmall $Usmall;
node 152 [expr 4*$LBeam] [expr 2*$LCol] ;
node 16 0 [expr 3*$LCol]  -mass $mass3_ext $Usmall $Usmall;
node 17 [expr $LBeam] [expr 3*$LCol]  -mass $mass3_int $Usmall $Usmall;
node 18 [expr 2*$LBeam] [expr 3*$LCol]  -mass $mass3_int $Usmall $Usmall;
node 19 [expr 3*$LBeam] [expr 3*$LCol]  -mass $mass3_int $Usmall $Usmall;
node 192 [expr 3*$LBeam] [expr 3*$LCol] ;
node 20 [expr 4*$LBeam] [expr 3*$LCol]  -mass $mass3_ext $Usmall $Usmall;
node 202 [expr 4*$LBeam] [expr 3*$LCol] ;


# Single point constraints -- Boundary Conditions
fix 1 1 1 1; 			# node DX DY RZ
fix 2 1 1 1; 			# node DX DY RZ
fix 3 1 1 1;
fix 4 1 1 1;
fix 5 1 1 1;

# additional constraints - the right end nodes are hinged so we create two nodes at the same location and then restrain only the translational DOFs
equalDOF 9 92 1 2
equalDOF 10 102 1 2
equalDOF 14 142 1 2
equalDOF 15 152 1 2
equalDOF 19 192 1 2
equalDOF 20 202 1 2

# rigid-diaphragm
uniaxialMaterial Elastic 100 [expr 1E5*$GPa];
element truss 101 6 7 1 100;
element truss 102 7 8 1 100;
element truss 103 8 9  1 100;
element truss 104 9 10  1 100;
element truss 201 11 12   1 100;
element truss 202 12 13  1 100;
element truss 203 13 14  1 100;
element truss 204 14 15  1 100;
element truss 301 16 17   1 100;
element truss 302 17 18  1 100;
element truss 303 18 19  1 100;
element truss 304 19 20  1 100;

# P-DELTA LEANING COLUMN
#additional nodes
node 5500 		[expr 5*$LBeam] 0;
node 10500 	[expr 5*$LBeam] $LCol 
node 15500		[expr 5*$LBeam] [expr $LCol + $LCol ]  
node 20500		[expr 5*$LBeam] [expr $LCol + $LCol + $LCol ] ;
#fix base node
fix 5500 1 1 0;
# rigid links to the structure
geomTransf PDelta 28;
#truss elements
element truss   12500   10    10500 		[expr 100*9760*pow($in,4)]  100;
element truss   18500   15    15500 		[expr 100*9760*pow($in,4)]  100;
element truss   24500   20    20500 		[expr 100*9760*pow($in,4)]  100;
#vertical elements
element elasticBeamColumn  12510	   5500 	   10500        [expr 1000*9760*pow($in,4)]	200E6	[expr 1E-6*9760*pow($in,4)]		28;    
element elasticBeamColumn  18510     10500       15500        [expr 1000*9760*pow($in,4)]	200E6	[expr 1E-6*9760*pow($in,4)]		28;
element elasticBeamColumn  24510     15500       20500        [expr 1000*9760*pow($in,4)]	200E6	[expr 1E-6*9760*pow($in,4)]		28;


###################################################################################################
#          Define Section Properties and Elements													  
###################################################################################################
# define material properties
	set Es [expr 200*$GPa];			# modulus of steel
	set G [expr 89*$GPa];
	set Fy_column [expr 344.7*$MPa];
	set Fy_beam [expr 339.3*$MPa];
	
	#plastic hinge lengths and ratios
	set Lp_Col [expr $LCol/6];
	set Lp_Beam [expr $LBeam/6];
	
	#parameters for column elasto-plastic fiber sections
	set Bs 0.03;				# strain-hardening ratio 
	set R0 18;				# control the transition from elastic to plastic branches
	set cR1 0.925;				# control the transition from elastic to plastic branches
	set cR2 0.15;				# control the transition from elastic to plastic branches

	set IDSteel_column 1
	uniaxialMaterial Steel02 $IDSteel_column $Fy_column $Es $Bs  $R0 $cR1 $cR2;
	# uniaxialMaterial Elastic $IDSteel_column $Es;

	
# define column sections - distributed plasticity with fiber-sections
set W14x257 257;
set d [expr 16.38*$in];
set bf [expr 15.995*$in];
set tf [expr 1.89*$in];
set tw [expr 1.175*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14x257 $IDSteel_column $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14x311 311;
set d [expr 17.12*$in];
set bf [expr 16.23*$in];
set tf [expr 2.26*$in];
set tw [expr 1.41*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14x311 $IDSteel_column $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14x68 68; 
set d [expr 14.04*$in];
set bf [expr 10.035*$in];
set tf [expr 0.72*$in];
set tw [expr 0.415*$in];
set nfdw 8;		# number of fibers along dw
set nftw 8;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 8;			# number of fibers along tf
	set dw [expr $d - 2 * $tf]
	set y1 [expr -$d/2]
	set y2 [expr -$dw/2]
	set y3 [expr  $dw/2]
	set y4 [expr  $d/2]
  
	set z1 [expr -$bf/2]
	set z2 [expr -$tw/2]
	set z3 [expr  $tw/2]
	set z4 [expr  $bf/2]
  
	section fiberSec  $W14x68  {
   	#                     nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL	
		patch quadr  $IDSteel_column  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   		patch quadr  $IDSteel_column  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   		patch quadr  $IDSteel_column  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}


# define beam sections - beam-with-hinges with moment-curvature relationship

set W33x118 118;
set d [expr 32.86*$in];
set bf [expr 11.48*$in];
set tf [expr 0.74*$in];
set tw [expr 0.55*$in];
set I [expr 5900*$in4];
set A [expr 34.7*$in2];
set My [expr 415*$in3*$Fy_beam];
set MyW33x118 [expr 415*$in3*$Fy_beam];
#Lignos parameters
set LS [expr 0.74/$Lp_Beam];			# basic strength deterioration (a very large # = no cyclic deterioration)
set LK [expr 0.74/$Lp_Beam];			# unloading stiffness deterioration (a very large # = no cyclic deterioration)
set LA [expr 0.74/$Lp_Beam];			# accelerated reloading stiffness deterioration (a very large # = no cyclic deterioration)
set LD [expr 0.74/$Lp_Beam];			# post-capping strength deterioration (a very large # = no deterioration)
set cS 1.0;				# exponent for basic strength deterioration (c = 1.0 for no deterioration)
set cK 1.0;				# exponent for unloading stiffness deterioration (c = 1.0 for no deterioration)
set cA 1.0;				# exponent for accelerated reloading stiffness deterioration (c = 1.0 for no deterioration)
set cD 1.0;				# exponent for post-capping strength deterioration (c = 1.0 for no deterioration)
set th_pP [expr 0.026/$Lp_Beam];		# plastic rot capacity for pos loading
set th_pN [expr 0.026/$Lp_Beam];		# plastic rot capacity for neg loading
set th_pcP [expr 0.114/$Lp_Beam];			# post-capping rot capacity for pos loading
set th_pcN [expr 0.114/$Lp_Beam];			# post-capping rot capacity for neg loading
set ResP [expr 0.4];			# residual strength ratio for pos loading
set ResN [expr 0.4];			# residual strength ratio for neg loading
set th_uP [expr 0.4/$Lp_Beam];			# ultimate rot capacity for pos loading
set th_uN [expr 0.4/$Lp_Beam];			# ultimate rot capacity for neg loading
set DP 1.0;				# rate of cyclic deterioration for pos loading
set DN 1.0;				# rate of cyclic deterioration for neg loading
#definition of the moment-curvature elastic stiffness and strain-hardening
set Kspr [expr 6*$Es*$I/$LBeam*$Lp_Beam];
set strhard [expr (1.0*$My*(1.1 - 1.0)) / ($Kspr*$th_pP)];
#elastic material for axial and shear behavior
uniaxialMaterial Elastic [expr 200*$W33x118] [expr $Es*$A]   ;#elastic material to describe axial behavior
uniaxialMaterial Elastic [expr 300*$W33x118] [expr $G*$A]  ;#elastic material to describe shear behavior
# flexural - without deterioration
#uniaxialMaterial Steel01 [expr 400*$W33x118] [expr 1.0*$My] $Kspr [expr 0.03*6*$Es*$I/$LBeam/$Kspr] ;
# flexural - with deterioration
uniaxialMaterial Bilin02  [expr 400*$W33x118] $Kspr $strhard $strhard [expr 1.0*$My] [expr -1.0*$My] $LS $LK $LA $LD $cS $cK $cA $cD $th_pP $th_pN $th_pcP $th_pcN $ResP $ResN $th_uP $th_uN $DP $DN;
# flexural - elastic
# uniaxialMaterial Elastic [expr 400*$W33x118] $Kspr ;
#sections for plastic hinges and middle element
section Aggregator $W33x118 [expr 200*$W33x118] P [expr 300*$W33x118] Vy [expr 400*$W33x118] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W33x118] $Es $A $I  ;#elastic section to be assigned to the middle of the element



set W30x116 116;
set d [expr 30.01*$in];
set bf [expr 10.496*$in];
set tf [expr 0.85*$in];
set tw [expr 0.565*$in];
set I [expr 4930*$in4];
set A [expr 34.2*$in2];
set My [expr 378*$in3*$Fy_beam];
set MyW30x116 [expr 378*$in3*$Fy_beam];
#Lignos parameters
set LS [expr 1.0056/$Lp_Beam];			# basic strength deterioration (a very large # = no cyclic deterioration)
set LK [expr 1.0056/$Lp_Beam];			# unloading stiffness deterioration (a very large # = no cyclic deterioration)
set LA [expr 1.0056/$Lp_Beam];			# accelerated reloading stiffness deterioration (a very large # = no cyclic deterioration)
set LD [expr 1.0056/$Lp_Beam];			# post-capping strength deterioration (a very large # = no deterioration)
set cS 1.0;				# exponent for basic strength deterioration (c = 1.0 for no deterioration)
set cK 1.0;				# exponent for unloading stiffness deterioration (c = 1.0 for no deterioration)
set cA 1.0;				# exponent for accelerated reloading stiffness deterioration (c = 1.0 for no deterioration)
set cD 1.0;				# exponent for post-capping strength deterioration (c = 1.0 for no deterioration)
set th_pP [expr 0.0314/$Lp_Beam];		# plastic rot capacity for pos loading
set th_pN [expr 0.0314/$Lp_Beam];		# plastic rot capacity for neg loading
set th_pcP [expr 0.152/$Lp_Beam];			# post-capping rot capacity for pos loading
set th_pcN [expr 0.152/$Lp_Beam];			# post-capping rot capacity for neg loading
set ResP [expr 0.4];			# residual strength ratio for pos loading
set ResN [expr 0.4];			# residual strength ratio for neg loading
set th_uP [expr 0.4/$Lp_Beam];			# ultimate rot capacity for pos loading
set th_uN [expr 0.4/$Lp_Beam];			# ultimate rot capacity for neg loading
set DP 1.0;				# rate of cyclic deterioration for pos loading
set DN 1.0;				# rate of cyclic deterioration for neg loading
#definition of the moment-curvature elastic stiffness and strain-hardening
set Kspr [expr 6*$Es*$I/$LBeam*$Lp_Beam];
set strhard [expr (1.0*$My*(1.1 - 1.0)) / ($Kspr*$th_pP)];
#elastic material for axial and shear behavior
uniaxialMaterial Elastic [expr 200*$W30x116] [expr $Es*$A]   ;#elastic material to describe axial behavior
uniaxialMaterial Elastic [expr 300*$W30x116] [expr $G*$A]  ;#elastic material to describe shear behavior
# flexural - without deterioration
#uniaxialMaterial Steel01 [expr 400*$W30x116] [expr 1.0*$My] $Kspr [expr 0.03*6*$Es*$I/$LBeam/$Kspr] ;
# flexural - with deterioration
uniaxialMaterial Bilin02  [expr 400*$W30x116] $Kspr $strhard $strhard [expr 1.0*$My] [expr -1.0*$My] $LS $LK $LA $LD $cS $cK $cA $cD $th_pP $th_pN $th_pcP $th_pcN $ResP $ResN $th_uP $th_uN $DP $DN;
# flexural - elastic
# uniaxialMaterial Elastic [expr 400*$W30x116] $Kspr ;
#sections for plastic hinges and middle element
section Aggregator $W30x116 [expr 200*$W30x116] P [expr 300*$W30x116] Vy [expr 400*$W30x116] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W30x116] $Es $A $I  ;#elastic section to be assigned to the middle of the element


set W24x68 682;
set d [expr 23.73*$in];
set bf [expr 8.965*$in];
set tf [expr 0.585*$in];
set tw [expr 0.415*$in];
set I [expr 1830*$in4];
set A [expr 20.1*$in2];
set My [expr 177*$in3*$Fy_beam];
set MyW24x68 [expr 177*$in3*$Fy_beam];
#Lignos parameters
set LS [expr 0.792/$Lp_Beam];			# basic strength deterioration (a very large # = no cyclic deterioration)
set LK [expr 0.792/$Lp_Beam];			# unloading stiffness deterioration (a very large # = no cyclic deterioration)
set LA [expr 0.792/$Lp_Beam];			# accelerated reloading stiffness deterioration (a very large # = no cyclic deterioration)
set LD [expr 0.792/$Lp_Beam];			# post-capping strength deterioration (a very large # = no deterioration)
set cS 1.0;				# exponent for basic strength deterioration (c = 1.0 for no deterioration)
set cK 1.0;				# exponent for unloading stiffness deterioration (c = 1.0 for no deterioration)
set cA 1.0;				# exponent for accelerated reloading stiffness deterioration (c = 1.0 for no deterioration)
set cD 1.0;				# exponent for post-capping strength deterioration (c = 1.0 for no deterioration)
set th_pP [expr 0.0379/$Lp_Beam];		# plastic rot capacity for pos loading
set th_pN [expr 0.0379/$Lp_Beam];		# plastic rot capacity for neg loading
set th_pcP [expr 0.13/$Lp_Beam];			# post-capping rot capacity for pos loading
set th_pcN [expr 0.13/$Lp_Beam];			# post-capping rot capacity for neg loading
set ResP [expr 0.4];			# residual strength ratio for pos loading
set ResN [expr 0.4];			# residual strength ratio for neg loading
set th_uP [expr 0.4/$Lp_Beam];			# ultimate rot capacity for pos loading
set th_uN [expr 0.4/$Lp_Beam];			# ultimate rot capacity for neg loading
set DP 1.0;				# rate of cyclic deterioration for pos loading
set DN 1.0;				# rate of cyclic deterioration for neg loading
#definition of the moment-curvature elastic stiffness and strain-hardening
set Kspr [expr 6*$Es*$I/$LBeam*$Lp_Beam];
set strhard [expr (1.0*$My*(1.1 - 1.0)) / ($Kspr*$th_pP)];
#elastic material for axial and shear behavior
uniaxialMaterial Elastic [expr 200*$W24x68] [expr $Es*$A]   ;#elastic material to describe axial behavior
uniaxialMaterial Elastic [expr 300*$W24x68] [expr $G*$A]  ;#elastic material to describe shear behavior
# flexural - without deterioration
#uniaxialMaterial Steel01 [expr 400*$W24x68] [expr 1.0*$My] $Kspr [expr 0.03*6*$Es*$I/$LBeam/$Kspr] ;
# flexural - with deterioration
uniaxialMaterial Bilin02  [expr 400*$W24x68] $Kspr $strhard $strhard [expr 1.0*$My] [expr -1.0*$My] $LS $LK $LA $LD $cS $cK $cA $cD $th_pP $th_pN $th_pcP $th_pcN $ResP $ResN $th_uP $th_uN $DP $DN;
# flexural - elastic
# uniaxialMaterial Elastic [expr 400*$W24x68] $Kspr ;
#sections for plastic hinges and middle element
section Aggregator $W24x68 [expr 200*$W24x68] P [expr 300*$W24x68] Vy [expr 400*$W24x68] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W24x68] $Es $A $I  ;#elastic section to be assigned to the middle of the element


set W21x44 24;
set d [expr 20.66*$in];
set bf [expr 6.5*$in];
set tf [expr 0.45*$in];
set tw [expr 0.35*$in];
set I [expr 843*$in4];
set A [expr 13*$in2];
set My [expr 95.4*$in3*$Fy_beam];
set MyW21x44 [expr 95.4*$in3*$Fy_beam];
#Lignos parameters
set LS [expr 0.7786/$Lp_Beam];			# basic strength deterioration (a very large # = no cyclic deterioration)
set LK [expr 0.7786/$Lp_Beam];			# unloading stiffness deterioration (a very large # = no cyclic deterioration)
set LA [expr 0.7786/$Lp_Beam];			# accelerated reloading stiffness deterioration (a very large # = no cyclic deterioration)
set LD [expr 0.7786/$Lp_Beam];			# post-capping strength deterioration (a very large # = no deterioration)
set cS 1.0;				# exponent for basic strength deterioration (c = 1.0 for no deterioration)
set cK 1.0;				# exponent for unloading stiffness deterioration (c = 1.0 for no deterioration)
set cA 1.0;				# exponent for accelerated reloading stiffness deterioration (c = 1.0 for no deterioration)
set cD 1.0;				# exponent for post-capping strength deterioration (c = 1.0 for no deterioration)
set th_pP [expr 0.0436/$Lp_Beam];		# plastic rot capacity for pos loading
set th_pN [expr 0.0436/$Lp_Beam];		# plastic rot capacity for neg loading
set th_pcP [expr 0.1387/$Lp_Beam];			# post-capping rot capacity for pos loading
set th_pcN [expr 0.1387/$Lp_Beam];			# post-capping rot capacity for neg loading
set ResP [expr 0.4];			# residual strength ratio for pos loading
set ResN [expr 0.4];			# residual strength ratio for neg loading
set th_uP [expr 0.4/$Lp_Beam];			# ultimate rot capacity for pos loading
set th_uN [expr 0.4/$Lp_Beam];			# ultimate rot capacity for neg loading
set DP 1.0;				# rate of cyclic deterioration for pos loading
set DN 1.0;				# rate of cyclic deterioration for neg loading
#definition of the moment-curvature elastic stiffness and strain-hardening
set Kspr [expr 6*$Es*$I/$LBeam*$Lp_Beam];
set strhard [expr (1.0*$My*(1.1 - 1.0)) / ($Kspr*$th_pP)];
#elastic material for axial and shear behavior
uniaxialMaterial Elastic [expr 200*$W21x44] [expr $Es*$A]   ;#elastic material to describe axial behavior
uniaxialMaterial Elastic [expr 300*$W21x44] [expr $G*$A]  ;#elastic material to describe shear behavior
# flexural - without deterioration
#uniaxialMaterial Steel01 [expr 400*$W21x44] [expr 1.0*$My] $Kspr [expr 0.03*6*$Es*$I/$LBeam/$Kspr] ;
# flexural - with deterioration
uniaxialMaterial Bilin02  [expr 400*$W21x44] $Kspr $strhard $strhard [expr 1.0*$My] [expr -1.0*$My] $LS $LK $LA $LD $cS $cK $cA $cD $th_pP $th_pN $th_pcP $th_pcN $ResP $ResN $th_uP $th_uN $DP $DN;
# flexural - elastic
# uniaxialMaterial Elastic [expr 400*$W21x44] $Kspr ;
#sections for plastic hinges and middle element
section Aggregator $W21x44 [expr 200*$W21x44] P [expr 300*$W21x44] Vy [expr 400*$W21x44] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W21x44] $Es $A $I  ;#elastic section to be assigned to the middle of the element


# define geometric transformation: performs a Linear geometric transformation of beam stiffness and resisting force from the basic system to the global-coordinate system
set ColTransfTag 1; 				# associate a tag to column transformation
set BeamTransfTag 2; 				# associate a tag to beam transformation (good practice to keep columns and beams separate)

# geomTransf $Type $transfTag 			# $Type options, Linear Linear Corotational
geomTransf PDelta $ColTransfTag; 		
geomTransf PDelta $BeamTransfTag; 	


# define element type and connectivity:
# element beamWithHinges $eleTag $iNode $jNode $secTagI      $Lpi  $secTagJ   $Lpj  $E $A $Iz $transfTag <-mass $massDens> <-iter $maxIters $tol>
set numIntgrPts 6;

#columns
element forceBeamColumn 1 1 6  $ColTransfTag Lobatto $W14x257 $numIntgrPts
element forceBeamColumn 2 2 7  $ColTransfTag Lobatto $W14x311  $numIntgrPts
element forceBeamColumn 3 3 8 $ColTransfTag Lobatto $W14x311   $numIntgrPts
element forceBeamColumn 4 4 9  $ColTransfTag Lobatto $W14x257  $numIntgrPts
element forceBeamColumn 5 5 10  $ColTransfTag Lobatto $W14x68  $numIntgrPts
                                                                                        
element forceBeamColumn 6 6 11  $ColTransfTag  Lobatto $W14x257   $numIntgrPts
element forceBeamColumn 7 7 12  $ColTransfTag  Lobatto $W14x311   $numIntgrPts
element forceBeamColumn 8 8 13 $ColTransfTag   Lobatto $W14x311    $numIntgrPts
element forceBeamColumn 9 9 14  $ColTransfTag  Lobatto $W14x257   $numIntgrPts
element forceBeamColumn 10 10 15 $ColTransfTag Lobatto $W14x68   $numIntgrPts
										
element forceBeamColumn 11 11 16  $ColTransfTag Lobatto $W14x257   $numIntgrPts
element forceBeamColumn 12 12 17  $ColTransfTag Lobatto $W14x311   $numIntgrPts
element forceBeamColumn 13 13 18  $ColTransfTag Lobatto $W14x311   $numIntgrPts
element forceBeamColumn 14 14 19  $ColTransfTag Lobatto $W14x257   $numIntgrPts
element forceBeamColumn 15 15 20 $ColTransfTag  Lobatto $W14x68    $numIntgrPts

#beams

element forceBeamColumn 16 6  7 	 $BeamTransfTag       HingeRadau	$W33x118  $Lp_Beam    $W33x118 $Lp_Beam   [expr 500*$W33x118]   
element forceBeamColumn 17 7 8 	 	 	$BeamTransfTag     HingeRadau 	$W33x118  $Lp_Beam    $W33x118 $Lp_Beam   [expr 500*$W33x118]	
element forceBeamColumn 18 8 9 		$BeamTransfTag        HingeRadau 	$W33x118  $Lp_Beam    $W33x118 $Lp_Beam   [expr 500*$W33x118]
element forceBeamColumn 19 92 102 		$BeamTransfTag     HingeRadau 	$W21x44   $Lp_Beam    $W21x44  $Lp_Beam   [expr 500*$W21x44]
																						
element forceBeamColumn 20 11  12   $BeamTransfTag    	HingeRadau 		$W30x116  $Lp_Beam    $W30x116 $Lp_Beam    [expr 500*$W30x116] 	
element forceBeamColumn 21 12 13  	 $BeamTransfTag   	HingeRadau 		$W30x116  $Lp_Beam    $W30x116 $Lp_Beam    [expr 500*$W30x116]	
element forceBeamColumn 22 13 14  	 $BeamTransfTag   	HingeRadau 		$W30x116  $Lp_Beam    $W30x116 $Lp_Beam    [expr 500*$W30x116]	
element forceBeamColumn 23 142 152  $BeamTransfTag     HingeRadau 		$W21x44   $Lp_Beam    $W21x44  $Lp_Beam    [expr 500*$W21x44]	
																					
element forceBeamColumn 24 16  17	 $BeamTransfTag    HingeRadau 		$W24x68	  $Lp_Beam    $W24x68  $Lp_Beam   	[expr 500*$W24x68]
element forceBeamColumn 25 17 18 	$BeamTransfTag     HingeRadau 		$W24x68   $Lp_Beam    $W24x68  $Lp_Beam   	[expr 500*$W24x68]	
element forceBeamColumn 26 18 19 	$BeamTransfTag     HingeRadau 		$W24x68   $Lp_Beam    $W24x68  $Lp_Beam   	[expr 500*$W24x68]	
element forceBeamColumn 27 192 202 	$BeamTransfTag     HingeRadau 		$W21x44   $Lp_Beam    $W21x44  $Lp_Beam   	[expr 500*$W21x44]	


# display the model with the node numbers
	#DisplayModel2D NodeNumbers


# Define RECORDERS -------------------------------------------------------------
#Nodal Displacements	
#set Disp1 [recorder Node -file $dataDir/Disp1.out -time -node 1 -dof 1 2 3 disp];	
#set Disp2 [recorder Node -file $dataDir/Disp2.out -time -node 2 -dof 1 2 3  disp];	
#set Disp3 [recorder Node -file $dataDir/Disp3.out -time -node 3 -dof 1 2 3  disp];	
#set Disp4 [recorder Node -file $dataDir/Disp4.out -time -node 4 -dof 1 2 3  disp];	
#set Disp5 [recorder Node -file $dataDir/Disp5.out -time -node 5 -dof 1  2 3 disp];	
#set Disp6 [recorder Node -file $dataDir/Disp6.out -time -node 6 -dof 1 2 3  disp];	
#set Disp7 [recorder Node -file $dataDir/Disp7.out -time -node 7 -dof 1 2 3  disp];	
#set Disp8 [recorder Node -file $dataDir/Disp8.out -time -node 8 -dof 1 2 3  disp];	
#set Disp9 [recorder Node -file $dataDir/Disp9.out -time -node 9 -dof 1 2 3  disp];
#set Disp10 [recorder Node -file $dataDir/Disp10.out -time -node 10 -dof 1 2 3  disp];	
#set Disp11 [recorder Node -file $dataDir/Disp11.out -time -node 11 -dof 1 2 3  disp];	
#set Disp12 [recorder Node -file $dataDir/Disp12.out -time -node 12 -dof 1 2 3  disp];	
#set Disp13 [recorder Node -file $dataDir/Disp13.out -time -node 13 -dof 1 2 3  disp];
#set Disp14 [recorder Node -file $dataDir/Disp14.out -time -node 14 -dof 1 2 3  disp];	
#set Disp15 [recorder Node -file $dataDir/Disp15.out -time -node 15 -dof 1 2 3  disp];	
set Disp16 [recorder Node -file $dataDir/Disp16.out -time -node 16 -dof 1 2 3  disp];	
#set Disp17 [recorder Node -file $dataDir/Disp17.out -time -node 17 -dof 1 2 3  disp];	
#set Disp18 [recorder Node -file $dataDir/Disp18.out -time -node 18 -dof 1 2 3  disp];	
#set Disp19 [recorder Node -file $dataDir/Disp19.out -time -node 19 -dof 1 2 3  disp];	
#set Disp20 [recorder Node -file $dataDir/Disp20.out -time -node 20 -dof 1 2 3  disp];	

#Base Reactions
 set Rea1 [recorder Node -file $dataDir/RBase1.out -time -node 1 -dof 1 2 3 reaction];
 set Rea2 [recorder Node -file $dataDir/RBase2.out -time -node 2 -dof 1 2 3 reaction];
 set Rea3 [recorder Node -file $dataDir/RBase3.out -time -node 3 -dof 1 2 3 reaction];
 set Rea4 [recorder Node -file $dataDir/RBase4.out -time -node 4 -dof 1 2 3 reaction];
 set Rea5 [recorder Node -file $dataDir/RBase5.out -time -node 5 -dof 1 2 3 reaction];

#Lateral Drift
set Drift1 [recorder Drift -file $dataDir/Drift1.out -time -iNode 2 -jNode 7 -dof 1  -perpDirn 2];		
set Drift2 [recorder Drift -file $dataDir/Drift2.out -time -iNode 7 -jNode 12 -dof 1  -perpDirn 2];
set Drift3 [recorder Drift -file $dataDir/Drift3.out -time -iNode 12 -jNode 17 -dof 1  -perpDirn 2];

#Element Forces
#set Ele1 [recorder Element -file $dataDir/FCol1.out -time -ele 1 globalForce];	
# set Ele2 [recorder Element -file $dataDir/FCol2.out -time -ele 2 globalForce];
#set Ele3 [recorder Element -file $dataDir/FCol3.out -time -ele 3 globalForce];
#set Ele4 [recorder Element -file $dataDir/FCol4.out -time -ele 4 globalForce];
#set Ele5 [recorder Element -file $dataDir/FCol5.out -time -ele 5 globalForce];
#set Ele6 [recorder Element -file $dataDir/FCol6.out -time -ele 6 globalForce];
#set Ele7 [recorder Element -file $dataDir/FCol7.out -time -ele 7 globalForce];
#set Ele8 [recorder Element -file $dataDir/FCol8.out -time -ele 8 globalForce];
#set Ele9 [recorder Element -file $dataDir/FCol9.out -time -ele 9 globalForce];
#set Ele10 [recorder Element -file $dataDir/FCol10.out -time -ele 10 globalForce];
#set Ele11 [recorder Element -file $dataDir/FCol11.out -time -ele 11 globalForce];
#set Ele12 [recorder Element -file $dataDir/FCol12.out -time -ele 12 globalForce];
#set Ele13 [recorder Element -file $dataDir/FCol13.out -time -ele 13 globalForce];
#set Ele14 [recorder Element -file $dataDir/FCol14.out -time -ele 14 globalForce];
#set Ele15 [recorder Element -file $dataDir/FCol15.out -time -ele 15 globalForce];
#set Ele16 [recorder Element -file $dataDir/FCol16.out -time -ele 16 globalForce];
#set Ele17 [recorder Element -file $dataDir/FCol17.out -time -ele 17 globalForce];
#set Ele18 [recorder Element -file $dataDir/FCol18.out -time -ele 18 globalForce];
#set Ele19 [recorder Element -file $dataDir/FCol19.out -time -ele 19 globalForce];
# set Ele20 [recorder Element -file $dataDir/FCol20.out -time -ele 20 globalForce];
#set Ele21 [recorder Element -file $dataDir/FCol21.out -time -ele 21 globalForce];
#set Ele22 [recorder Element -file $dataDir/FCol22.out -time -ele 22 globalForce];
#set Ele23 [recorder Element -file $dataDir/FCol23.out -time -ele 23 globalForce];
#set Ele24 [recorder Element -file $dataDir/FCol24.out -time -ele 24 globalForce];
#set Ele25 [recorder Element -file $dataDir/FCol25.out -time -ele 25 globalForce];
#set Ele26 [recorder Element -file $dataDir/FCol26.out -time -ele 26 globalForce];
#set Ele27 [recorder Element -file $dataDir/FCol27.out -time -ele 27 globalForce];

#Section Deformation	
#set Defo31 [recorder Element -file $dataDir/DefoCol3Sec1.out -time -ele 3 section 1 deformation];	
#set Defo36 [recorder Element -file $dataDir/DefoCol3Sec6.out -time -ele 3 section 6 deformation];		
#set Defo41 [recorder Element -file $dataDir/DefoCol1Sec1.out -time -ele 4 section 1 deformation];
#set Defo46 [recorder Element -file $dataDir/DefoCol1Sec6.out -time -ele 4 section 6 deformation];
#set Defo51 [recorder Element -file $dataDir/DefoCol5Sec1.out -time -ele 5 section 1 deformation];
#set Defo56 [recorder Element -file $dataDir/DefoCol5Sec6.out -time -ele 5 section 6 deformation];
#set Defo91 [recorder Element -file $dataDir/DefoCol9Sec1.out -time -ele 9 section 1 deformation];
#set Defo96 [recorder Element -file $dataDir/DefoCol9Sec6.out -time -ele 9 section 6 deformation];
# set Defo201 [recorder Element -file $dataDir/DefoCol20Sec1.out -time -ele 20 section 1 deformation];
# set Defo206 [recorder Element -file $dataDir/DefoCol20Sec6.out -time -ele 20 section 6 deformation];

#stress-strain deformation
# set StressStrain2Sec1 [recorder Element -file $dataDir/StressStrain2Sec1.out -time -ele 2 section 1 fiber 0.50 0.10 stressStrain];
# set StressStrain2Sec6 [recorder Element -file $dataDir/StressStrain2Sec6.out -time -ele 2 section 6 fiber 0.10 0.10 stressStrain];


# define GRAVITY -------------------------------------------------------------
pattern Plain 1 Linear {
   load 6 0.0 -109.375 0.0
   load 7 0.0 -155.36 0.0
   load 8 0.0 -155.36 0.0
   load 9 0.0 -155.36 0.0
   load 10 0.0 -109.375   0.0
   load 11 0.0 -109.375   0.0
   load 12 0.0 -155.36  0.0
   load 13 0.0 -155.36  0.0
   load 14 0.0 -155.36  0.0
   load 15 0.0 -109.375   0.0
   load 16 0.0 -93.75   0.0
   load 17 0.0 -137.95  0.0
   load 18 0.0 -137.95  0.0
   load 19 0.0 -137.95  0.0
   load 20 0.0 -93.75   0.0
   
eleLoad -ele 16 17 18 19 20 21 22 23 -type -beamUniform -14.594
eleLoad -ele 24 25 26 27 -type -beamUniform -12.405

# leaning column loads
load 	10500	0	-4.942E3	0;
load 	15500	0	-4.942E3	0;
load 	20500	0	-5000.0	0;
   
}


# ------------------------------------------------- apply gravity load ------
set Tol 1.0e-8;			# convergence tolerance for test
constraints Transformation;     		
numberer RCM;			
system BandGeneral;		
test NormDispIncr $Tol 10 0; 	
algorithm Newton;		# use Newton's solution algorithm: updates tangent stiffness at every iteration
integrator LoadControl 0.1;	# use load increment of 0.1 times the applied linear load pattern;
analysis Static;		# define type of analysis static or transient
analyze 10;			# apply gravity in 10 steps
# ------------------------------------------------- maintain constant gravity loads and reset time to zero
loadConst -time 0.0    # keep previous loading constant and reset pseudo-time to zero

puts "Model Built"


###
##	Eigen Analysis
###

	set pi [expr 2.0*asin(1.0)];						# Definition of pi
	set nEigenI 1;										# mode i = 1
	set nEigenJ 3;										# mode j = 2
	set lambdaN [eigen [expr $nEigenJ]];				# eigenvalue analysis for nEigenJ modes
	set lambda1 [lindex $lambdaN [expr $nEigenI-1]];	# eigenvalue mode i = 1
	set lambda2 [lindex $lambdaN [expr $nEigenI]];	# eigenvalue mode i = 1
	set lambda3 [lindex $lambdaN [expr $nEigenI+1]];	# eigenvalue mode i = 1
	set w1 [expr pow($lambda1,0.5)];					# w1 (1st mode circular frequency)
	set w2 [expr pow($lambda2,0.5)];					# w2 (2nd mode circular frequency)
	set w3 [expr pow($lambda3,0.5)];					# w1 (1st mode circular frequency)
	set T1 [expr 2.0*$pi/$w1];							# 1st mode period of the structure
	set T2 [expr 2.0*$pi/$w2];							# 2nd mode period of the structure
	set T3 [expr 2.0*$pi/$w3];							# 1st mode period of the structure
	puts "EigenValue Analysis:";
	puts "T1 = $T1 s";									# display the first mode period in the command window
	puts "T2 = $T2 s";									# display the second mode period in the command window
	puts "T3 = $T3 s";									# display the first mode period in the command window
	
	puts "EigenVector Analysis:";
	set f1FM1 [nodeEigenvector 7  1 1];
	set f2FM1 [nodeEigenvector 12 1 1];
	set f3FM1 [nodeEigenvector 17 1 1];
	
	set f1FM2 [nodeEigenvector 7  2 1];
	set f2FM2 [nodeEigenvector 12 2 1];
	set f3FM2 [nodeEigenvector 17 2 1];

	
	set f1FM3 [nodeEigenvector 7   3 1];
	set f2FM3 [nodeEigenvector 12 3 1];
	set f3FM3 [nodeEigenvector 17 3 1];
	
	puts "1st mode";
	puts "direction 1:";
	puts "$f1FM1 $f2FM1 $f3FM1";
	
	puts "2nd mode";
	puts "direction 1:";
	puts "$f1FM2 $f2FM2 $f3FM2";
	
	puts "3rd mode";
	puts "direction 1:";
	puts "$f1FM3 $f2FM3 $f3FM3";
	
	# write periods to file
	#set Periods_before [open "Periods_before.txt" "w"];
	#puts $Periods_before "$T1	$T2	$T3";
	#close $Periods_before;

	
set analisys_type 1; # pushover = 1; dynamic = 2

####################################################################################################################################################################
## Pushover Analysis
####################################################################################################################################################################

if { $analisys_type == 1 } {

puts "running pushover...";
set Hload "1";		# define the lateral load

pattern Plain 200 Linear {;			# define load pattern
load 6 [expr $Hload*0.13] 0 0  ;
load 11 [expr $Hload*0.33] 0 0 ;
load 16 [expr $Hload*0.54] 0 0 ;
}

#  ---------------------------------    perform Static Pushover Analysis

# integrator   DisplControl  $tagnode  $dof  $displacement increment for each step
integrator DisplacementControl 16 1 0.001
test NormDispIncr 1.0e-5 2000 0
system BandGeneral
numberer RCM
constraints Transformation
algorithm Newton
analysis Static

analyze 1500

} elseif { $analisys_type == 2 } {
####################################################################################################################################################################
##  Dynamic Analysis
####################################################################################################################################################################

puts "Running dynamic analysis..."
		# display deformed shape:
		#set ViewScale 10;	# amplify display of deformed shape
		#DisplayModel2D DeformedShape $ViewScale;	# display deformed shape, the scaling factor needs to be adjusted for each model
	
#	source ReadSMDfile.tcl;		# procedure for reading GM file and converting it to proper format

#	# Bidirectional Uniform Earthquake ground motion (uniform acceleration input at all support nodes)
	set iGMfile $Qake ;		# ground-motion filename
	set iGMfact $Qake_factor;			# ground-motion scaling factor
#
	set iGMdirection "1";			# ground-motion direction
	# set up ground-motion-analysis parameters
	set DtAnalysis	[expr 0.002*$sec];	# time-step Dt for lateral analysis

	
# DYNAMIC ANALYSIS PARAMETERS
constraints Transformation ; 
numberer RCM
system ProfileSPD
set Tol 1.e-8;                        # Convergence Test: tolerance
test NormDispIncr $Tol 1000 0;
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
	foreach GMdirection $iGMdirection GMfile $iGMfile GMfact $iGMfact {
	incr IDloadTag;
	#set inFile $GMfile
	#set outFile $GMfile.g3;			# set variable holding new filename (PEER files have .at2/dt2 extension)
	#ReadSMDFile $inFile $outFile dt;			# call procedure to convert the ground-motion file
	set GMfatt [expr $GMfact];			# data in input file is in g Unifts -- ACCELERATION TH
	timeSeries Path $IDloadTag -dt $dt_accelerogram -filePath $GMfile -factor $GMfatt;		# time series information
	pattern UniformExcitation  $IDloadTag  $GMdirection -accel  $IDloadTag  ;	# create Unifform excitation
	}
	set TmaxAnalysis	[expr $npts_accelerogram*$dt_accelerogram*$sec + 30*$sec];	# maximum duration of ground-motion analysis 


#Nodal veloccity
#set VelG [recorder Node -file $dataDir/VelG.out -timeSeries $IDloadTag -time -node 1 -dof 1 vel];
#set Vel1 [recorder Node -file $dataDir/Vel1.out -timeSeries $IDloadTag -time -node 6 -dof 1 vel];
#set Vel2 [recorder Node -file $dataDir/Vel2.out -timeSeries $IDloadTag -time -node 11 -dof 1 vel];
#set Vel3 [recorder Node -file $dataDir/Vel3.out -timeSeries $IDloadTag -time -node 16 -dof 1 vel];

#Nodal acceleration
set AcelG [recorder Node -file AcelG.out -timeSeries $IDloadTag -time -node 1 -dof 1 accel];
set Acel1 [recorder Node -file Acel1.out -timeSeries $IDloadTag -time -node 6 -dof 1 accel];
set Acel2 [recorder Node -file Acel2.out -timeSeries $IDloadTag -time -node 11 -dof 1 accel];
set Acel3 [recorder Node -file Acel3.out -timeSeries $IDloadTag -time -node 16 -dof 1 accel];


#--------------------------------  perform analysis-------------------------
set NumSteps [expr int($TmaxAnalysis/$DtAnalysis)];

set Niter 1;
set disp_16 0;
set drift1 0;
set drift2 0;
set drift3 0;
set acel_6 0;
set acel_11 0;
set acel_16 0;
set time_ajust 0;
set time 0;
set ok 0;

for {set i 16} {$i < 28} {incr i} {
	set curvature1_ant_$i 0;
	set curvature6_ant_$i 0;
	set mom1_ant_$i 0;
	set mom6_ant_$i 0;
	set edissipated1_$i 0;
	set edissipated6_$i 0;
	set nie1_$i 0;
	set nie6_$i 0;
	set curv1_max_$i 0;
	set curv6_max_$i 0;
	set time_nie1_ant_$i 0;
	set time_nie6_ant_$i 0;
	set Rotul1$i 0;
	set TimeRotul1$i 0;
	set Rotul2$i 0;
	set TimeRotul2$i 0;
}


set ediss "energias_dissipadas.txt";
set Ediss [open $ediss "w"];

set nie "NIE.txt";
set NIE [open $nie "w"];

set max_curv "curvaturas_maximas.txt";
set Max_Curv [open $max_curv "w"];

set rotulas "Rotulas_plasticas.txt";
set Rotulas [open $rotulas "w"];


puts "running ground motion..." ;

while {$time < $TmaxAnalysis  &&  $ok == 0} {    

	algorithm Newton;
	test NormDispIncr $Tol 100 0;
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
			test NormDispIncr $Tol_2 100 0;
			set ok [analyze 1 $DtAnalysis]
		}
		if {$ok != 0} {
			puts "Trying with Modified Newton..."
			algorithm ModifiedNewton;
			test NormDispIncr $Tol_2 100 0;
			set ok [analyze 1 $DtAnalysis]
		}
		if {$ok != 0} {
			puts "Trying with Newton with Initial Tangent .."
			algorithm Newton -initial;
			test NormDispIncr $Tol_2 100 0;
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
		
	set disp_inic_1 [nodeDisp 1 1];
	set disp_inic_6 [nodeDisp 6 1];
	set disp_inic_11 [nodeDisp 11 1];
	set disp_inic_16 [nodeDisp 16 1];
	
	set acel_inic_16 [nodeAccel 16 1];
	set acel_inic_11 [nodeAccel 11 1];
	set acel_inic_6 [nodeAccel 6 1];
	
	if { [expr abs($disp_inic_16)] > [expr abs($disp_16)] } {
		set disp_16 $disp_inic_16;
	}
	
		set drift_inic_1 [expr $disp_inic_6 - $disp_inic_1];
		set drift_inic_2 [expr $disp_inic_11 - $disp_inic_6];
		set drift_inic_3 [expr $disp_inic_16 - $disp_inic_11];	
	
	if { [expr abs($drift_inic_1)] > [expr abs($drift1)] } {
		set drift1 [expr $drift_inic_1];
	}
	if { [expr abs($drift_inic_2)] > [expr abs($drift2)] } {
		set drift2 [expr $drift_inic_2];
	}
	if { [expr abs($drift_inic_3)] > [expr abs($drift3)] } {
		set drift3 [expr $drift_inic_3];
	}
	
	if { [expr abs($acel_inic_16)] > [expr abs($acel_16)] } {
		set acel_16 $acel_inic_16;
	}
	if { [expr abs($acel_inic_11)] > [expr abs($acel_11)] } {
		set acel_11 $acel_inic_11;
	}
	if { [expr abs($acel_inic_6)] > [expr abs($acel_6)] } {
		set acel_6 $acel_inic_6;
	}
	
	
		for {set i 16} {$i < 28} {incr i} {
			
			set curv1 [eleResponse $i section 1 deformations];
			set curv2 [eleResponse $i section 6 deformations];
			set forces [eleResponse $i forces];
			
			set curvature1 [lindex $curv1 2];
			set curvature6 [lindex $curv2 2];
			set mom1 [lindex $forces 2];
			set mom6 [lindex $forces 5];
			
			set curvature1_ant [eval {set curvature1_ant_$i}];
			set curvature6_ant [eval {set curvature6_ant_$i}];
			set mom1_ant [eval {set mom1_ant_$i}];
			set mom6_ant [eval {set mom6_ant_$i}];
			
			set edissipated1 [eval {set edissipated1_$i}];
			set edissipated6 [eval {set edissipated6_$i}];
			
			set edissipated1_$i [expr $edissipated1 + ($curvature1-$curvature1_ant)*($mom1+$mom1_ant)/2.];
			set edissipated6_$i [expr $edissipated6 + ($curvature6-$curvature6_ant)*($mom6+$mom6_ant)/2.];
			
			set time_nie1_ant [eval {set time_nie1_ant_$i}];
			set time_nie6_ant [eval {set time_nie6_ant_$i}];
			
			if { [expr $mom1_ant*$mom1] < 0 && [expr $time - $time_nie1_ant] >= 0.5 } {
			incr nie1_$i;
			}
			if { [expr $mom6_ant*$mom6] < 0 && [expr $time - $time_nie6_ant] >= 0.5 } {
			incr nie6_$i;
			}
			
			set curv1_max [eval {set curv1_max_$i}];
			if {abs($curvature1) >  abs($curv1_max)} {
				set curv1_max_$i	$curvature1;
			}
			set curv6_max [eval {set curv6_max_$i}];
			if {abs($curvature6) >  abs($curv6_max)} {
				set curv6_max_$i	$curvature6;
			}
			
			set curvature1_ant_$i $curvature1;
			set curvature6_ant_$i $curvature6;
			set mom1_ant_$i $mom1;
			set mom6_ant_$i $mom6;
			
			if {$i <= 18} {
			set MyViga $MyW33x118;
			} elseif {$i <= 19} {
				set MyViga $MyW21x44;
			} elseif {$i <= 22} {
				set MyViga $MyW30x116;
			} elseif {$i <= 23} {
				set MyViga $MyW21x44;
			} elseif {$i <= 26} {
				set MyViga $MyW24x68;
			} else {
				set MyViga $MyW21x44;
			};

			if { [eval {set Rotul1$i}] == 0 && abs($mom1)>$MyViga} {
					set Rotul1$i 1;
					set TimeRotul1$i [getTime];
			}
			if { [eval {set Rotul2$i}] == 0 && abs($mom6)>$MyViga} {
					set Rotul2$i 1;
					set TimeRotul2$i [getTime];
			}
	
		}
	
	
	set Niter [expr $Niter +1 ];
	set time [expr [getTime] + $time_ajust];
	}
	
			#file escrecer resultados
		for {set i 16} {$i < 28} {incr i} {
		set edissipated1 [expr abs([eval {set edissipated1_$i}])];
		set edissipated6 [expr abs([eval {set edissipated6_$i}])];
		puts $Ediss " $edissipated1	$edissipated6 ";
		set nie1 [eval {set nie1_$i}];
		set nie6 [eval {set nie6_$i}];
		puts $NIE " $nie1	$nie6 ";
		set curv1_max [expr abs([eval {set curv1_max_$i}])];
		set curv6_max [expr abs([eval {set curv6_max_$i}])];
		puts $Max_Curv " $curv1_max	$curv6_max ";
		set Rotula [eval {set Rotul1$i}];
		set TimeRotula [eval {set TimeRotul1$i}];
		puts $Rotulas "$Rotula  $TimeRotula ";
		set Rotula [eval {set Rotul2$i}];
		set TimeRotula [eval {set TimeRotul2$i}];
		puts $Rotulas "$Rotula  $TimeRotula ";
		}
		close $Ediss	
		close $NIE	
		close $Max_Curv	
		close $Rotulas	


if {$ok == 0} {
			puts "Dynamic analysis complete";
		} else {
			puts "Dynamic analysis did not converge";
		}	
		
		# disp peak response and write to output file
		puts $file_results " $disp_16	$disp_inic_16	$drift1	$drift2	$drift3	$drift_inic_1	$drift_inic_2	$drift_inic_3	$acel_6	$acel_11	$acel_16"
		close $file_results		
		
# output time at end of analysis	
set currentTime [getTime];	# get current analysis time	(after dynamic analysis)
puts "The current time is: $currentTime (Total time: $TmaxAnalysis)";


}	
wipe;