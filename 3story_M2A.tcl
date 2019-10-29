# --------------------------------------------------------------------------------------------------
# 2D Portal Frame--  3-Story Moment Frame with Distributed Plasticity Model with:
#						a) modIMK (modified Ibarra-Medina-Krawinkler material behaviour (Lignos, 2011)
#					OR	b) elastic sections
	
# Created by: Filipe Ribeiro, 2012 (f.ribeiro@fct.unl.pt)

#   Units: m, kN, sec. 

## source external files
	source LibUnits.tcl;			# define system units
	source Wsection.tcl;		# procedure for defining bilinear plastic hinge section
	source rotPanelZone2D.tcl;   # procedure for defining Panel Zone springs
	source elemPanelZone2D.tcl;			# procedure for defining 8 elements to create a rectangular panel zone

## INPUTs
set Qake "GM.AT2";
set Qake_factor "$g*1.";
set npts_accelerogram 2500;   
set dt_accelerogram 0.01;	

## OUTPUTs
#set file_results [open "Peak_Results.out" "w"]; 

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

set mass1_ext [expr $mass_Piso1/8 ]; 			# nodal mass
set mass1_int [expr $mass_Piso1/4 ]; 			# nodal mass 	
set mass2_ext [expr $mass_Piso2/8 ]; 			# nodal mass  
set mass2_int [expr $mass_Piso2/4 ]; 			# nodal mass  
set mass3_ext [expr $mass_Piso3/8 ]; 			# nodal mass 
set mass3_int [expr $mass_Piso3/4 ]; 			# nodal mass 


# nodal coordinates:
source nodes.tcl

# Single point constraints -- Boundary Conditions
fix	710008  1 1 1;
fix	720008	1 1 1;
fix	730008	1 1 1;
fix	740008	1 1 1;
fix	750008	1 1 1;
fix	760008	1 1 1;
fix	770008	1 1 0;
fix	780008	1 1 0;
fix	790008	1 1 0;
fix	7100008	1 1 1;

#rigid links	
uniaxialMaterial Elastic 100 [expr 1E4*$GPa];
#1o piso				
element truss	30011	1105	2110	1 100;
element truss	30021	2105	3110	1 100;
element truss	30031	3105	4110	1 100;
element truss	30041	4111	5111	1 100;
element truss	30051	5105	6110	1 100;
element truss	30061	6111	7111	1 100;
element truss	30071	7112	8111	1 100;
element truss	30081	8112	9111	1 100;
element truss	30091	9112	10111	1 100;		
#2o piso				
element truss	30012	1205	2210	1 100;
element truss	30022	2205	3210	1 100;
element truss	30032	3205	4210	1 100;
element truss	30042	4211	5211	1 100;
element truss	30052	5205	6210	1 100;
element truss	30062	6211	7211	1 100;
element truss	30072	7212	8211	1 100;
element truss	30082	8212	9211	1 100;
element truss	30092	9212	10211	1 100;		
#3o piso				
element truss	30013	1305	2310	1 100;
element truss	30023	2305	3310	1 100;
element truss	30033	3305	4310	1 100;
element truss	30043	4311	5311	1 100;
element truss	30053	5305	6310	1 100;
element truss	30063	6311	7311	1 100;
element truss	30073	7312	8311	1 100;
element truss	30083	8312	9311	1 100;
element truss	30093	9312	10311	1 100;


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
	#uniaxialMaterial Steel01 $IDSteel_column $Fy_column $Es $Bs;
	set IDSteel_column_C1 2
	uniaxialMaterial Steel02 $IDSteel_column_C1 [expr 1.77*$Fy_column] [expr 1.72*$Es] $Bs  $R0 $cR1 $cR2;
	#uniaxialMaterial Steel01 $IDSteel_column_C1 [expr 2.39*$Fy_column] [expr 2.4*$Es] $Bs  ;
	set IDSteel_column_C2 3
	uniaxialMaterial Steel02 $IDSteel_column_C2 [expr 2.33*$Fy_column] [expr 2.33*$Es] $Bs  $R0 $cR1 $cR2;
	#uniaxialMaterial Steel01 $IDSteel_column_C2 [expr 2.33*$Fy_column] [expr 2.33*$Es] $Bs  ;
	set IDSteel_column_C3 4
	uniaxialMaterial Steel02 $IDSteel_column_C3 [expr 2.5*$Fy_column] [expr 2.5*$Es] $Bs  $R0 $cR1 $cR2;
	#uniaxialMaterial Steel01 $IDSteel_column_C3 [expr 2.5*$Fy_column] [expr 2.5*$Es] $Bs ;
	
	#uniaxialMaterial Elastic $IDSteel_column $Es;
	#uniaxialMaterial Elastic $IDSteel_column_C1 $Es;
	#uniaxialMaterial Elastic $IDSteel_column_C2 $Es;
	#uniaxialMaterial Elastic $IDSteel_column_C3 $Es;

	
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

set W14x257_WA 2570; #WEAK AXIS
	set dw [expr $d - 2 * $tf]
	set y1 [expr -$d/2]
	set y2 [expr -$dw/2]
	set y3 [expr  $dw/2]
	set y4 [expr  $d/2]
  
	set z1 [expr -$bf/2]
	set z2 [expr -$tw/2]
	set z3 [expr  $tw/2]
	set z4 [expr  $bf/2]
  
	section fiberSec  $W14x257_WA  {
   	patch quadr  $IDSteel_column_C1  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   	patch quadr  $IDSteel_column_C1  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   	patch quadr  $IDSteel_column_C1  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}
	
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
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14x68 $IDSteel_column_C3 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf

set W14x68_WA 680;  #WEAK AXIS
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
  
	section fiberSec  $W14x68_WA  {
		patch quadr  $IDSteel_column  $nfbf $nftf   $z1 $y1   $z4 $y1   $z4 $y2   $z1 $y2
   		patch quadr  $IDSteel_column  $nftw $nfdw   $z2 $y2   $z3 $y2   $z3 $y3   $z2 $y3
   		patch quadr  $IDSteel_column  $nfbf $nftf   $z1 $y3   $z4 $y3   $z4 $y4   $z1 $y4
	}

set W14x82 82;
set d [expr 14.31*$in];
set bf [expr 10.13*$in];
set tf [expr 0.855*$in];
set tw [expr 0.51*$in];
set nfdw 8;		# number of fibers along dw
set nftw 3;		# number of fibers along tw
set nfbf 8;		# number of fibers along bf
set nftf 3;			# number of fibers along tf
Wsection  $W14x82 $IDSteel_column_C2 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf


# define beam sections - beam-with-hinges with moment-curvature relationship

set W33x118 118;
set d [expr 32.86*$in];
set bf [expr 11.48*$in];
set tf [expr 0.74*$in];
set tw [expr 0.55*$in];
set I [expr 1.54*5900*$in4];
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
#uniaxialMaterial Elastic [expr 400*$W33x118] $Kspr ;
#sections for plastic hinges and middle element
section Aggregator $W33x118 [expr 200*$W33x118] P [expr 300*$W33x118] Vy [expr 400*$W33x118] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W33x118] $Es $A $I  ;#elastic section to be assigned to the middle of the element


