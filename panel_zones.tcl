# 1) define elastic panel zone elements (assume rigid)
	# elemPanelZone2D creates 8 elastic elements that form a rectangular panel zone
	# references provided in elemPanelZone2D.tcl
	# note: the nodeID and eleID of the upper left corner of the PZ must be imported
	# eleID convention:  500xy. 500 = panel zone element. x = Pier #. y = Floor #
	
set Apz 100.0;	# area of panel zone element (make much larger than A of frame elements)
set Ipz 1.0;  # moment of intertia of panel zone element (make much larger than I of frame elements)

# elemPanelZone2D eleID  nodeR E  A_PZ I_PZ transfTag

# elastic elements															
elemPanelZone2D	500111	1101	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500211	2101	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500311	3101	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500411	4101	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500511	5101	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500611	6101	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500711	7101	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500811	8101	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500911	9101	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001011	10101	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001111	11101	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001211	12101	[expr 1e4*$GPa]	1	10	$TransfTag;									
															
elemPanelZone2D	500121	1201	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500221	2201	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500321	3201	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500421	4201	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500521	5201	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500621	6201	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500721	7201	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500821	8201	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500921	9201	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001021	10201	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001121	11201	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001221	12201	[expr 1e4*$GPa]	1	10	$TransfTag;									
															
elemPanelZone2D	500131	1301	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500231	2301	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500331	3301	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500431	4301	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500531	5301	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500631	6301	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500731	7301	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500831	8301	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500931	9301	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001031	10301	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001131	11301	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001231	12301	[expr 1e4*$GPa]	1	10	$TransfTag;									
															
elemPanelZone2D	500141	1401	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500241	2401	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500341	3401	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500441	4401	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500541	5401	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500641	6401	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500741	7401	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500841	8401	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500941	9401	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001041	10401	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001141	11401	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001241	12401	[expr 1e4*$GPa]	1	10	$TransfTag;									
															
elemPanelZone2D	500151	1501	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500251	2501	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500351	3501	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500451	4501	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500551	5501	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500651	6501	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500751	7501	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500851	8501	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500951	9501	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001051	10501	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001151	11501	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001251	12501	[expr 1e4*$GPa]	1	10	$TransfTag;									
															
elemPanelZone2D	500161	1601	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500261	2601	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500361	3601	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500461	4601	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500561	5601	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500661	6601	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500761	7601	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500861	8601	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500961	9601	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001061	10601	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001161	11601	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001261	12601	[expr 1e4*$GPa]	1	10	$TransfTag;									
															
elemPanelZone2D	500171	1701	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500271	2701	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500371	3701	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500471	4701	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500571	5701	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500671	6701	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500771	7701	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500871	8701	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500971	9701	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001071	10701	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001171	11701	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001271	12701	[expr 1e4*$GPa]	1	10	$TransfTag;									
															
elemPanelZone2D	500181	1801	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500281	2801	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500381	3801	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500481	4801	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500581	5801	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500681	6801	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500781	7801	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500881	8801	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500981	9801	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001081	10801	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001181	11801	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001281	12801	[expr 1e4*$GPa]	1	10	$TransfTag;									
															
elemPanelZone2D	500191	1901	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500291	2901	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500391	3901	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500491	4901	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500591	5901	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500691	6901	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500791	7901	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500891	8901	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500991	9901	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001091	10901	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001191	11901	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	5001291	12901	[expr 1e4*$GPa]	1	10	$TransfTag;									
															
