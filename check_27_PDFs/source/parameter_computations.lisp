(in-package :gdl-user)

(define-object parameter-computation (base-object)

:input-slots
(

	tail-sweep
	MAC_HT_distance_from_center
	MAC_HT

	fuselage_diameter
	total-tail-span
	S-h
	l-h
	tail-ar

	tail-type

	fin-span
	fin-ar
	fin-thickness
	fin-c-root
	fin-sweep
	MAC_VT
	MAC_VT_distance_from_center
	S-v
	l-v
	
;reference areas:
	total_wing_surface
	semi-span
	fuselage_radius
	thickness
	c-MAC
	tail-thickness
	c-root
	sweep
	
	total-span
	tail-c-root
	MAC_distance_from_root

	W_dg_lb	
	Mach
	altitude
	
	tail-root-center
	root-center
	
	tail-dihedral
	
	taper
	slenderness_ratio_nose
	fuselage_cylinder_length
	wing_position
	
;nacelles:
	engine_number
	engine_length
	3_rd_engine
	engine_diameter
	engines_podded_0_mounted_1
	
;jet stream:
	Thrust_lb
	dihedral
	boolean_top_or_bottom_wing
	
	aircraft_speed
	sound_speed
	
;forgotten:
	cruciform
	
 )

:computed-slots
(

;limit load factor: (a value between -1.52 and 3.80 [-])
	(limit_load_factor 2.0)

; 1) Tailplane weights - class II estimation method (note that eq. in Raymer refer to pounds, not kg):
;--------------------------------------------------------------------------------------------------------------------------------------------------

;Converting units from SI to IMPERIAL system:

	(fuselage_diameter_ft 	(* 3.2808 (the fuselage_diameter)))
	(total-tail-span_ft 	(* 3.2808 (the total-tail-span)))
	
	(l-h_ft 				(* 3.2808 (the l-h)))
	(S-h_ft 				(* (expt 3.28 2) (the S-h)))

	(S_elev_ft 				(* (expt 3.2808 2) (the S_elev)))


;constants for the equation for the HT weight:

;tail might be other than 'all-moving':
(K_uht 1)

;fuselage width at the intesection width HT:
(F_w (* 0.25 (the fuselage_diameter_ft)) )

;ultimate load factor:
(ultimate_load_factor (* 1.5 (the limit_load_factor) ))

;pitching radius of gyration:
(K_y (* 0.3 (the l-h_ft)) )

;elevator surface as 1/3 od the HT surface:
(S_elev (* 0.3333 (the S-h)))



;tail sweep in DEGREES at 25% of the MAC:
(tail-sweep_025_deg (* (/ 180 pi) 
			   (atan (+ (tan (* (/ pi 180) (the tail-sweep)))
						(/ (* 0.25 (the MAC_HT)) (the MAC_HT_distance_from_center) )
					 )
				)
		    )
)
;tail sweep in RADIANS at 25% of the MAC:
(tail-sweep_025_rad (atan (+ (tan (* (/ pi 180) (the tail-sweep)))
						(/ (* 0.25 (the MAC_HT)) (the MAC_HT_distance_from_center) )
					 )
				)	   
)



;horizontal tail weight in lb:

   (HT_weight_lb (* 0.0379
						(the K_uht)
						(expt (+ 1 (/ (the F_w) (the total-tail-span_ft))) -0.25)
						(expt (the W_dg_lb) 0.639)
						(expt (the ultimate_load_factor) 0.10) 
						(expt (the S-h_ft) 0.75) 
						(expt (the l-h_ft) -1) 
						(expt (the K_y) 0.704)
						(expt (cos (the tail-sweep_025_rad)) -1) 
						(expt (the tail-ar) 0.166) 
						(expt (+ 1 (/ (the S_elev_ft) (the S-h_ft))) 0.1)
				 )
	)

;horizontal tail weight in kg:
	(HT_weight_kg (* 0.454 (the HT_weight_lb) ) )



;VERTICAL TAIL:

;0 conventional
;1 T - tail
;2 cruciform
;3 V - tail

;4 C - tail
;5 H - tail	


;convesrions:
	(l-v_ft 				(* 3.2808 (the l-v)))
	(S-v_ft 				(* (expt 3.2808 2) (the S-v)))	
	

;the height of the horizontal tail above the fuselage depends on the tail configuration:
(HT_ver_pos
			(ecase (the tail-type)
			
				(0 0)
				(1    (the fin-span))
				(2 (* (the fin-span) (the cruciform) ))
				(3 0) ;actually not necessary - the fin weight is not calculated for V-tail
				(4 0)
				(5 0)
			)
)

;fin sweep in DEGREES at 25% of the MAC:
(fin-sweep_025_deg 	(* (/ 180 pi) 
				  (atan (+ (tan (* (/ pi 180) (the fin-sweep)))
						(/ (* 0.25 (the MAC_VT)) (the MAC_VT_distance_from_center) )
					 )
				  )
				)
)
;fin sweep in RADIANS at 25% of the MAC:
(fin-sweep_025_rad (atan (+ (tan (* (/ pi 180) (the fin-sweep)))
						    (/ (* 0.25 (the MAC_VT)) (the MAC_VT_distance_from_center) )
					     )
				   )	   
)
	
;Therefore, for V-tail fin should be skipped:
	(VT_weight_lb 
					(if (eql (the tail-type) 3) 
			 
						0 																;V-tail case
		     
						(* 0.0026 														;Otherwise
							(expt (+ 1 (/ (the HT_ver_pos) (the fin-span)) ) 0.225) 
							(expt (the W_dg_lb) 0.556)
							(expt (the ultimate_load_factor) 0.536) 
							(expt (the S-v_ft) 0.5) 
							(expt (the l-v_ft) -0.5) 
							(expt (the l-v_ft) 0.875) 
							(expt (the fin-ar) 0.35) 
							(expt (cos (the fin-sweep_025_rad)) -1)
							(expt (/ (the fin-thickness) (the fin-c-root)) -0.5))
					)
	)	
	
;horizontal tail weight in kg:
	(VT_weight_kg (* 0.454 (the VT_weight_lb) ) )



; 2) The reference area, the exposed area and the wetted area of the wing and tailpanes using the generated 3D models:
;--------------------------------------------------------------------------------------------------------------------------------------------------