set W30x116 116;
set d [expr 30.01*$in];
set bf [expr 10.496*$in];
set tf [expr 0.85*$in];
set tw [expr 0.565*$in];
set I [expr 1.53*4930*$in4];
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
#uniaxialMaterial Elastic [expr 400*$W30x116] $Kspr ;
#sections for plastic hinges and middle element
section Aggregator $W30x116 [expr 200*$W30x116] P [expr 300*$W30x116] Vy [expr 400*$W30x116] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W30x116] $Es $A $I  ;#elastic section to be assigned to the middle of the element


set W24x68 682;
set d [expr 23.73*$in];
set bf [expr 8.965*$in];
set tf [expr 0.585*$in];
set tw [expr 0.415*$in];
set I [expr 1.66*1830*$in4];
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
#uniaxialMaterial Elastic [expr 400*$W24x68] $Kspr ;
#sections for plastic hinges and middle element
section Aggregator $W24x68 [expr 200*$W24x68] P [expr 300*$W24x68] Vy [expr 400*$W24x68] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W24x68] $Es $A $I  ;#elastic section to be assigned to the middle of the element


set W21x44 24;
set d [expr 20.66*$in];
set bf [expr 6.5*$in];
set tf [expr 0.45*$in];
set tw [expr 0.35*$in];
set I [expr 1.77*843*$in4];
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
#uniaxialMaterial Elastic [expr 400*$W21x44] $Kspr ;
#sections for plastic hinges and middle element
section Aggregator $W21x44 [expr 200*$W21x44] P [expr 300*$W21x44] Vy [expr 400*$W21x44] Mz ;  # aggregate axial, shear and flexural behavior
section Elastic [expr 500*$W21x44] $Es $A $I  ;#elastic section to be assigned to the middle of the element


# define geometric transformation: performs a Linear geometric transformation of beam stiffness and resisting force from the basic system to the global-coordinate system
set TransfTag 1; 				# associate a tag to column transformation

# geomTransf $Type $transfTag 			# $Type options, Linear Linear Corotational
geomTransf PDelta $TransfTag; 	

# define element type and connectivity:
# element beamWithHinges $eleTag $iNode $jNode $secTagI      $Lpi  $secTagJ   $Lpj  $E $A $Iz $transfTag <-mass $massDens> <-iter $maxIters $tol>
set numIntgrPts 6;

#columns

#Moment Resisting Frame								
element	forceBeamColumn	40011	710008	116	$TransfTag	Lobatto	$W14x257	$numIntgrPts
element	forceBeamColumn	40021	720008	216	$TransfTag	Lobatto	$W14x311	$numIntgrPts
element	forceBeamColumn	40031	730008	316	$TransfTag	Lobatto	$W14x311	$numIntgrPts
element	forceBeamColumn	40041	740008	416	$TransfTag	Lobatto	$W14x257	$numIntgrPts
element	forceBeamColumn	40051	750008	516	$TransfTag	Lobatto	$W14x68_WA	$numIntgrPts
								
element	forceBeamColumn	40012	117	126	$TransfTag	Lobatto	$W14x257	$numIntgrPts
element	forceBeamColumn	40022	217	226	$TransfTag	Lobatto	$W14x311	$numIntgrPts
element	forceBeamColumn	40032	317	326	$TransfTag	Lobatto	$W14x311	$numIntgrPts
element	forceBeamColumn	40042	417	426	$TransfTag	Lobatto	$W14x257	$numIntgrPts
element	forceBeamColumn	40052	517	526	$TransfTag	Lobatto	$W14x68_WA	$numIntgrPts
								
element	forceBeamColumn	40013	127	136	$TransfTag	Lobatto	$W14x257	$numIntgrPts
element	forceBeamColumn	40023	227	236	$TransfTag	Lobatto	$W14x311	$numIntgrPts
element	forceBeamColumn	40033	327	336	$TransfTag	Lobatto	$W14x311	$numIntgrPts
element	forceBeamColumn	40043	427	436	$TransfTag	Lobatto	$W14x257	$numIntgrPts
element	forceBeamColumn	40053	527	536	$TransfTag	Lobatto	$W14x68_WA	$numIntgrPts
								
#Consolidated Frame								
element	forceBeamColumn	40061	760008	616	$TransfTag	Lobatto	$W14x257_WA	$numIntgrPts
element	forceBeamColumn	40071	770008	716	$TransfTag	Lobatto	$W14x82	$numIntgrPts
element	forceBeamColumn	40081	780008	816	$TransfTag	Lobatto	$W14x82	$numIntgrPts
element	forceBeamColumn	40091	790008	916	$TransfTag	Lobatto	$W14x68	$numIntgrPts
element	forceBeamColumn	400101	7100008	1016	$TransfTag	Lobatto	$W14x257_WA	$numIntgrPts
								
element	forceBeamColumn	40062	617	626	$TransfTag	Lobatto	$W14x257_WA	$numIntgrPts
element	forceBeamColumn	40072	717	726	$TransfTag	Lobatto	$W14x82	$numIntgrPts
element	forceBeamColumn	40082	817	826	$TransfTag	Lobatto	$W14x82	$numIntgrPts
element	forceBeamColumn	40092	917	926	$TransfTag	Lobatto	$W14x68	$numIntgrPts
element	forceBeamColumn	400102	1017	1026	$TransfTag	Lobatto	$W14x257_WA	$numIntgrPts
								
element	forceBeamColumn	40063	627	636	$TransfTag	Lobatto	$W14x257_WA	$numIntgrPts
element	forceBeamColumn	40073	727	736	$TransfTag	Lobatto	$W14x82	$numIntgrPts
element	forceBeamColumn	40083	827	836	$TransfTag	Lobatto	$W14x82	$numIntgrPts
element	forceBeamColumn	40093	927	936	$TransfTag	Lobatto	$W14x68	$numIntgrPts
element	forceBeamColumn	400103	1027	1036	$TransfTag	Lobatto	$W14x257_WA	$numIntgrPts


#beams

#Moment Resisting Frame												
element	forceBeamColumn	60011	1105	2110	$TransfTag	HingeRadau	$W33x118	$Lp_Beam	$W33x118	$Lp_Beam	[expr	500*$W33x118]
element	forceBeamColumn	60021	2105	3110	$TransfTag	HingeRadau	$W33x118	$Lp_Beam	$W33x118	$Lp_Beam	[expr	500*$W33x118]
element	forceBeamColumn	60031	3105	4110	$TransfTag	HingeRadau	$W33x118	$Lp_Beam	$W33x118	$Lp_Beam	[expr	500*$W33x118]
element	forceBeamColumn	60041	4111	5111	$TransfTag	HingeRadau	$W21x44	$Lp_Beam	$W21x44	$Lp_Beam	[expr	500*$W21x44]
												