elemPanelZone2D	 50011001	 110001	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	 50021001	 210001	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	 50031001	 310001	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	 50041001	 410001	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	 50051001	 510001	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	 50061001	 610001	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	 50071001	 710001	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	 50081001	 810001	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	 50091001	 910001	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500101001	1010001	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500111001	1110001	[expr 1e4*$GPa]	1	10	$TransfTag;									
elemPanelZone2D	500121001	1210001	[expr 1e4*$GPa]	1	10	$TransfTag;									
															
															
# PZ Springs															
#	ElemID	ndR	ndC		E		Fy_column		dc	bf_c	tf_c	tp	db	Ry	as
rotPanelZone2D	41100	1103	1104		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.914654	1.0	0.03;
rotPanelZone2D	42100	2103	2104		$Es		$Fy_column		0.49784	0.432054	0.0889	0.055626	0.914654	1.0	0.03;
rotPanelZone2D	43100	3103	3104		$Es		$Fy_column		0.49784	0.432054	0.0889	0.055626	0.914654	1.0	0.03;
rotPanelZone2D	44100	4103	4104		$Es		$Fy_column		0.49784	0.432054	0.0889	0.055626	0.914654	1.0	0.03;
rotPanelZone2D	45100	5103	5104		$Es		$Fy_column		0.49784	0.432054	0.0889	0.055626	0.914654	1.0	0.03;
rotPanelZone2D	46100	6103	6104		$Es		$Fy_column		0.418465	0.455168	0.067564	0.042037	0.914654	1.0	0.03;
rotPanelZone2D	47100	7103	7104	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.432054	0.49784	0.0889	0.055626	0.524764	1.0	0.03;
rotPanelZone2D	48100	8103	8104	[expr $Es*	1.916	]         [expr $Fy_column*	1.910	]	0.399288	0.40132	0.039624	0.024892	0.524764	1.0	0.03;
rotPanelZone2D	49100	9103	9104	[expr $Es*	1.916	]         [expr $Fy_column*	1.910	]	0.399288	0.40132	0.039624	0.024892	0.524764	1.0	0.03;
rotPanelZone2D	410100	10103	10104	[expr $Es*	1.916	]         [expr $Fy_column*	1.910	]	0.399288	0.40132	0.039624	0.024892	0.524764	1.0	0.03;
rotPanelZone2D	411100	11103	11104	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.393192	0.399034	0.036576	0.022606	0.524764	1.0	0.03;
rotPanelZone2D	412100	12103	12104	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.432054	0.49784	0.0889	0.055626	0.524764	1.0	0.03;
															
rotPanelZone2D	41200	1203	1204		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.914654	1.0	0.03;
rotPanelZone2D	42200	2203	2204		$Es		$Fy_column		0.49784	0.432054	0.0889	0.055626	0.914654	1.0	0.03;
rotPanelZone2D	43200	3203	3204		$Es		$Fy_column		0.49784	0.432054	0.0889	0.055626	0.914654	1.0	0.03;
rotPanelZone2D	44200	4203	4204		$Es		$Fy_column		0.49784	0.432054	0.0889	0.055626	0.914654	1.0	0.03;
rotPanelZone2D	45200	5203	5204		$Es		$Fy_column		0.49784	0.432054	0.0889	0.055626	0.914654	1.0	0.03;
rotPanelZone2D	46200	6203	6204		$Es		$Fy_column		0.418465	0.455168	0.067564	0.042037	0.914654	1.0	0.03;
rotPanelZone2D	47200	7203	7204	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.432054	0.49784	0.0889	0.055626	0.44958	1.0	0.03;
rotPanelZone2D	48200	8203	8204	[expr $Es*	1.916	]         [expr $Fy_column*	1.910	]	0.399288	0.40132	0.039624	0.024892	0.44958	1.0	0.03;
rotPanelZone2D	49200	9203	9204	[expr $Es*	1.916	]         [expr $Fy_column*	1.910	]	0.399288	0.40132	0.039624	0.024892	0.44958	1.0	0.03;
rotPanelZone2D	410200	10203	10204	[expr $Es*	1.916	]         [expr $Fy_column*	1.910	]	0.399288	0.40132	0.039624	0.024892	0.44958	1.0	0.03;
rotPanelZone2D	411200	11203	11204	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.393192	0.399034	0.036576	0.022606	0.44958	1.0	0.03;
rotPanelZone2D	412200	12203	12204	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.432054	0.49784	0.0889	0.055626	0.44958	1.0	0.03;
															