; WING

;Reference area
	(S_ref_wing (the total_wing_surface))

;the reference area inside the fuselage
(inside_y (* (the fuselage_radius) (tan (* (/ pi 180) (the sweep) )) ))

	(S_inside_wing (* (- (* 2 (the c-root)) 
					     (the inside_y)
				      )
				      (the fuselage_radius)
				   )
	)
	
;exposed area
	(S_exp_wing (- (the S_ref_wing) 
				   (the S_inside_wing)
				)
	)
	
;wetted area - equation from adg.stanford.edu:
	(S_wetted_wing (* 2.0 
					 (+ 1 (* 0.2 (/ (the thickness) (the c-MAC))))
					 (the S_exp_wing)   
				   )
	) 


; HORIZONAL TAIL

;Reference area
	(S_ref_HT (the S-h))

;the reference area inside the fuselage
(inside_y_ht (* (/ (the fuselage_radius) 4) (tan (* (/ pi 180) (the tail-sweep) )) ))

	(S_inside_HT (* (- (* 2 (the tail-c-root)) 
					   (the inside_y_ht)
					)
					(* 0.25 (the fuselage_radius))
			  )
	)
	
;exposed area
	(S_exp_HT (- (the S_ref_HT) 
			  (the S_inside_HT)
		   )
	)
	
;wetted area
	(S_wetted_HT (* 2.0 
					(+ 1 (* 0.2 (/ (the tail-thickness) (the MAC_HT))))
					(the S_exp_HT)   
				 )
	)

	
;VERTICAL TAIL

;reference area
	(S_ref_VT (the S-v))
		   
;exposed area
   (S_exp_VT (the S_ref_VT))

;wetted area
	(S_wetted_VT (* 2.0
					(+ 1 (* 0.2 (/ (the fin-thickness) (the MAC_VT))) )
					(the S_exp_VT) 
				 )
	)



; 3) Lift gradients at cruise conditions for CL_alpha_w (wing), CL_alpha_wf (wing + fuselage) and CL_alpha_h (horizontal tail)
;--------------------------------------------------------------------------------------------------------------------------------------------------

; W I N G