element	forceBeamColumn	60012	1205	2210	$TransfTag	HingeRadau	$W30x116	$Lp_Beam	$W30x116	$Lp_Beam	[expr	500*$W30x116]
element	forceBeamColumn	60022	2205	3210	$TransfTag	HingeRadau	$W30x116	$Lp_Beam	$W30x116	$Lp_Beam	[expr	500*$W30x116]
element	forceBeamColumn	60032	3205	4210	$TransfTag	HingeRadau	$W30x116	$Lp_Beam	$W30x116	$Lp_Beam	[expr	500*$W30x116]
element	forceBeamColumn	60042	4211	5211	$TransfTag	HingeRadau	$W21x44	$Lp_Beam	$W21x44	$Lp_Beam	[expr	500*$W21x44]
												
element	forceBeamColumn	60013	1305	2310	$TransfTag	HingeRadau	$W24x68	$Lp_Beam	$W24x68	$Lp_Beam	[expr	500*$W24x68]
element	forceBeamColumn	60023	2305	3310	$TransfTag	HingeRadau	$W24x68	$Lp_Beam	$W24x68	$Lp_Beam	[expr	500*$W24x68]
element	forceBeamColumn	60033	3305	4310	$TransfTag	HingeRadau	$W24x68	$Lp_Beam	$W24x68	$Lp_Beam	[expr	500*$W24x68]
element	forceBeamColumn	60043	4311	5311	$TransfTag	HingeRadau	$W21x44	$Lp_Beam	$W21x44	$Lp_Beam	[expr	500*$W21x44]
												
#Consolidated Frame					$A $E $Iz $transfTag 							
element	elasticBeamColumn 	60061	6111	7111	0.031066067	$Es	0.00185729	$TransfTag
element	elasticBeamColumn 	60071	7112	8111	0.031066067	$Es	0.00185729	$TransfTag
element	elasticBeamColumn 	60081	8112	9111	0.031066067	$Es	0.00185729	$TransfTag
element	elasticBeamColumn 	60091	9112	10111	0.031066067	$Es	0.00185729	$TransfTag
								
element	elasticBeamColumn 	60062	6211	7211	0.031066067	$Es	0.00185729	$TransfTag
element	elasticBeamColumn 	60072	7212	8211	0.031066067	$Es	0.00185729	$TransfTag
element	elasticBeamColumn 	60082	8212	9211	0.031066067	$Es	0.00185729	$TransfTag
element	elasticBeamColumn 	60092	9212	10211	0.031066067	$Es	0.00185729	$TransfTag
								
element	elasticBeamColumn 	60063	6311	7311	0.024402532	$Es	0.001219683	$TransfTag
element	elasticBeamColumn 	60073	7312	8311	0.03202871	$Es	0.002143028	$TransfTag
element	elasticBeamColumn 	60083	8312	9311	0.024402532	$Es	0.001219683	$TransfTag
element	elasticBeamColumn 	60093	9312	10311	0.024402532	$Es	0.001219683	$TransfTag



# define shear connections - reduced strength according to Gupta and Krawinkler (1999)

#definir secções
set SC21x44 24;
set My [expr 0.00156*$Fy_beam];
uniaxialMaterial ElasticPP $SC21x44 [expr 0.2*$My/0.01] 0.01 -0.005 ;
#uniaxialMaterial Elastic $SC21x44 [expr 0.4*$My/0.02]  ;
#uniaxialMaterial Steel01 $SC21x44 $My [expr 0.4*$My/0.02] 0.01 ;

set SC18x35 35;
set My [expr 0.00272*$Fy_beam];
uniaxialMaterial ElasticPP $SC18x35 [expr 0.2*$My/0.01] 0.01 -0.005 ;
#uniaxialMaterial Elastic $SC18x35 [expr 0.4*$My/0.02]  ;
#uniaxialMaterial Steel01 $SC18x35 $My [expr 0.4*$My/0.02] 0.01 ;

set SC16x26 26;
set My [expr 0.00181*$Fy_beam];
uniaxialMaterial ElasticPP $SC16x26 [expr 0.2*$My/0.01] 0.01 -0.005 ;
#uniaxialMaterial Elastic $SC16x26 [expr 0.4*$My/0.02]  ;
#uniaxialMaterial Steel01 $SC16x26 $My [expr 0.4*$My/0.02] 0.01 ;

set SC21x44_CF 44;
set My [expr 0.00307*$in3*$Fy_beam];
uniaxialMaterial ElasticPP $SC21x44_CF [expr 0.2*$My/0.01] 0.01 -0.005 ;
#uniaxialMaterial Elastic $SC21x44_CF [expr 0.4*$My/0.02] ;
#uniaxialMaterial Steel01 $SC21x44_CF $My [expr 0.4*$My/0.02] 0.01 ;

#definir elementos e constraints
element	zeroLength	741006	4105	4111	-mat	$SC21x44	-dir	6
element	zeroLength	742006	5110	5111	-mat	$SC21x44	-dir	6
element	zeroLength	743006	4205	4211	-mat	$SC21x44	-dir	6
element	zeroLength	751004	5211	5210	-mat	$SC21x44	-dir	6
element	zeroLength	752004	4311	4305	-mat	$SC21x44	-dir	6
element	zeroLength	753004	5311	5310	-mat	$SC21x44	-dir	6
								
element	zeroLength	761006	6105	6111	-mat	$SC18x35	-dir	6
element	zeroLength	762006	7110	7111	-mat	$SC18x35	-dir	6
element	zeroLength	763006	6205	6211	-mat	$SC18x35	-dir	6
element	zeroLength	771004	7211	7210	-mat	$SC18x35	-dir	6
element	zeroLength	772004	6311	6305	-mat	$SC16x26	-dir	6
element	zeroLength	773004	7311	7310	-mat	$SC16x26	-dir	6
								
element	zeroLength	771006	7105	7112	-mat	$SC18x35	-dir	6
element	zeroLength	772006	8110	8111	-mat	$SC18x35	-dir	6
element	zeroLength	773006	7205	7212	-mat	$SC18x35	-dir	6
element	zeroLength	781004	8211	8210	-mat	$SC18x35	-dir	6
element	zeroLength	782004	7312	7305	-mat	$SC21x44_CF	-dir	6
element	zeroLength	783004	8311	8310	-mat	$SC21x44_CF	-dir	6
								
element	zeroLength	781006	8105	8112	-mat	$SC18x35	-dir	6
element	zeroLength	782006	9110	9111	-mat	$SC18x35	-dir	6
element	zeroLength	783006	8205	8212	-mat	$SC18x35	-dir	6
element	zeroLength	791004	9211	9210	-mat	$SC18x35	-dir	6
element	zeroLength	792004	8312	8305	-mat	$SC16x26	-dir	6
element	zeroLength	793004	9311	9310	-mat	$SC16x26	-dir	6
								