rotPanelZone2D	41300	1303	1304		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.914654	1.0	0.03;
rotPanelZone2D	42300	2303	2304		$Es		$Fy_column		0.483108	0.427609	0.081534	0.051181	0.914654	1.0	0.03;
rotPanelZone2D	43300	3303	3304		$Es		$Fy_column		0.483108	0.427609	0.081534	0.051181	0.914654	1.0	0.03;
rotPanelZone2D	44300	4303	4304		$Es		$Fy_column		0.483108	0.427609	0.081534	0.051181	0.914654	1.0	0.03;
rotPanelZone2D	45300	5303	5304		$Es		$Fy_column		0.483108	0.427609	0.081534	0.051181	0.914654	1.0	0.03;
rotPanelZone2D	46300	6303	6304		$Es		$Fy_column		0.418465	0.455168	0.067564	0.042037	0.914654	1.0	0.03;
rotPanelZone2D	47300	7303	7304	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.427609	0.483108	0.081534	0.051181	0.44958	1.0	0.03;
rotPanelZone2D	48300	8303	8304	[expr $Es*	1.914	]         [expr $Fy_column*	1.916	]	0.380492	0.395351	0.030226	0.018923	0.44958	1.0	0.03;
rotPanelZone2D	49300	9303	9304	[expr $Es*	1.914	]         [expr $Fy_column*	1.916	]	0.380492	0.395351	0.030226	0.018923	0.44958	1.0	0.03;
rotPanelZone2D	410300	10303	10304	[expr $Es*	1.914	]         [expr $Fy_column*	1.916	]	0.380492	0.395351	0.030226	0.018923	0.44958	1.0	0.03;
rotPanelZone2D	411300	11303	11304	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.375412	0.3937	0.027686	0.017272	0.44958	1.0	0.03;
rotPanelZone2D	412300	12303	12304	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.427609	0.483108	0.081534	0.051181	0.44958	1.0	0.03;
															
rotPanelZone2D	41400	1403	1404		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.90297	1.0	0.03;
rotPanelZone2D	42400	2403	2404		$Es		$Fy_column		0.483108	0.427609	0.081534	0.051181	0.90297	1.0	0.03;
rotPanelZone2D	43400	3403	3404		$Es		$Fy_column		0.483108	0.427609	0.081534	0.051181	0.90297	1.0	0.03;
rotPanelZone2D	44400	4403	4404		$Es		$Fy_column		0.483108	0.427609	0.081534	0.051181	0.90297	1.0	0.03;
rotPanelZone2D	45400	5403	5404		$Es		$Fy_column		0.483108	0.427609	0.081534	0.051181	0.90297	1.0	0.03;
rotPanelZone2D	46400	6403	6404		$Es		$Fy_column		0.418465	0.455168	0.067564	0.042037	0.90297	1.0	0.03;
rotPanelZone2D	47400	7403	7404	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.427609	0.483108	0.081534	0.051181	0.44958	1.0	0.03;
rotPanelZone2D	48400	8403	8404	[expr $Es*	1.914	]         [expr $Fy_column*	1.916	]	0.380492	0.395351	0.030226	0.018923	0.44958	1.0	0.03;
rotPanelZone2D	49400	9403	9404	[expr $Es*	1.914	]         [expr $Fy_column*	1.916	]	0.380492	0.395351	0.030226	0.018923	0.44958	1.0	0.03;
rotPanelZone2D	410400	10403	10404	[expr $Es*	1.914	]         [expr $Fy_column*	1.916	]	0.380492	0.395351	0.030226	0.018923	0.44958	1.0	0.03;
rotPanelZone2D	411400	11403	11404	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.375412	0.3937	0.027686	0.017272	0.44958	1.0	0.03;
rotPanelZone2D	412400	12403	12404	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.427609	0.483108	0.081534	0.051181	0.44958	1.0	0.03;
															