;wing sweep in DEGREES at 50% of the MAC:
(wing-sweep_050_deg (* (/ 180 pi) 
				   (atan (+ (tan (* (/ pi 180) (the sweep)))
						    (/ (* 0.50 (the c-MAC)) (the MAC_distance_from_root) )
					     )
				   )
				)
)
;wing sweep in RADIANS at 50% of the MAC:
(wing-sweep_050_rad (atan (+ (tan (* (/ pi 180) (the sweep)))
						     (/ (* 0.50 (the c-MAC)) (the MAC_distance_from_root) )
					      )
					)	   
)

;Prandtl-Glauert compressibility factor for the wing
	(beta_wing (if (< (the Mach) 1.0)
					(sqrt (- 1 
							(expt (the Mach) 2)
						  )
					)
					(sqrt (- (expt (the Mach) 2) 
							  1
						  )
					)
				)
	) 

;airfoil efficiency factor
	(etha 0.95)

;aspect ratio of the wing: (AR=b^2/S)

(AR (/ (expt (the total-span) 2)
	   (the total_wing_surface)
	)
)
	
	
;lift gradient for the wing in [1/rad]				
	(cl-alpha_wing_rad ( / (* 2 pi (the AR)) 
						   (+ 2 
					         (sqrt (+ 4 
							          (* (expt (/ (* (the AR)(the beta_wing)) 
												  (the etha) ) 2) 
							             (+ 1 (/ (expt (tan (the wing-sweep_050_rad)) 2) 
								                 (expt (the beta_wing) 2)
											  )
										 )
									  )
									)
							  )
							)
					   )
	)
	
	
;lift gradient for the wing in [1/deg]
	(cl-alpha_wing_deg (* (/ pi 180) 
						  (the cl-alpha_wing_rad)
					   )
	)
	

; H O R I Z O N T A L   T A I L 


;due to the presence of the fuselage, the tail_wing_speed_ratio can be determined:
	(tail_wing_speed_ratio 
				(ecase (the tail-type) 
				
					(0 0.85) ;fuselage-mounted
					(1 1.00) ;T-tail
					(2 0.95) ;cruciform
					(3 0.85) ;fuselage-mounted - V-tail
					(4 0.85) ;fuselage-mounted - C-tail
					(5 0.85) ;fuselage-mounted - H-tail
				)
	)

;the speed seen by the tail including fuselage perturbance:
(tail_speed (* (sqrt (the tail_wing_speed_ratio)) 
			   (the aircraft_speed)))
			   
;the tail Mach number:
(Mach_tail (/ (the tail_speed)
			  (the sound_speed)
		   )
)

;Prndtl-Glauert compressibility factor for the tail
	(beta_tail (if (< (the Mach) 1.0)
					(sqrt (- 1 
							(expt (the Mach_tail) 2)
						  )
					)
					(sqrt (- (expt (the Mach_tail) 2) 
							  1
						  )
					)
				)
	)  

;due to fins in C and H tail -> AR of HT can be increased by 1.5 for these cases (cases: 4 and 5):
(tail-ar_CL 
		(ecase (the tail-type)
		
				(0 (the tail-ar)) 
				(1 (the tail-ar)) 
				(2 (the tail-ar)) 
				(3 (the tail-ar))
				(4 (* 1.5 (the tail-ar))) 
				(5 (* 1.5 (the tail-ar))) 
		)
)


;tail sweep in DEGREES at 50% of the MAC:
(tail-sweep_050_deg (* (/ 180 pi) 
			   (atan (+ (tan (* (/ pi 180) (the tail-sweep)))
						(/ (* 0.50 (the MAC_HT)) (the MAC_HT_distance_from_center) )
					 )
				)
		    )
)
;tail sweep in RADIANS at 50% of the MAC:
(tail-sweep_050_rad (atan (+ (tan (* (/ pi 180) (the tail-sweep)))
						(/ (* 0.50 (the MAC_HT)) (the MAC_HT_distance_from_center) )
					 )
				)	   
)
	
;lift gradient for the tail in [1/rad]
	(cl-alpha_tail_rad ( / (* 2 pi (the tail-ar_CL)) 
						   (+ 2 
					         (sqrt (+ 4 
							          (* (expt (/ (* (the tail-ar_CL)(the beta_tail)) 
												  (the etha) ) 2) 
							             (+ 1 (/ (expt (tan (the tail-sweep_050_rad)) 2) 
								                 (expt (the beta_tail) 2)
											  )
										 )
									  )
									)
							  )
							)
					   )
	)