element	zeroLength	791006	9105	9112	-mat	$SC18x35	-dir	6
element	zeroLength	792006	10110	10111	-mat	$SC18x35	-dir	6
element	zeroLength	793006	9205	9212	-mat	$SC18x35	-dir	6
element	zeroLength	7101004	10211	10210	-mat	$SC18x35	-dir	6
element	zeroLength	7102004	9312	9305	-mat	$SC16x26	-dir	6
element	zeroLength	7103004	10311	10310	-mat	$SC16x26	-dir	6
								
								
equalDOF	4105	4111	1	2				
equalDOF	5110	5111	1	2				
equalDOF	4205	4211	1	2				
equalDOF	5210	5211	1	2				
equalDOF	4305	4311	1	2				
equalDOF	5310	5311	1	2				
								
equalDOF	6105	6111	1	2				
equalDOF	7110	7111	1	2				
equalDOF	6205	6211	1	2				
equalDOF	7210	7211	1	2				
equalDOF	6305	6311	1	2				
equalDOF	7310	7311	1	2				
								
equalDOF	7105	7112	1	2				
equalDOF	8110	8111	1	2				
equalDOF	7205	7212	1	2				
equalDOF	8210	8211	1	2				
equalDOF	7305	7312	1	2				
equalDOF	8310	8311	1	2				
								
equalDOF	8105	8112	1	2				
equalDOF	9110	9111	1	2				
equalDOF	8205	8212	1	2				
equalDOF	9210	9211	1	2				
equalDOF	8305	8312	1	2				
equalDOF	9310	9311	1	2				
								
equalDOF	9105	9112	1	2				
equalDOF	10110	10111	1	2				
equalDOF	9205	9212	1	2				
equalDOF	10210	10211	1	2				
equalDOF	9305	9312	1	2				
equalDOF	10310	10311	1	2	


# define panel zones - following Gupta and Krawinkler (1999)

# 1) define elastic panel zone elements (assume rigid)
	# elemPanelZone2D creates 8 elastic elements that form a rectangular panel zone
	# references provided in elemPanelZone2D.tcl
	# note: the nodeID and eleID of the upper left corner of the PZ must be imported
	# eleID convention:  500xy, 500 = panel zone element, x = Pier #, y = Floor #

set Apz 100.0;	# area of panel zone element (make much larger than A of frame elements)
set Ipz 1.0;  # moment of intertia of panel zone element (make much larger than I of frame elements)

# elemPanelZone2D eleID  nodeR E  A_PZ I_PZ transfTag
elemPanelZone2D	500111	1101	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500211	2101	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500311	3101	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500411	4101	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500511	5101	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500611	6101	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500711	7101	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500811	8101	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500911	9101	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	5001011	10101	[expr 1E4*$GPa]	1	0.1	$TransfTag;
                                        
elemPanelZone2D	500121	1201	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500221	2201	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500321	3201	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500421	4201	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500521	5201	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500621	6201	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500721	7201	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500821	8201	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500921	9201	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	5001021	10201	[expr 1E4*$GPa]	1	0.1	$TransfTag;
						                
elemPanelZone2D	500131	1301	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500231	2301	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500331	3301	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500431	4301	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500531	5301	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500631	6301	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500731	7301	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500831	8301	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	500931	9301	[expr 1E4*$GPa]	1	0.1	$TransfTag;
elemPanelZone2D	5001031	10301	[expr 1E4*$GPa]	1	0.1	$TransfTag;

# 2) define panel zone springs
	# rotPanelZone2D creates a uniaxial material spring with a trilinear response based on the Krawinkler Model
	#				It also constrains the nodes in the corners of the panel zone.


#  ElemID  ndR  ndC  E   Fy   dc       bf_c        tf_c       tp        db       Ry   as
rotPanelZone2D	41100	1103	1104	$Es	$Fy_beam	0.416052	0.406273	0.048006	0.029845	0.834644	1.0	0.03;
rotPanelZone2D	42100	2103	2104	$Es	$Fy_beam	0.434848	0.412242	0.057404	0.035814	0.834644	1.0	0.03;
rotPanelZone2D	43100	3103	3104	$Es	$Fy_beam	0.434848	0.412242	0.057404	0.035814	0.834644	1.0	0.03;
rotPanelZone2D	44100	4103	4104	$Es	$Fy_beam	0.416052	0.406273	0.048006	0.029845	0.834644	1.0	0.03;
rotPanelZone2D	45100	5103	5104	$Es	$Fy_beam	0.254889	0.356616	0.018288	0.01397		0.834644	1.0	0.03;
rotPanelZone2D	46100	6103	6104	[expr $Es*2.4 ]	[expr $Fy_beam*2.39]	0.416052	0.406273	0.048006	0.029845	0.44958	1.0	0.03;
rotPanelZone2D	47100	7103	7104	[expr $Es*2.33]	[expr $Fy_beam*2.33]	0.363474	0.257302	0.021717	0.012954	0.44958	1.0	0.03;
rotPanelZone2D	48100	8103	8104	[expr $Es*2.33]	[expr $Fy_beam*2.33]	0.363474	0.257302	0.021717	0.012954	0.44958	1.0	0.03;
rotPanelZone2D	49100	9103	9104	[expr $Es*2.5 ]	[expr $Fy_beam*2.5 ]	0.602742	0.227711	0.014859	0.010541	0.44958	1.0	0.03;
rotPanelZone2D	410100	10103	10104	[expr $Es*2.4 ]	[expr $Fy_beam*2.39]	0.416052	0.406273	0.048006	0.029845	0.44958	1.0	0.03;
												
rotPanelZone2D	41200	1203	1204	$Es	$Fy_beam	0.416052	0.406273	0.048006	0.029845	0.762254	1.0	0.03;
rotPanelZone2D	42200	2203	2204	$Es	$Fy_beam	0.434848	0.412242	0.057404	0.035814	0.762254	1.0	0.03;
rotPanelZone2D	43200	3203	3204	$Es	$Fy_beam	0.434848	0.412242	0.057404	0.035814	0.762254	1.0	0.03;
rotPanelZone2D	44200	4203	4204	$Es	$Fy_beam	0.416052	0.406273	0.048006	0.029845	0.762254	1.0	0.03;
rotPanelZone2D	45200	5203	5204	$Es	$Fy_beam	0.254889	0.356616	0.018288	0.014351	0.762254	1.0	0.03;
rotPanelZone2D	46200	6203	6204	[expr $Es*2.4 ]	[expr $Fy_beam*2.39]	0.416052	0.406273	0.048006	0.029845	0.44958	1.0	0.03;
rotPanelZone2D	472000	7203	7204	[expr $Es*2.33]	[expr $Fy_beam*2.33]	0.363474	0.257302	0.021717	0.012954	0.44958	1.0	0.03;
rotPanelZone2D	48200	8203	8204	[expr $Es*2.33]	[expr $Fy_beam*2.33]	0.363474	0.257302	0.021717	0.012954	0.44958	1.0	0.03;
rotPanelZone2D	49200	9203	9204	[expr $Es*2.5 ]	[expr $Fy_beam*2.5 ]	0.602742	0.227711	0.014859	0.010541	0.44958	1.0	0.03;
rotPanelZone2D	410200	10203	10204	[expr $Es*2.4 ]	[expr $Fy_beam*2.39]	0.416052	0.406273	0.048006	0.029845	0.44958	1.0	0.03;
												
