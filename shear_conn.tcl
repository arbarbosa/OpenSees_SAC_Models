#definir secções
set SC36x160 36;
set My [expr 624.*pow($in,3)*$Fy_beam];
uniaxialMaterial ElasticPP $SC36x160 [expr 0.2*$My/0.02] 0.02 -0.01 ;

set SC36x135 365;
set My [expr 509.*pow($in,3)*$Fy_beam];
uniaxialMaterial ElasticPP $SC36x135 [expr 0.2*$My/0.02] 0.02 -0.01 ;

set SC30x99 301;
set My [expr 312.*pow($in,3)*$Fy_beam];
uniaxialMaterial ElasticPP $SC30x99 [expr 0.2*$My/0.02] 0.02 -0.01 ;

set SC27x84 270;
set My [expr 244.*pow($in,3)*$Fy_beam];
uniaxialMaterial ElasticPP $SC27x84 [expr 0.2*$My/0.02] 0.02 -0.01 ;

set SC24x68 240;
set My [expr 177.*pow($in,3)*$Fy_beam];
uniaxialMaterial ElasticPP $SC24x68 [expr 0.2*$My/0.02] 0.02 -0.01 ;

set SC21x44_CF 242;
set My [expr 0.00313*$Fy_beam];
uniaxialMaterial ElasticPP $SC21x44_CF [expr 0.2*$My/0.02] 0.02 -0.01 ;

set SC18x35_CF 245;
set My [expr 0.00218*$Fy_beam];
uniaxialMaterial ElasticPP $SC18x35_CF [expr 0.2*$My/0.02] 0.02 -0.01 ;

set SC16x26_CF 246;
set My [expr 0.00145*$Fy_beam];
uniaxialMaterial ElasticPP $SC16x26_CF [expr 0.2*$My/0.02] 0.02 -0.01 ;

set SC21x44_16x26_CF 247;
set My [expr 0.00229*$Fy_beam];
uniaxialMaterial ElasticPP $SC21x44_16x26_CF [expr 0.2*$My/0.02] 0.02 -0.01 ;