;lift gradient for the tail in [1/deg]								  
	(cl-alpha_tail_deg (* (/ pi 180) 
						  (the cl-alpha_tail_rad)
					   )
	)

	
	
; F U S E L A G E   A N D   W I N G

;lift gradient for the fuselage wing combination (complete aircraft) in [1/rad]
(cl-alpha_wing_plus_fuselage_rad (+ (* (the cl-alpha_wing_rad)
								   (+ 1 (* 2.15 (/ (the fuselage_diameter)
												   (the total-span) )))
								   (/ (the S_exp_wing) (the total_wing_surface)))
								(* (/ pi 2) (/ (expt (the fuselage_diameter) 2) 
											   (the total_wing_surface)))))
											   
;lift gradient for the fuselage wing combination (complete aircraft) in [1/rad]
(cl-alpha_wing_plus_fuselage_deg (* (/ pi 180) 
								(the cl-alpha_wing_plus_fuselage_rad)
							 )
)




; 4) W I N G   D O W N W A S H   G R A D I E N T   O N   T H E   T A I L

;see slide 27 - material package:

;parameter r:
   (r (/ (* 2 (the l-h))
		 (the total-span)
	  )
	)

	
;wing sweep in [rad] (the the leading edge as it is not stated differently in the instruction):
	(wing-sweep_rad (* (the sweep) (/ pi 180)) )
	
;parameter k-epsilon:
	(k-e (+ 2 
			(/ 0.1024 (the r))
			(/ (+ 0.1124 
				  (* 0.1265 (the wing-sweep_rad)) 				;careful which sweep ! ! !
				  (* 0.1766 (expt (the wing-sweep_rad) 2))) 	;careful which sweep ! ! !
			   (expt (the r) 2)
			)
		)
	)
	
	
;parameter k-e-0
    (k-e_0 (+ 2 
			  (/ 0.1024 (the r))
			  (/ 0.1124 (expt (the r) 2))
		   )
	)
	

;auxiliary value for m_tv accounting for the vertical distance between wing-root and tail-MAC including the dihedral angle: 
(dist_shed_plane (abs (- (get-z (the root-center))				 
						 (+ (get-z (the tail-root-center))
						    (* (the MAC_HT_distance_from_center) (sin (* (/ pi 180) (the tail-dihedral))))
						 )
					  )
				 )
)

;parameter m_tv
   (m_tv (/ (* 2 (the dist_shed_plane)) 
		 (the total-span)))

	
;downwash gradient [1/rad]:
	(downwash_grad (* (/ (the k-e) 
						 (the k-e_0)
					  )
					  
					  (/ (the cl-alpha_wing_rad) 
						 (* pi (the AR))
					  ) 
					  
					  (+ (* (/ (the r) 
							   (+ (expt (the r) 2) 
								  (expt (the m_tv) 2)
							   )
							) 
							
							(/ 0.4876 
								(sqrt (+ 0.6319 
								  	     (expt (the r) 2) 
										 (expt (the m_tv) 2)
									  )
								)
							)
						 )
				   
						 (* (+ 1 
							   ( expt(/ (expt (the r) 2) 
										(+ 0.7915 
										   (expt (the r) 2)
										   (* 5.0734 (expt (the m_tv) 2))))
								 0.3113)
							) 
				      
					  (- 1 
						 (sqrt (/ (expt (the m_tv) 2) 
								  (+ 1 (expt (the m_tv) 2))
							   )
						  )
					  )
					  )
					  )
					)
	)
	

; 5) The tail-less aircraft (aerodynamic center of the whole aircraft without the tail contribution) aerodynamic center Xac at cruise condition
;    including the contribution of wing, fuselage, nacelles and jet stream. The position of the aerodynamic center of the wing can be 
;	 assumed at 0.25 MAC for simplicity. 


; W I N G   a e r o d y n a m i c   c e n t e r
	(X_AC_wing 0.25)

		   
; W I N G   and   F U S E L A G E   contribution:
		   
;distance from the nose of the airplane (the foremost part of the fuselage) to the wing's leading edge at the root section - near the fuselage:
		   (l_fn (+ (* (the fuselage_diameter) (the slenderness_ratio_nose))
					(+ (* 0.5  (the fuselage_cylinder_length))				     		      
					   (* (the fuselage_radius) (tan (* (/ pi 180) (the sweep))))
					   (* -1 (the wing_position))	
					)
				 )
			)
	