rotPanelZone2D	41300	1303	1304	$Es	$Fy_beam	0.416052	0.406273	0.048006	0.029845	0.602742	1.0	0.03;
rotPanelZone2D	42300	2303	2304	$Es	$Fy_beam	0.434848	0.412242	0.057404	0.035814	0.602742	1.0	0.03;
rotPanelZone2D	43300	3303	3304	$Es	$Fy_beam	0.434848	0.412242	0.057404	0.035814	0.602742	1.0	0.03;
rotPanelZone2D	44300	4303	4304	$Es	$Fy_beam	0.416052	0.406273	0.048006	0.029845	0.602742	1.0	0.03;
rotPanelZone2D	45300	5303	5304	$Es	$Fy_beam	0.254889	0.356616	0.018288	0.010541	0.602742	1.0	0.03;
rotPanelZone2D	46300	6303	6304	[expr $Es*2.4 ]	[expr $Fy_beam*2.39]	0.416052	0.406273	0.048006	0.029845	0.398526	1.0 0.03;
rotPanelZone2D	47300	7303	7304	[expr $Es*2.33]	[expr $Fy_beam*2.33]	0.363474	0.257302	0.021717	0.012954	0.5248		1.0 0.03;
rotPanelZone2D	48300	8303	8304	[expr $Es*2.33]	[expr $Fy_beam*2.33]	0.363474	0.257302	0.021717	0.012954	0.5248		1.0 0.03;
rotPanelZone2D	49300	9303	9304	[expr $Es*2.5 ]	[expr $Fy_beam*2.5]	0.602742	0.227711	0.014859	0.010541	0.398526		1.0 0.03;
rotPanelZone2D	410300	10303	10304	[expr $Es*2.4 ]	[expr $Fy_beam*2.39]	0.416052	0.406273	0.048006	0.029845	0.398526	1.0 0.03;


# display the model with the node numbers
	#DisplayModel2D NodeNumbers


# Define RECORDERS -------------------------------------------------------------
#Nodal Displacements	
set Disp1 [recorder Node -file $dataDir/DispFloor1.out -time -node 1110 -dof 1 2 3 disp];	
set Disp2 [recorder Node -file $dataDir/DispFloor2.out -time -node 1210 -dof 1 2 3 disp];
set Disp3 [recorder Node -file $dataDir/DispFloor3.out -time -node 1310 -dof 1 2 3 disp];
	

#Base Reactions
set ReaMRF1 [recorder Node -file $dataDir/BaseReaMRF1.out -time -node 710008 -dof 1 2 3 reaction];
set ReaMRF1 [recorder Node -file $dataDir/BaseReaMRF2.out -time -node 720008 -dof 1 2 3 reaction];
set ReaMRF1 [recorder Node -file $dataDir/BaseReaMRF3.out -time -node 730008 -dof 1 2 3 reaction];
set ReaMRF1 [recorder Node -file $dataDir/BaseReaMRF4.out -time -node 740008 -dof 1 2 3 reaction];
set ReaMRF1 [recorder Node -file $dataDir/BaseReaMRF5.out -time -node 750008 -dof 1 2 3 reaction];
set ReaMRF1 [recorder Node -file $dataDir/BaseReaCF1.out -time -node 760008 -dof 1 2 3 reaction];
set ReaMRF1 [recorder Node -file $dataDir/BaseReaCF2.out -time -node 770008 -dof 1 2 3 reaction];
set ReaMRF1 [recorder Node -file $dataDir/BaseReaCF3.out -time -node 780008 -dof 1 2 3 reaction];
set ReaMRF1 [recorder Node -file $dataDir/BaseReaCF4.out -time -node 790008 -dof 1 2 3 reaction];
set ReaMRF1 [recorder Node -file $dataDir/BaseReaCF5.out -time -node 7100008 -dof 1 2 3 reaction];

#Lateral Drift
set Drift1 [recorder Drift -file $dataDir/DriftFloor1.out -time -iNode 710008 -jNode 1110 -dof 1  -perpDirn 2];		
set Drift2 [recorder Drift -file $dataDir/DriftFloor2.out -time -iNode 1110 -jNode 1210 -dof 1  -perpDirn 2];
set Drift3 [recorder Drift -file $dataDir/DriftFloor3.out -time -iNode 1210 -jNode 1310 -dof 1  -perpDirn 2];

#Column Forces
set COL11 [recorder Element -file $dataDir/FColMRF11.out -time -ele 40011 globalForce];	
set COL21 [recorder Element -file $dataDir/FColMRF21.out -time -ele 40021 globalForce];	
set COL31 [recorder Element -file $dataDir/FColMRF31.out -time -ele 40031 globalForce];	
set COL41 [recorder Element -file $dataDir/FColMRF41.out -time -ele 40041 globalForce];	
set COL51 [recorder Element -file $dataDir/FColMRF51.out -time -ele 40051 globalForce];	
set COL61 [recorder Element -file $dataDir/FColGF11.out -time -ele 40061 globalForce];	
set COL71 [recorder Element -file $dataDir/FColGF21.out -time -ele 40071 globalForce];	
set COL81 [recorder Element -file $dataDir/FColGF31.out -time -ele 40081 globalForce];	
set COL91 [recorder Element -file $dataDir/FColGF41.out -time -ele 40091 globalForce];	
set COL101 [recorder Element -file $dataDir/FColGF51.out -time -ele 400101 globalForce];	
set COL12 [recorder Element -file $dataDir/FColMRF12.out -time -ele 40012 globalForce];	
set COL22 [recorder Element -file $dataDir/FColMRF22.out -time -ele 40022 globalForce];	
set COL32 [recorder Element -file $dataDir/FColMRF32.out -time -ele 40032 globalForce];	
set COL42 [recorder Element -file $dataDir/FColMRF42.out -time -ele 40042 globalForce];	
set COL52 [recorder Element -file $dataDir/FColMRF52.out -time -ele 40052 globalForce];	
set COL62 [recorder Element -file $dataDir/FColGF12.out -time -ele 40062 globalForce];	
set COL72 [recorder Element -file $dataDir/FColGF22.out -time -ele 40072 globalForce];	
set COL82 [recorder Element -file $dataDir/FColGF32.out -time -ele 40082 globalForce];	
set COL92 [recorder Element -file $dataDir/FColGF42.out -time -ele 40092 globalForce];	
set COL102 [recorder Element -file $dataDir/FColGF52.out -time -ele 400102 globalForce];
set COL13 [recorder Element -file $dataDir/FColMRF13.out -time -ele 40013 globalForce];	
set COL23 [recorder Element -file $dataDir/FColMRF23.out -time -ele 40023 globalForce];	
set COL33 [recorder Element -file $dataDir/FColMRF33.out -time -ele 40033 globalForce];	
set COL43 [recorder Element -file $dataDir/FColMRF43.out -time -ele 40043 globalForce];	
set COL53 [recorder Element -file $dataDir/FColMRF53.out -time -ele 40053 globalForce];	
set COL63 [recorder Element -file $dataDir/FColGF13.out -time -ele 40063 globalForce];	
set COL73 [recorder Element -file $dataDir/FColGF23.out -time -ele 40073 globalForce];	
set COL83 [recorder Element -file $dataDir/FColGF33.out -time -ele 40083 globalForce];	
set COL93 [recorder Element -file $dataDir/FColGF43.out -time -ele 40093 globalForce];	
set COL103 [recorder Element -file $dataDir/FColGF53.out -time -ele 400103 globalForce];