rotPanelZone2D	41500	1503	1504		$Es		$Fy_column		0.425196	0.409194	0.052578	0.032766	0.90297	1.0	0.03;
rotPanelZone2D	42500	2503	2504		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.90297	1.0	0.03;
rotPanelZone2D	43500	3503	3504		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.90297	1.0	0.03;
rotPanelZone2D	44500	4503	4504		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.90297	1.0	0.03;
rotPanelZone2D	45500	5503	5504		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.90297	1.0	0.03;
rotPanelZone2D	46500	6503	6504		$Es		$Fy_column		0.409194	0.425196	0.052578	0.032766	0.90297	1.0	0.03;
rotPanelZone2D	47500	7503	7504	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.418465	0.455168	0.067564	0.042037	0.44958	1.0	0.03;
rotPanelZone2D	48500	8503	8504	[expr $Es*	1.907	]         [expr $Fy_column*	1.906	]	0.367792	0.372618	0.023876	0.014986	0.44958	1.0	0.03;
rotPanelZone2D	49500	9503	9504	[expr $Es*	1.907	]         [expr $Fy_column*	1.906	]	0.367792	0.372618	0.023876	0.014986	0.44958	1.0	0.03;
rotPanelZone2D	410500	10503	10504	[expr $Es*	1.907	]         [expr $Fy_column*	1.906	]	0.367792	0.372618	0.023876	0.014986	0.44958	1.0	0.03;
rotPanelZone2D	411500	11503	11504	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.363728	0.371729	0.021844	0.013335	0.44958	1.0	0.03;
rotPanelZone2D	412500	12503	12504	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.418465	0.455168	0.067564	0.042037	0.44958	1.0	0.03;
															
rotPanelZone2D	41600	1603	1604		$Es		$Fy_column		0.425196	0.409194	0.052578	0.032766	0.90297	1.0	0.03;
rotPanelZone2D	42600	2603	2604		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.90297	1.0	0.03;
rotPanelZone2D	43600	3603	3604		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.90297	1.0	0.03;
rotPanelZone2D	44600	4603	4604		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.90297	1.0	0.03;
rotPanelZone2D	45600	5603	5604		$Es		$Fy_column		0.455168	0.418465	0.067564	0.042037	0.90297	1.0	0.03;
rotPanelZone2D	46600	6603	6604		$Es		$Fy_column		0.409194	0.425196	0.052578	0.032766	0.90297	1.0	0.03;
rotPanelZone2D	47600	7603	7604	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.418465	0.455168	0.067564	0.042037	0.44958	1.0	0.03;
rotPanelZone2D	48600	8603	8604	[expr $Es*	1.907	]         [expr $Fy_column*	1.906	]	0.367792	0.372618	0.023876	0.014986	0.44958	1.0	0.03;
rotPanelZone2D	49600	9603	9604	[expr $Es*	1.907	]         [expr $Fy_column*	1.906	]	0.367792	0.372618	0.023876	0.014986	0.44958	1.0	0.03;
rotPanelZone2D	410600	10603	10604	[expr $Es*	1.907	]         [expr $Fy_column*	1.906	]	0.367792	0.372618	0.023876	0.014986	0.44958	1.0	0.03;
rotPanelZone2D	411600	11603	11604	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.363728	0.371729	0.021844	0.013335	0.44958	1.0	0.03;
rotPanelZone2D	412600	12603	12604	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.418465	0.455168	0.067564	0.042037	0.44958	1.0	0.03;
															