;geometric chord of the wing:
(geometric_chord (/ (the total_wing_surface) (the total-span)))


;wing sweep in RADIANS at 25% of the MAC:
(wing-sweep_025_rad (atan (+ (tan (* (/ pi 180) (the sweep)))
						     (/ (* 0.25 (the c-MAC)) (the MAC_distance_from_root) )
					      )
					)	   
)

;the resulting wing-fuselage contribution:				
(X_AC_wing_fuselage (- (+ (the X_AC_wing) 
				 
				  (/ (* 0.273 
				        (the fuselage_diameter) 
				        (the geometric_chord)
				        (- (the total-span) (the fuselage_diameter)) 
				        (tan (the wing-sweep_025_rad))) 
				     (* (+ 1 
						   (the taper)
						)
						(expt (the c-MAC) 2) 
				        (+ (the total-span) 
						   (* 2.15 (the fuselage_diameter))
						)
					 )
				  )
					  
			   ) 
			   (/ (* 1.8 
				    (the fuselage_diameter) 
				    (the fuselage_diameter) 
				    (the l_fn)) 
				  
				  (* (the cl-alpha_wing_plus_fuselage_rad) 
				     (the total_wing_surface) 
				     (the c-MAC)
				  )
				)
			)
	)


; N A C E L L E S

;for nacelles mounted in front of the LE or in the fuselage nose 	-> k_n =~ -4.0
;for nacelles mounted to the sides of the rear fuselage			 	-> k_n =~ -2.5
	
;k_n factor:	
	(k_n (ecase 
			(the engines_podded_0_mounted_1) 
	
				(0 -4) 
				(1 -2.5)
		 )
	)

;longitudinal translation of the engines that are PODDED to the  wings (2, 3 or 4) - (for 3 engines podded are 2 and the 3rd will be considered later):
;inboard:
	(eng_long_1
	  (+ (- (+ (/ (the c-root) 2.5) (the wing_position)) (* (tan (* (the sweep) (/ pi 180)))	  
	  ;spanwise translation:
	  (* (the semi-span) (* (/ 1 (+ 5 (/ (the engine_number) 2))) 2) ) )) (/ (the engine_length) 2) ) )
;outboard:
	(eng_long_2
	  (+ (- (+ (/ (the c-root) 2.5) (the wing_position)) (* (tan (* (the sweep) (/ pi 180)))	  
	  ;spanwise translation:
	  (* (the semi-span) (* (/ 1 (+ 5 (/ (the engine_number) 2))) 4) ) )) (/ (the engine_length) 2) ) )

;2 engines podded -- the arm for the inboard ones:  
	(ln_2_podded
					(if (> (the eng_long_1) 0)
						(the eng_long_1)
						(- (the eng_long_1) (the engine_length))
					)
	)
;4 engines podded - the arm for the outborad ones:
	(ln_4_podded
					(if (> (the eng_long_2) 0)
						(the eng_long_2)
						(- (the eng_long_2) (the engine_length))
					)
	)

;3rd engine - PODDED - the distance from the 25%MAC to the 3rd engine's end:
	(ln_3rd_podded (* -1 (+ (the 3_rd_engine) (/ (the engine_length) 2) ) ))

	
	
;X-AC-shift for P O D D E D:

;2 engines podded:
(X_AC_2_podded
	(/ (* 2
			(the k_n) 
			(the ln_2_podded) 
			(expt (the engine_diameter) 2))
		(* (the total_wing_surface)
			(the c-MAC)
			(the cl-alpha_wing_plus_fuselage_rad)
		)
	)
)

;3 engines podded:
(X_AC_3_podded
 (+ (/ (* 2
			(the k_n) 
			(the ln_2_podded) 
			(expt (the engine_diameter) 2))
		(* (the total_wing_surface)
			(the c-MAC)
			(the cl-alpha_wing_plus_fuselage_rad)
		)
	)

	(/ (* 1
			(the k_n) 
			(the ln_3rd_podded) 
			(expt (the engine_diameter) 2))
		(* (the total_wing_surface)
			(the c-MAC)
			(the cl-alpha_wing_plus_fuselage_rad)
		)
	)
 )		
)