#Column stress-strain deformation
set COL21Sec1 [recorder Element -file $dataDir/FColMRF21Sec1_SS.out -time -ele 40021 section 1 fiber 0.50 0.10 stressStrain];
set COL22Sec1 [recorder Element -file $dataDir/FColMRF22Sec1_SS.out -time -ele 40022 section 1 fiber 0.50 0.10 stressStrain];
set COL23Sec1 [recorder Element -file $dataDir/FColMRF23Sec1_SS.out -time -ele 40023 section 1 fiber 0.50 0.10 stressStrain];
set COL71Sec1 [recorder Element -file $dataDir/FColGF21Sec1_SS.out -time -ele 40071 section 1 fiber 0.50 0.10 stressStrain];
set COL72Sec1 [recorder Element -file $dataDir/FColGF22Sec1_SS.out -time -ele 40072 section 1 fiber 0.50 0.10 stressStrain];
set COL73Sec1 [recorder Element -file $dataDir/FColGF23Sec1_SS.out -time -ele 40073 section 1 fiber 0.50 0.10 stressStrain];

#Beam Forces
set Beam11 [recorder Element -file $dataDir/FBeamMRF11.out -time -ele 60011 globalForce];
set Beam22 [recorder Element -file $dataDir/FBeamMRF22.out -time -ele 60022 globalForce];
set Beam33 [recorder Element -file $dataDir/FBeamMRF33.out -time -ele 60033 globalForce];

#Beam Section Deformation	
set SectDefo11Sec1 [recorder Element -file $dataDir/BeamDefMRF11Sec1.out -time -ele 60011 section 1 deformation];	
set SectDefo11Sec6 [recorder Element -file $dataDir/BeamDefMRF11Sec6.out -time -ele 60011 section 6 deformation];
set SectDefo22Sec1 [recorder Element -file $dataDir/BeamDefMRF22Sec1.out -time -ele 60022 section 1 deformation];	
set SectDefo22Sec6 [recorder Element -file $dataDir/BeamDefMRF22Sec6.out -time -ele 60022 section 6 deformation];
set SectDefo33Sec1 [recorder Element -file $dataDir/BeamDefMRF33Sec1.out -time -ele 60033 section 1 deformation];	
set SectDefo33Sec6 [recorder Element -file $dataDir/BeamDefMRF33Sec6.out -time -ele 60033 section 6 deformation];

#Panel Zone Forces and Distortion
set PZForce11 [recorder Element -file $dataDir/ForcePZMRF11.out -time -ele 41100 force];
set PZForce22 [recorder Element -file $dataDir/ForcePZMRF22.out -time -ele 42200 force];
set PZForce33 [recorder Element -file $dataDir/ForcePZMRF33.out -time -ele 43300 force];
set PZForce61 [recorder Element -file $dataDir/ForcePZGF11.out -time -ele 46100 force];
set PZForce72 [recorder Element -file $dataDir/ForcePZGF22.out -time -ele 47200 force];
set PZForce83 [recorder Element -file $dataDir/ForcePZGF33.out -time -ele 48300 force];

set PZDist11 [recorder Element -file $dataDir/DistPZMRF11.out -time -ele 41100 deformation];
set PZDist22 [recorder Element -file $dataDir/DistPZMRF22.out -time -ele 42200 deformation];
set PZDist33 [recorder Element -file $dataDir/DistPZMRF33.out -time -ele 43300 deformation];
set PZDist61 [recorder Element -file $dataDir/DistPZGF11.out -time -ele 46100 deformation];
set PZDist72 [recorder Element -file $dataDir/DistPZGF22.out -time -ele 47200 deformation];
set PZDist83 [recorder Element -file $dataDir/DistPZGF33.out -time -ele 48300 deformation];

#Shear Connection Forces and Distortion
set SCForce41 [recorder Element -file $dataDir/ForceSCMRF41.out -time -ele 741006 force];
set SCForce42 [recorder Element -file $dataDir/ForceSCMRF42.out -time -ele 742006 force];
set SCForce43 [recorder Element -file $dataDir/ForceSCMRF43.out -time -ele 743006 force];
set SCForce21 [recorder Element -file $dataDir/ForceSCGF21.out -time -ele 771006 force];
set SCForce22 [recorder Element -file $dataDir/ForceSCGF22.out -time -ele 772006 force];
set SCForce23 [recorder Element -file $dataDir/ForceSCGF23.out -time -ele 773006 force];

set SCRot41 [recorder Element -file $dataDir/RotSCMRF41.out -time -ele 741006 deformation];
set SCRot42 [recorder Element -file $dataDir/RotSCMRF42.out -time -ele 742006 deformation];
set SCRot43 [recorder Element -file $dataDir/RotSCMRF43.out -time -ele 743006 deformation];
set SCRot21 [recorder Element -file $dataDir/RotSCGF21.out -time -ele 771006 deformation];
set SCRot22 [recorder Element -file $dataDir/RotSCGF22.out -time -ele 772006 deformation];
set SCRot23 [recorder Element -file $dataDir/RotSCGF23.out -time -ele 773006 deformation];