element	zeroLength	761004	6110	6111	-mat	$SC36x160	-dir	6
element	zeroLength	762004	6210	6211	-mat	$SC36x160	-dir	6
element	zeroLength	763004	6310	6311	-mat	$SC36x160	-dir	6
element	zeroLength	764004	6410	6411	-mat	$SC36x135	-dir	6
element	zeroLength	765004	6510	6511	-mat	$SC36x135	-dir	6
element	zeroLength	766004	6610	6611	-mat	$SC36x135	-dir	6
element	zeroLength	767004	6710	6711	-mat	$SC36x135	-dir	6
element	zeroLength	768004	6810	6811	-mat	$SC30x99	-dir	6
element	zeroLength	769004	6910	6911	-mat	$SC27x84	-dir	6
element	zeroLength	76100004	610010	610011	-mat	$SC24x68	-dir	6
#								
element	zeroLength	771006	7105	7111	-mat	$SC21x44_CF	-dir	6
element	zeroLength	772006	7205	7211	-mat	$SC18x35_CF	-dir	6
element	zeroLength	773006	7305	7311	-mat	$SC18x35_CF	-dir	6
element	zeroLength	774006	7405	7411	-mat	$SC18x35_CF	-dir	6
element	zeroLength	775006	7505	7511	-mat	$SC18x35_CF	-dir	6
element	zeroLength	776006	7605	7611	-mat	$SC18x35_CF	-dir	6
element	zeroLength	777006	7705	7711	-mat	$SC18x35_CF	-dir	6
element	zeroLength	778006	7805	7811	-mat	$SC18x35_CF	-dir	6
element	zeroLength	779006	7905	7911	-mat	$SC18x35_CF	-dir	6
element	zeroLength	77100006	710005	710011	-mat	$SC16x26_CF	-dir	6
#								
element	zeroLength	781004	8110	8111	-mat	$SC21x44_CF	-dir	6
element	zeroLength	782004	8210	8211	-mat	$SC18x35_CF	-dir	6
element	zeroLength	783004	8310	8311	-mat	$SC18x35_CF	-dir	6
element	zeroLength	784004	8410	8411	-mat	$SC18x35_CF	-dir	6
element	zeroLength	785004	8510	8511	-mat	$SC18x35_CF	-dir	6
element	zeroLength	786004	8610	8611	-mat	$SC18x35_CF	-dir	6
element	zeroLength	787004	8710	8711	-mat	$SC18x35_CF	-dir	6
element	zeroLength	788004	8810	8811	-mat	$SC18x35_CF	-dir	6
element	zeroLength	789004	8910	8911	-mat	$SC18x35_CF	-dir	6
element	zeroLength	78100004	810010	810011	-mat	$SC16x26_CF	-dir	6
#								
element	zeroLength	781006	8105	8112	-mat	$SC21x44_CF	-dir	6
element	zeroLength	782006	8205	8212	-mat	$SC18x35_CF	-dir	6
element	zeroLength	783006	8305	8312	-mat	$SC18x35_CF	-dir	6
element	zeroLength	784006	8405	8412	-mat	$SC18x35_CF	-dir	6
element	zeroLength	785006	8505	8512	-mat	$SC18x35_CF	-dir	6
element	zeroLength	786006	8605	8612	-mat	$SC18x35_CF	-dir	6
element	zeroLength	787006	8705	8712	-mat	$SC18x35_CF	-dir	6
element	zeroLength	788006	8805	8812	-mat	$SC18x35_CF	-dir	6
element	zeroLength	789006	8905	8912	-mat	$SC18x35_CF	-dir	6
element	zeroLength	78100006	810005	810012	-mat	$SC21x44_16x26_CF	-dir	6
#								
element	zeroLength	791004	9110	9111	-mat	$SC21x44_CF	-dir	6
element	zeroLength	792004	9210	9211	-mat	$SC18x35_CF	-dir	6
element	zeroLength	793004	9310	9311	-mat	$SC18x35_CF	-dir	6
element	zeroLength	794004	9410	9411	-mat	$SC18x35_CF	-dir	6
element	zeroLength	795004	9510	9511	-mat	$SC18x35_CF	-dir	6
element	zeroLength	796004	9610	9611	-mat	$SC18x35_CF	-dir	6
element	zeroLength	797004	9710	9711	-mat	$SC18x35_CF	-dir	6
element	zeroLength	798004	9810	9811	-mat	$SC18x35_CF	-dir	6
element	zeroLength	799004	9910	9911	-mat	$SC18x35_CF	-dir	6
element	zeroLength	79100004	910010	910011	-mat	$SC21x44_16x26_CF	-dir	6
#								
element	zeroLength	791006	9105	9112	-mat	$SC21x44_CF	-dir	6
element	zeroLength	792006	9205	9212	-mat	$SC18x35_CF	-dir	6
element	zeroLength	793006	9305	9312	-mat	$SC18x35_CF	-dir	6
element	zeroLength	794006	9405	9412	-mat	$SC18x35_CF	-dir	6
element	zeroLength	795006	9505	9512	-mat	$SC18x35_CF	-dir	6
element	zeroLength	796006	9605	9612	-mat	$SC18x35_CF	-dir	6
element	zeroLength	797006	9705	9712	-mat	$SC18x35_CF	-dir	6
element	zeroLength	798006	9805	9812	-mat	$SC18x35_CF	-dir	6
element	zeroLength	799006	9905	9912	-mat	$SC18x35_CF	-dir	6
element	zeroLength	79100006	910005	910012	-mat	$SC21x44_16x26_CF	-dir	6
#								
element	zeroLength	7101004	10110	10111	-mat	$SC21x44_CF	-dir	6
element	zeroLength	7102004	10210	10211	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7103004	10310	10311	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7104004	10410	10411	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7105004	10510	10511	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7106004	10610	10611	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7107004	10710	10711	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7108004	10810	10811	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7109004	10910	10911	-mat	$SC18x35_CF	-dir	6
element	zeroLength	710100004	1010010	1010011	-mat	$SC21x44_16x26_CF	-dir	6
#								
element	zeroLength	7101006	10105	10112	-mat	$SC21x44_CF	-dir	6
element	zeroLength	7102006	10205	10212	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7103006	10305	10312	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7104006	10405	10412	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7105006	10505	10512	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7106006	10605	10612	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7107006	10705	10712	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7108006	10805	10812	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7109006	10905	10912	-mat	$SC18x35_CF	-dir	6
element	zeroLength	710100006	1010005	1010012	-mat	$SC16x26_CF	-dir	6
#								
element	zeroLength	7111004	11110	11111	-mat	$SC21x44_CF	-dir	6
element	zeroLength	7112004	11210	11211	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7113004	11310	11311	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7114004	11410	11411	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7115004	11510	11511	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7116004	11610	11611	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7117004	11710	11711	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7118004	11810	11811	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7119004	11910	11911	-mat	$SC18x35_CF	-dir	6
element	zeroLength	711100004	1110010	1110011	-mat	$SC16x26_CF	-dir	6
#								
element	zeroLength	7111006	11105	11112	-mat	$SC21x44_CF	-dir	6
element	zeroLength	7112006	11205	11212	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7113006	11305	11312	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7114006	11405	11412	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7115006	11505	11512	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7116006	11605	11612	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7117006	11705	11712	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7118006	11805	11812	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7119006	11905	11912	-mat	$SC18x35_CF	-dir	6
element	zeroLength	711100006	1110005	1110012	-mat	$SC16x26_CF	-dir	6
#								
element	zeroLength	7121004	12110	12111	-mat	$SC21x44_CF	-dir	6
element	zeroLength	7122004	12210	12211	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7123004	12310	12311	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7124004	12410	12411	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7125004	12510	12511	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7126004	12610	12611	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7127004	12710	12711	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7128004	12810	12811	-mat	$SC18x35_CF	-dir	6
element	zeroLength	7129004	12910	12911	-mat	$SC18x35_CF	-dir	6
element	zeroLength	712100004	1210010	1210011	-mat	$SC16x26_CF	-dir	6
								
								
equalDOF	6110	6111	1    2		
equalDOF	6210	6211	1    2		
equalDOF	6310	6311	1    2		
equalDOF	6410	6411	1    2		
equalDOF	6510	6511	1    2		
equalDOF	6610	6611	1    2		
equalDOF	6710	6711	1    2		
equalDOF	6810	6811	1    2		
equalDOF	6910	6911	1    2		
equalDOF	610010	610011	1    2		
								