;4 engines podded:
(X_AC_4_podded
 (+ (/ (* 2
			(the k_n) 
			(the ln_2_podded) 
			(expt (the engine_diameter) 2))
		(* (the total_wing_surface)
			(the c-MAC)
			(the cl-alpha_wing_plus_fuselage_rad)
		)
	)

	(/ (* 2
			(the k_n) 
			(the ln_4_podded) 
			(expt (the engine_diameter) 2))
		(* (the total_wing_surface)
			(the c-MAC)
			(the cl-alpha_wing_plus_fuselage_rad)
		)
	)
 )		
)


;X-AC-shift for M O U N T E D:

(ln_2_4_mount (* -1 (- (+ (* 0.50 (the fuselage_cylinder_length) ) (/ (the engine_length) 2) )               (* 0.1 (the fuselage_cylinder_length)) ) ))
(ln_3rd_mount (* -1 (- (+ (- (the 3_rd_engine) (* 1.30 (the engine_length)) ) (/ (the engine_length) 2) )    (* 0.1 (the fuselage_cylinder_length)) ) ))

;2 engines mounted:
(X_AC_2_mounted
	(/ (* 2
			(the k_n) 
			(the ln_2_4_mount) 
			(expt (the engine_diameter) 2))
		(* (the total_wing_surface)
			(the c-MAC)
			(the cl-alpha_wing_plus_fuselage_rad)
		)
	)
)

;3 engines mounted:
(X_AC_3_mounted
 (+ (/ (* 2
			(the k_n) 
			(the ln_2_4_mount) 
			(expt (the engine_diameter) 2))
		(* (the total_wing_surface)
			(the c-MAC)
			(the cl-alpha_wing_plus_fuselage_rad)
		)
	)

	(/ (* 1
			(the k_n) 
			(the ln_3rd_mount) 
			(expt (the engine_diameter) 2))
		(* (the total_wing_surface)
			(the c-MAC)
			(the cl-alpha_wing_plus_fuselage_rad)
		)
	)
 )		
)

;4 engines mounted:
(X_AC_4_mounted
	(/ (* 4
			(the k_n) 
			(the ln_2_4_mount) 
			(expt (the engine_diameter) 2))
		(* (the total_wing_surface)
			(the c-MAC)
			(the cl-alpha_wing_plus_fuselage_rad)
		)
	)
)

;FINALLY for nacelles we have:

(X_AC_nacelles (if (eql (the engines_podded_0_mounted_1) 0)

;PODDED cases:
					(if (eql (the engine_number) 2)
						(the X_AC_2_podded)
						(if (eql (the engine_number) 3)
							(the X_AC_3_podded)
							(the X_AC_4_podded)
						)
					)
;MOUNTED cases:
					(if (eql (the engine_number) 2)
						(the X_AC_2_mounted)
						(if (eql (the engine_number) 3)
							(the X_AC_3_mounted)
							(the X_AC_4_mounted)
						)
					)
			   )
)


;J E T   S T R E A M:

;thrust to weight ratio:
(thrust-to-weight (/ (the Thrust_lb) 
					 (the W_dg_lb)
				  )
)

;a constant parameter to simplify the calculation, namely thrust to weight divided by c-MAC:
(TW_over_c (/ (the thrust-to-weight) (the c-MAC)) )

;PODDED cases:

(span_engine_2
			(* (the semi-span) (* (/ 1 (+ 5 (/ (the engine_number) 2))) 2 ) ))

(span_engine_4
			(* (the semi-span) (* (/ 1 (+ 5 (/ (the engine_number) 2))) 4 ) ))



;2 engines podded:
(X_thrust_2_podded (* 2 (the TW_over_c) 
						(+ (* (sin (* (/ pi 180) (the dihedral))) (the span_engine_2) )
						   (* -1 (the boolean_top_or_bottom_wing) (* 0.60 (the fuselage_radius)))
						)
					)
)

;3 engines podded:
(X_thrust_3_podded 	(+	(* 2 (the TW_over_c) 
							(+ (* (sin (* (/ pi 180) (the dihedral))) (the span_engine_2) )
							   (* -1 (the boolean_top_or_bottom_wing) (* 0.60 (the fuselage_radius)))
							)
						)
						(* (the TW_over_c) (+ (the fuselage_radius) (/ (the engine_diameter) 1.0) ) )
					)
)