# define GRAVITY -------------------------------------------------------------
pattern Plain 1 Linear {
#cargas concentradas				
# Moment Resisting Frame				
load	117	0	-109.0	0
load	217	0	-154.8	0
load	317	0	-154.8	0
load	417	0	-154.8	0
load	517	0	-109.0	0
				
load	127	0	-109.0	0
load	227	0	-154.8	0
load	327	0	-154.8	0
load	427	0	-154.8	0
load	527	0	-109.0	0
				
load	137	0	-93.4	0
load	237	0	-137.4	0
load	337	0	-137.4	0
load	437	0	-137.4	0
load	537	0	-93.4	0
				
#Consolidated Frame				
load	617	0	-527.5	0
load	717	0	-774.0	0
load	817	0	-774.0	0
load	917	0	-774.0	0
load	1017	0	-527.5	0
				
load	627	0	-527.5	0
load	727	0	-774.0	0
load	827	0	-774.0	0
load	927	0	-774.0	0
load	1027	0	-527.5	0
				
load	637	0	-454.6	0
load	737	0	-900.7	0
load	837	0	-900.7	0
load	937	0	-687.2	0
load	1037	0	-454.6	0

#cargas distribuidas					
# Moment Resisting Frame					
eleLoad	-ele	60011	-type	-beamUniform	-15.6
eleLoad	-ele	60021	-type	-beamUniform	-15.6
eleLoad	-ele	60031	-type	-beamUniform	-15.6
eleLoad	-ele	60041	-type	-beamUniform	-15.6
					
eleLoad	-ele	60012	-type	-beamUniform	-15.6
eleLoad	-ele	60022	-type	-beamUniform	-15.6
eleLoad	-ele	60032	-type	-beamUniform	-15.6
eleLoad	-ele	60042	-type	-beamUniform	-15.6
					
eleLoad	-ele	60013	-type	-beamUniform	-13.3
eleLoad	-ele	60023	-type	-beamUniform	-13.3
eleLoad	-ele	60033	-type	-beamUniform	-13.3
eleLoad	-ele	60043	-type	-beamUniform	-13.3
					
# Consolidated Frame					
eleLoad	-ele	60061	-type	-beamUniform	-45.2
eleLoad	-ele	60071	-type	-beamUniform	-45.2
eleLoad	-ele	60081	-type	-beamUniform	-45.2
eleLoad	-ele	60091	-type	-beamUniform	-45.2
					
eleLoad	-ele	60062	-type	-beamUniform	-45.2
eleLoad	-ele	60072	-type	-beamUniform	-45.2
eleLoad	-ele	60082	-type	-beamUniform	-45.2
eleLoad	-ele	60092	-type	-beamUniform	-45.2
					
eleLoad	-ele	60063	-type	-beamUniform	-40.2
eleLoad	-ele	60073	-type	-beamUniform	-64.7
eleLoad	-ele	60083	-type	-beamUniform	-40.2
eleLoad	-ele	60093	-type	-beamUniform	-40.2

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
loadConst -time 0.0;    # keep previous loading constant and reset pseudo-time to zero

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
	
	#puts "EigenVector Analysis:";
	#set f1FM1 [nodeEigenvector 7  1 1];
	#set f2FM1 [nodeEigenvector 12 1 1];
	#set f3FM1 [nodeEigenvector 17 1 1];
	#
	#set f1FM2 [nodeEigenvector 7  2 1];
	#set f2FM2 [nodeEigenvector 12 2 1];
	#set f3FM2 [nodeEigenvector 17 2 1];
    #
	#
	#set f1FM3 [nodeEigenvector 7   3 1];
	#set f2FM3 [nodeEigenvector 12 3 1];
	#set f3FM3 [nodeEigenvector 17 3 1];
	#
	#puts "1st mode";
	#puts "direction 1:";
	#puts "$f1FM1 $f2FM1 $f3FM1";
	#
	#puts "2nd mode";
	#puts "direction 1:";
	#puts "$f1FM2 $f2FM2 $f3FM2";
	#
	#puts "3rd mode";
	#puts "direction 1:";
	#puts "$f1FM3 $f2FM3 $f3FM3";
	
	# write periods to file
	#set Periods_before [open "Periods_before.txt" "w"];
	#puts $Periods_before "$T1	$T2	$T3";
	#close $Periods_before;

	
set analisys_type 2; # pushover = 1; dynamic = 2

####################################################################################################################################################################
## Pushover Analysis
####################################################################################################################################################################

if { $analisys_type == 1 } {

puts "running pushover...";
set Hload "1";		# define the lateral load

pattern Plain 200 Linear {;			# define load pattern
load 1105 [expr $Hload*0.16] 0 0  ;
load 1205 [expr $Hload*0.32] 0 0 ;
load 1305 [expr $Hload*0.52] 0 0 ;
}

#  ---------------------------------    perform Static Pushover Analysis

# integrator   DisplControl  $tagnode  $dof  $displacement increment for each step
integrator DisplacementControl 1103 1 0.001
test NormDispIncr 1.0e-6 200 0
system BandGeneral
numberer RCM
constraints Transformation
algorithm Newton
analysis Static

analyze 500

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
system BandGeneral
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
	foreach GMdirection $iGMdirection GMfile $iGMfile GMfact $iGMfact {
	incr IDloadTag;
	#set inFile $GMfile
	#set outFile $GMfile.g3;			# set variable holding new filename (PEER files have .at2/dt2 extension)
	#ReadSMDFile $inFile $outFile dt;			# call procedure to convert the ground-motion file
	set GMfatt [expr $GMfact];			# data in input file is in g Unifts -- ACCELERATION TH
	timeSeries Path $IDloadTag -dt $dt_accelerogram -filePath $GMfile -factor $GMfatt;		# time series information
	pattern UniformExcitation  $IDloadTag  $GMdirection -accel  $IDloadTag  ;	# create Unifform excitation
	}
	set TmaxAnalysis	[expr $npts_accelerogram*$dt_accelerogram*$sec + 10.*$sec];	# maximum duration of ground-motion analysis 


#Nodal veloccity
#set VelG [recorder Node -file $dataDir/VelG.out -timeSeries $IDloadTag -time -node 1 -dof 1 vel];
#set Vel1 [recorder Node -file $dataDir/Vel1.out -timeSeries $IDloadTag -time -node 6 -dof 1 vel];
#set Vel2 [recorder Node -file $dataDir/Vel2.out -timeSeries $IDloadTag -time -node 11 -dof 1 vel];
#set Vel3 [recorder Node -file $dataDir/Vel3.out -timeSeries $IDloadTag -time -node 16 -dof 1 vel];

#Nodal acceleration
set AcelG [recorder Node -file $dataDir/AcelG.out -timeSeries $IDloadTag -time -node 710008 -dof 1 accel];
set Acel1 [recorder Node -file $dataDir/Acel1.out -timeSeries $IDloadTag -time -node 1105 -dof 1 accel];
set Acel2 [recorder Node -file $dataDir/Acel2.out -timeSeries $IDloadTag -time -node 1205 -dof 1 accel];
set Acel3 [recorder Node -file $dataDir/Acel3.out -timeSeries $IDloadTag -time -node 1305 -dof 1 accel];


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

#for {set i 16} {$i < 28} {incr i} {
#	set curvature1_ant_$i 0;
#	set curvature6_ant_$i 0;
#	set mom1_ant_$i 0;
#	set mom6_ant_$i 0;
#	set edissipated1_$i 0;
#	set edissipated6_$i 0;
#	set nie1_$i 0;
#	set nie6_$i 0;
#	set curv1_max_$i 0;
#	set curv6_max_$i 0;
#	set time_nie1_ant_$i 0;
#	set time_nie6_ant_$i 0;
#	set Rotul1$i 0;
#	set TimeRotul1$i 0;
#	set Rotul2$i 0;
#	set TimeRotul2$i 0;
#}
#
#
#set ediss "energias_dissipadas.txt";
#set Ediss [open $ediss "w"];
#
#set nie "NIE.txt";
#set NIE [open $nie "w"];
#
#set max_curv "curvaturas_maximas.txt";
#set Max_Curv [open $max_curv "w"];
#
#set rotulas "Rotulas_plasticas.txt";
#set Rotulas [open $rotulas "w"];


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
	test NormDispIncr $Tol 100 0;
#	set controlTime [getTime];
#	while {$controlTime < $GMtime && $ok == 0} 
#		set controlTime [getTime]
		puts "trying with a smaller time-step";
		set dt_analysis_2 [expr $DtAnalysis/20];
		set ok [analyze 20 $dt_analysis_2];
		if {$ok != 0} {
		puts "trying with a larger tolerance";
			set Tol_2 [expr $Tol*100];
			algorithm Newton;
			test NormDispIncr $Tol_2 100 0;
			set ok [analyze 20 $dt_analysis_2]
		}
		if {$ok != 0} {
			puts "Trying with Modified Newton..."
			algorithm KrylovNewton;
			test NormDispIncr $Tol_2 100 0;
			set ok [analyze 20 $dt_analysis_2]
		}
		if {$ok != 0} {
			puts "Trying with Newton with Initial Tangent .."
			algorithm Newton -initial;
			test NormDispIncr $Tol_2 100 0;
			set ok [analyze 20 $dt_analysis_2]
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
		
#	set disp_inic_1 [nodeDisp 1 1];
#	set disp_inic_6 [nodeDisp 6 1];
#	set disp_inic_11 [nodeDisp 11 1];
#	set disp_inic_16 [nodeDisp 16 1];
#	
#	set acel_inic_16 [nodeAccel 16 1];
#	set acel_inic_11 [nodeAccel 11 1];
#	set acel_inic_6 [nodeAccel 6 1];
#	
#	if { [expr abs($disp_inic_16)] > [expr abs($disp_16)] } {
#		set disp_16 $disp_inic_16;
#	}
#	
#		set drift_inic_1 [expr $disp_inic_6 - $disp_inic_1];
#		set drift_inic_2 [expr $disp_inic_11 - $disp_inic_6];
#		set drift_inic_3 [expr $disp_inic_16 - $disp_inic_11];	
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
#	
#	if { [expr abs($acel_inic_16)] > [expr abs($acel_16)] } {
#		set acel_16 $acel_inic_16;
#	}
#	if { [expr abs($acel_inic_11)] > [expr abs($acel_11)] } {
#		set acel_11 $acel_inic_11;
#	}
#	if { [expr abs($acel_inic_6)] > [expr abs($acel_6)] } {
#		set acel_6 $acel_inic_6;
#	}
#	
#	
#		for {set i 16} {$i < 28} {incr i} {
#			
#			set curv1 [eleResponse $i section 1 deformations];
#			set curv2 [eleResponse $i section 6 deformations];
#			set forces [eleResponse $i forces];
#			
#			set curvature1 [lindex $curv1 2];
#			set curvature6 [lindex $curv2 2];
#			set mom1 [lindex $forces 2];
#			set mom6 [lindex $forces 5];
#			
#			set curvature1_ant [eval {set curvature1_ant_$i}];
#			set curvature6_ant [eval {set curvature6_ant_$i}];
#			set mom1_ant [eval {set mom1_ant_$i}];
#			set mom6_ant [eval {set mom6_ant_$i}];
#			
#			set edissipated1 [eval {set edissipated1_$i}];
#			set edissipated6 [eval {set edissipated6_$i}];
#			
#			set edissipated1_$i [expr $edissipated1 + ($curvature1-$curvature1_ant)*($mom1+$mom1_ant)/2.];
#			set edissipated6_$i [expr $edissipated6 + ($curvature6-$curvature6_ant)*($mom6+$mom6_ant)/2.];
#			
#			set time_nie1_ant [eval {set time_nie1_ant_$i}];
#			set time_nie6_ant [eval {set time_nie6_ant_$i}];
#			
#			if { [expr $mom1_ant*$mom1] < 0 && [expr $time - $time_nie1_ant] >= 0.5 } {
#			incr nie1_$i;
#			}
#			if { [expr $mom6_ant*$mom6] < 0 && [expr $time - $time_nie6_ant] >= 0.5 } {
#			incr nie6_$i;
#			}
#			
#			set curv1_max [eval {set curv1_max_$i}];
#			if {abs($curvature1) >  abs($curv1_max)} {
#				set curv1_max_$i	$curvature1;
#			}
#			set curv6_max [eval {set curv6_max_$i}];
#			if {abs($curvature6) >  abs($curv6_max)} {
#				set curv6_max_$i	$curvature6;
#			}
#			
#			set curvature1_ant_$i $curvature1;
#			set curvature6_ant_$i $curvature6;
#			set mom1_ant_$i $mom1;
#			set mom6_ant_$i $mom6;
#			
#			if {$i <= 18} {
#			set MyViga $MyW33x118;
#			} elseif {$i <= 19} {
#				set MyViga $MyW21x44;
#			} elseif {$i <= 22} {
#				set MyViga $MyW30x116;
#			} elseif {$i <= 23} {
#				set MyViga $MyW21x44;
#			} elseif {$i <= 26} {
#				set MyViga $MyW24x68;
#			} else {
#				set MyViga $MyW21x44;
#			};
#
#			if { [eval {set Rotul1$i}] == 0 && abs($mom1)>$MyViga} {
#					set Rotul1$i 1;
#					set TimeRotul1$i [getTime];
#			}
#			if { [eval {set Rotul2$i}] == 0 && abs($mom6)>$MyViga} {
#					set Rotul2$i 1;
#					set TimeRotul2$i [getTime];
#			}
#	
#		}
	
	
	set Niter [expr $Niter +1 ];
	set time [expr [getTime] + $time_ajust];
	}
	
#			#file escrecer resultados
#		for {set i 16} {$i < 28} {incr i} {
#		set edissipated1 [expr abs([eval {set edissipated1_$i}])];
#		set edissipated6 [expr abs([eval {set edissipated6_$i}])];
#		puts $Ediss " $edissipated1	$edissipated6 ";
#		set nie1 [eval {set nie1_$i}];
#		set nie6 [eval {set nie6_$i}];
#		puts $NIE " $nie1	$nie6 ";
#		set curv1_max [expr abs([eval {set curv1_max_$i}])];
#		set curv6_max [expr abs([eval {set curv6_max_$i}])];
#		puts $Max_Curv " $curv1_max	$curv6_max ";
#		set Rotula [eval {set Rotul1$i}];
#		set TimeRotula [eval {set TimeRotul1$i}];
#		puts $Rotulas "$Rotula  $TimeRotula ";
#		set Rotula [eval {set Rotul2$i}];
#		set TimeRotula [eval {set TimeRotul2$i}];
#		puts $Rotulas "$Rotula  $TimeRotula ";
#		}
#		close $Ediss	
#		close $NIE	
#		close $Max_Curv	
#		close $Rotulas	


if {$ok == 0} {
			puts "Dynamic analysis complete";
		} else {
			puts "Dynamic analysis did not converge";
		}	
		
#		# disp peak response and write to output file
#		puts $file_results " $disp_16	$disp_inic_16	$drift1	$drift2	$drift3	$drift_inic_1	$drift_inic_2	$drift_inic_3	$acel_6	$acel_11	$acel_16"
#		close $file_results		
		
# output time at end of analysis	
set currentTime [getTime];	# get current analysis time	(after dynamic analysis)
puts "The current time is: $currentTime (Total time: $TmaxAnalysis)";


}	
wipe;