rotPanelZone2D	41700	1703	1704		$Es		$Fy_column		0.416052	0.406273	0.048006	0.029845	0.90297	1.0	0.03;
rotPanelZone2D	42700	2703	2704		$Es		$Fy_column		0.425196	0.409194	0.052578	0.032766	0.90297	1.0	0.03;
rotPanelZone2D	43700	3703	3704		$Es		$Fy_column		0.425196	0.409194	0.052578	0.032766	0.90297	1.0	0.03;
rotPanelZone2D	44700	4703	4704		$Es		$Fy_column		0.425196	0.409194	0.052578	0.032766	0.90297	1.0	0.03;
rotPanelZone2D	45700	5703	5704		$Es		$Fy_column		0.425196	0.409194	0.052578	0.032766	0.90297	1.0	0.03;
rotPanelZone2D	46700	6703	6704		$Es		$Fy_column		0.406273	0.416052	0.048006	0.029845	0.90297	1.0	0.03;
rotPanelZone2D	47700	7703	7704	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.409194	0.425196	0.052578	0.032766	0.44958	1.0	0.03;
rotPanelZone2D	48700	8703	8704	[expr $Es*	1.909	]         [expr $Fy_column*	1.892	]	0.356108	0.368808	0.018034	0.011176	0.44958	1.0	0.03;
rotPanelZone2D	49700	9703	9704	[expr $Es*	1.909	]         [expr $Fy_column*	1.892	]	0.356108	0.368808	0.018034	0.011176	0.44958	1.0	0.03;
rotPanelZone2D	410700	10703	10704	[expr $Es*	1.909	]         [expr $Fy_column*	1.892	]	0.356108	0.368808	0.018034	0.011176	0.44958	1.0	0.03;
rotPanelZone2D	411700	11703	11704	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.363474	0.257302	0.021717	0.012954	0.44958	1.0	0.03;
rotPanelZone2D	412700	12703	12704	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.409194	0.425196	0.052578	0.032766	0.44958	1.0	0.03;
															
rotPanelZone2D	41800	1803	1804		$Es		$Fy_column		0.416052	0.406273	0.048006	0.029845	0.75311	1.0	0.03;
rotPanelZone2D	42800	2803	2804		$Es		$Fy_column		0.425196	0.409194	0.052578	0.032766	0.75311	1.0	0.03;
rotPanelZone2D	43800	3803	3804		$Es		$Fy_column		0.425196	0.409194	0.052578	0.032766	0.75311	1.0	0.03;
rotPanelZone2D	44800	4803	4804		$Es		$Fy_column		0.425196	0.409194	0.052578	0.032766	0.75311	1.0	0.03;
rotPanelZone2D	45800	5803	5804		$Es		$Fy_column		0.425196	0.409194	0.052578	0.032766	0.75311	1.0	0.03;
rotPanelZone2D	46800	6803	6804		$Es		$Fy_column		0.406273	0.416052	0.048006	0.029845	0.75311	1.0	0.03;
rotPanelZone2D	47800	7803	7804	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.409194	0.425196	0.052578	0.032766	0.44958	1.0	0.03;
rotPanelZone2D	48800	8803	8804	[expr $Es*	1.909	]         [expr $Fy_column*	1.892	]	0.356108	0.368808	0.018034	0.011176	0.44958	1.0	0.03;
rotPanelZone2D	49800	9803	9804	[expr $Es*	1.909	]         [expr $Fy_column*	1.892	]	0.356108	0.368808	0.018034	0.011176	0.44958	1.0	0.03;
rotPanelZone2D	410800	10803	10804	[expr $Es*	1.909	]         [expr $Fy_column*	1.892	]	0.356108	0.368808	0.018034	0.011176	0.44958	1.0	0.03;
rotPanelZone2D	411800	11803	11804	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.363474	0.257302	0.021717	0.012954	0.44958	1.0	0.03;
rotPanelZone2D	412800	12803	12804	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.409194	0.425196	0.052578	0.032766	0.44958	1.0	0.03;
															