;4 engines podded:
(X_thrust_4_podded 	(+	(* 2 (the TW_over_c) 
							(+ (* (sin (* (/ pi 180) (the dihedral))) (the span_engine_2) )
							   (* -1 (the boolean_top_or_bottom_wing) (* 0.60 (the fuselage_radius)))
							)
						)
						(* 2 (the TW_over_c) 
							(+ (* (sin (* (/ pi 180) (the dihedral))) (the span_engine_4) )
							   (* -1 (the boolean_top_or_bottom_wing) (* 0.60 (the fuselage_radius)))
							)
						)
					)
)


;MOUNTED cases:

;2 engines mounted:
(X_thrust_2_mounted (* 2 (the TW_over_c) (/ (the fuselage_radius) 2)) )
	
;3 engines mounted:
(X_thrust_3_mounted (+ (* 2 (the TW_over_c) (/ (the fuselage_radius) 2)) 
					   (* 1 (the TW_over_c) (+ (the fuselage_radius) (/ (the engine_diameter) 1.5) ))
					)
)

;4 engines mounted:
(X_thrust_4_mounted (* 4 (the TW_over_c) (/ (the fuselage_radius) 2)) )	
	

	
	
;FINALLY for jet stream we have:

(X_AC_jet (if (eql (the engines_podded_0_mounted_1) 0)

;PODDED cases:
					(if (eql (the engine_number) 2)
						(the X_thrust_2_podded)
						(if (eql (the engine_number) 3)
							(the X_thrust_3_podded)
							(the X_thrust_4_podded)
						)
					)
;MOUNTED cases:
					(if (eql (the engine_number) 2)
						(the X_thrust_2_mounted)
						(if (eql (the engine_number) 3)
							(the X_thrust_3_mounted)
							(the X_thrust_4_mounted)
						)
					)
			   )
)	
	
	
	
;Tailess aircraft Xac - normalized with c-MAC - local system:	   
	(X_AC_normal (+ (the X_AC_wing_fuselage) 
					(the X_AC_nacelles) 
					(the X_AC_jet)))

;Tailles aircraft - without normalization:
	(Xac_un-normal (* (the X_AC_normal)
					  (the c-MAC)))

; Xac point in global coordinates
    (AC (make-point 0 (the Xac_un-normal) 0))	
	
	
; 6) The allowed most aft CG position which complies with the longitudinal static stability:

(Stat_Margin 0.05)

;Xcg - normalized with c-MAC - local system:
	(Xcg-normal (- (+ (the X_AC_normal) 
				     
					 (* (/  (the cl-alpha_tail_rad) 
							(the cl-alpha_wing_plus_fuselage_rad)) 
				        
						(- 1 (the downwash_grad)) 
						
						(/ (* (the S-h) 
							  (the l-h) 
							  (the tail_wing_speed_ratio))
							  
							(* (the total_wing_surface) 
							(the c-MAC)))))
				 
				   (the Stat_Margin) 
				)
	)

;Xcg - un-normalized with c-MAC - global system:
	(Xcg (- (+ (the Xac_un-normal) 
			   
			   (* (/ (the cl-alpha_tail_rad) 
				     (the cl-alpha_wing_plus_fuselage_rad)) 
				  
				  (- 1 (the downwash_grad)) 
				  
				  (/ (* (the S-h) 
				        (the l-h) 
				        (the tail_wing_speed_ratio))
						
				     (the total_wing_surface))))
			   
			   (* (the Stat_Margin) 
			      (the c-MAC)
			   )
		 )
	)



; Xcg point in global coordinates
   (CG (make-point 0 (the Xcg) 0))

	
	
;end of computed-slots:
)

  :objects 
(

;Center of gravity:
	    (CG_visualization 	:type 'sphere
							
							:radius (/ (the fuselage_diameter) 13)
							
							:center (the CG)
							:number-of-vertical-sections 30
							:number-of-horizontal-sections 30
							
							:display-controls (list :color :black)
		)

;Aerodynamic center:
	    (AC_visualization 	:type 'sphere
		
							:radius (/ (the fuselage_diameter) 13)
		
							:center (the AC)
							:number-of-vertical-sections 90
							:number-of-horizontal-sections 90
							
							:display-controls (list :color :red)
		)					
)

;end of define-object:
)