equalDOF	7105	7111	1    2		
equalDOF	7205	7211	1    2		
equalDOF	7305	7311	1    2		
equalDOF	7405	7411	1    2		
equalDOF	7505	7511	1    2		
equalDOF	7605	7611	1    2		
equalDOF	7705	7711	1    2		
equalDOF	7805	7811	1    2		
equalDOF	7905	7911	1    2		
equalDOF	710005	710011	1    2		
								 
equalDOF	8110	8111	1    2		
equalDOF	8210	8211	1    2		
equalDOF	8310	8311	1    2		
equalDOF	8410	8411	1    2		
equalDOF	8510	8511	1    2		
equalDOF	8610	8611	1    2		
equalDOF	8710	8711	1    2		
equalDOF	8810	8811	1    2		
equalDOF	8910	8911	1    2		
equalDOF	810010	810011	1    2		
								
equalDOF	8105	8112	1    2		
equalDOF	8205	8212	1    2		
equalDOF	8305	8312	1    2		
equalDOF	8405	8412	1    2		
equalDOF	8505	8512	1    2		
equalDOF	8605	8612	1    2		
equalDOF	8705	8712	1    2		
equalDOF	8805	8812	1    2		
equalDOF	8905	8912	1    2		
equalDOF	810005	810012	1    2		
								   
equalDOF	9110	9111	1    2		
equalDOF	9210	9211	1    2		
equalDOF	9310	9311	1    2		
equalDOF	9410	9411	1    2		
equalDOF	9510	9511	1    2		
equalDOF	9610	9611	1    2		
equalDOF	9710	9711	1    2		
equalDOF	9810	9811	1    2		
equalDOF	9910	9911	1    2		
equalDOF	910010	910011	1    2		
								 
equalDOF	9105	9112	1    2		
equalDOF	9205	9212	1    2		
equalDOF	9305	9312	1    2		
equalDOF	9405	9412	1    2		
equalDOF	9505	9512	1    2		
equalDOF	9605	9612	1    2		
equalDOF	9705	9712	1    2		
equalDOF	9805	9812	1    2		
equalDOF	9905	9912	1    2		
equalDOF	910005	910012	1    2		
								   
equalDOF	10110	10111	1    2		
equalDOF	10210	10211	1    2		
equalDOF	10310	10311	1    2		
equalDOF	10410	10411	1    2		
equalDOF	10510	10511	1    2		
equalDOF	10610	10611	1    2		
equalDOF	10710	10711	1    2		
equalDOF	10810	10811	1    2		
equalDOF	10910	10911	1    2		
equalDOF	1010010	1010011	1    2		
								 
equalDOF	10105	10112	1    2		
equalDOF	10205	10212	1    2		
equalDOF	10305	10312	1    2		
equalDOF	10405	10412	1    2		
equalDOF	10505	10512	1    2		
equalDOF	10605	10612	1    2		
equalDOF	10705	10712	1    2		
equalDOF	10805	10812	1    2		
equalDOF	10905	10912	1    2		
equalDOF	1010005	1010012	1    2		
								  
equalDOF	11110	11111	1    2		
equalDOF	11210	11211	1    2		
equalDOF	11310	11311	1    2		
equalDOF	11410	11411	1    2		
equalDOF	11510	11511	1    2		
equalDOF	11610	11611	1    2		
equalDOF	11710	11711	1    2		
equalDOF	11810	11811	1    2		
equalDOF	11910	11911	1    2		
equalDOF	1110010	1110011	1    2		
								    
equalDOF	11105	11112	1    2		
equalDOF	11205	11212	1    2		
equalDOF	11305	11312	1    2		
equalDOF	11405	11412	1    2		
equalDOF	11505	11512	1    2		
equalDOF	11605	11612	1    2		
equalDOF	11705	11712	1    2		
equalDOF	11805	11812	1    2		
equalDOF	11905	11912	1    2		
equalDOF	1110005	1110012	1    2		
								    
equalDOF	12110	12111	1    2		
equalDOF	12210	12211	1    2		
equalDOF	12310	12311	1    2		
equalDOF	12410	12411	1    2		
equalDOF	12510	12511	1    2		
equalDOF	12610	12611	1    2		
equalDOF	12710	12711	1    2		
equalDOF	12810	12811	1    2		
equalDOF	12910	12911	1    2		
equalDOF	1210010	1210011	1    2