rotPanelZone2D	41900	1903	1904		$Es		$Fy_column		0.407416	0.403606	0.043688	0.027178	0.678434	1.0	0.03;
rotPanelZone2D	42900	2903	2904		$Es		$Fy_column		0.416052	0.406273	0.048006	0.029845	0.678434	1.0	0.03;
rotPanelZone2D	43900	3903	3904		$Es		$Fy_column		0.416052	0.406273	0.048006	0.029845	0.678434	1.0	0.03;
rotPanelZone2D	44900	4903	4904		$Es		$Fy_column		0.416052	0.406273	0.048006	0.029845	0.678434	1.0	0.03;
rotPanelZone2D	45900	5903	5904		$Es		$Fy_column		0.416052	0.406273	0.048006	0.029845	0.678434	1.0	0.03;
rotPanelZone2D	46900	6903	6904		$Es		$Fy_column		0.403606	0.407416	0.043688	0.027178	0.678434	1.0	0.03;
rotPanelZone2D	47900	7903	7904	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.406273	0.416052	0.048006	0.029845	0.44958	1.0	0.03;
rotPanelZone2D	48900	8903	8904	[expr $Es*	1.788	]         [expr $Fy_column*	1.769	]	0.356108	0.368808	0.018034	0.009525	0.44958	1.0	0.03;
rotPanelZone2D	49900	9903	9904	[expr $Es*	1.788	]         [expr $Fy_column*	1.769	]	0.356108	0.368808	0.018034	0.009525	0.44958	1.0	0.03;
rotPanelZone2D	410900	10903	10904	[expr $Es*	1.788	]         [expr $Fy_column*	1.769	]	0.356108	0.368808	0.018034	0.009525	0.44958	1.0	0.03;
rotPanelZone2D	411900	11903	11904	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.350266	0.203962	0.015113	0.008636	0.44958	1.0	0.03;
rotPanelZone2D	412900	12903	12904	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.406273	0.416052	0.048006	0.029845	0.44958	1.0	0.03;
															
rotPanelZone2D	4110000	     110003	 110004		$Es		$Fy_column		0.407416	0.403606	0.043688	0.027178	0.602742	1.0	0.03;
rotPanelZone2D	4210000	     210003	 210004		$Es		$Fy_column		0.416052	0.406273	0.048006	0.029845	0.602742	1.0	0.03;
rotPanelZone2D	4310000	     310003	 310004		$Es		$Fy_column		0.416052	0.406273	0.048006	0.029845	0.602742	1.0	0.03;
rotPanelZone2D	4410000	     410003	 410004		$Es		$Fy_column		0.416052	0.406273	0.048006	0.029845	0.602742	1.0	0.03;
rotPanelZone2D	4510000	     510003	 510004		$Es		$Fy_column		0.416052	0.406273	0.048006	0.029845	0.602742	1.0	0.03;
rotPanelZone2D	4610000	     610003	 610004		$Es		$Fy_column		0.403606	0.407416	0.043688	0.027178	0.602742	1.0	0.03;
rotPanelZone2D	4710000	     710003	 710004	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.406273	0.416052	0.048006	0.029845	0.398526	1.0	0.03;
rotPanelZone2D	4810000	     810003	 810004	[expr $Es*	1.788	]         [expr $Fy_column*	1.769	]	0.356108	0.368808	0.018034	0.009525	0.398526	1.0	0.03;
rotPanelZone2D	4910000	     910003	 910004	[expr $Es*	1.788	]         [expr $Fy_column*	1.769	]	0.356108	0.368808	0.018034	0.009525	0.398526	1.0	0.03;
rotPanelZone2D	41010000	1010003	1010004	[expr $Es*	1.788	]         [expr $Fy_column*	1.769	]	0.356108	0.368808	0.018034	0.009525	0.398526	1.0	0.03;
rotPanelZone2D	41110000	1110003	1110004	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.350266	0.203962	0.015113	0.008636	0.398526	1.0	0.03;
rotPanelZone2D	41210000	1210003	1210004	[expr $Es*	2.000	]         [expr $Fy_column*	2.000	]	0.406273	0.416052	0.048006	0.029845	0.398526	1.0	0.03;

