
(define-object cutting-fin-x-foil (base-object)

:input-slots
(

fin-root-center

fin-c-root
fin-c-tip 

fin-sweep 
fin-span

fin-thickness

xfoil-fin-spanwisely

loft-fin
  
fuselage_radius
tail-type
tail-semi-span
tail-dihedral
tail-sweep

)

	:computed-slots
(

;P a r t  1:

;creating auxiliary intersection chordwisely:

;leading edge, root profile:
	(Pt_LE_xfoil_F_0 (translate (the fin-root-center)
						:front (/ (the fin-c-root) 2)
					 )
	)
	
;somewhere down the span <- where exactly - depends directly on the user: see xfoil-spanwisely variable:
	(Pt_front_xfoil_F_0 (translate (the Pt_LE_xfoil_F_0)
							:top   (* (the fin-span) (the xfoil-fin-spanwisely) )										;vertically
						)
	)

;somewhere down the span + translated rear (for example by the length of the root chord and sweep dist. to make sure it is enough) to make a line for surface:
	(Pt_rear_xfoil_F_0 	(translate (the Pt_front_xfoil_F_0)
								:rear (+ (the fin-c-root) (* (the fin-span) (the xfoil-fin-spanwisely) (tan (* (/ pi 180) (the fin-sweep)))) )
						)
	)
	
;looking at the aircraft from the right and having the nose fuselage pointed tot he left we have the following nomenclature:

;point A front up:
	(Point_A_front_F_up (translate (the Pt_front_xfoil_F_0)
						:right (* 6 (the fin-thickness))
					  )
	)

;point A front low:
	(Point_A_front_F_low (translate (the Pt_front_xfoil_F_0)
						:left (* 6 (the fin-thickness))
					   )
	)

;point A rear up:
	(Point_A_rear_F_up (translate (the Pt_rear_xfoil_F_0)
						:right (* 6 (the fin-thickness))
					  )
	)

;point A rear low:
	(Point_A_rear_F_low (translate (the Pt_rear_xfoil_F_0)
						:left (* 6 (the fin-thickness))
					  )
	)	



  
(Point_front_xfoil_F_0 
	
	
	(if (or (eql (the tail-type) 0) (eql (the tail-type) 1) (eql (the tail-type) 2))
	
		(translate (the Pt_LE_xfoil_F_0)
							
							:top   (* (the fin-span) (the xfoil-fin-spanwisely) )													;spanwisely
							:rear  (* (the fin-span) (the xfoil-fin-spanwisely) (tan (* (/ pi 180) (the fin-sweep))) )				;longitudinally
		)
		(if (eql (the tail-type) 4)
			(translate (the Pt_LE_xfoil_F_0)
							
							:top   (+ (* 0.5 (the fin-span) (the xfoil-fin-spanwisely) ) (* (the tail-semi-span) 1.0 (sin (* (/ pi 180) (the tail-dihedral)))) )											;spanwisely
							:rear  (+ (* (the fin-span) (the xfoil-fin-spanwisely) (tan (* (/ pi 180) (the fin-sweep))) ) (* (the tail-semi-span) 1.0 (tan (* (/ pi 180) (the tail-sweep))) ) )		;longitudinally
			)
			(if (eql (the tail-type) 5)
				(translate (the Pt_LE_xfoil_F_0)
							
							:top   (+ (* 0.20 (the fin-span) (the xfoil-fin-spanwisely) ) (* (the tail-semi-span) 1.0 (sin (* (/ pi 180) (the tail-dihedral)))) )											;spanwisely
							:rear  (+ (* (the fin-span) (the xfoil-fin-spanwisely) (tan (* (/ pi 180) (the fin-sweep))) ) (* (the tail-semi-span) 1.0 (tan (* (/ pi 180) (the tail-sweep))) ) )		;longitudinally
				)
				(translate (the Pt_LE_xfoil_F_0)
							
							:top   (* (the fin-span) (the xfoil-fin-spanwisely) )													;spanwisely
							:rear  (* (the fin-span) (the xfoil-fin-spanwisely) (tan (* (/ pi 180) (the fin-sweep))) )				;longitudinally
				)
			)
		)
	)
)	
  
;convention: y, x, z:
(rotation_vector_F  (make-vector
	(* -2.5 (get-y (the fin-root-center)) )																												; y - spanwise direction
	(+ (- (get-y (the fin-root-center)) (/ (the fin-c-root) 2) ) (* (the fin-span) (the xfoil-fin-spanwisely) (tan (* (/ pi 180) (the fin-sweep) )) ))	; x - rear direction
	(+ (* (the fin-span) (the xfoil-fin-spanwisely) ) (* 1 (the fuselage_radius)) )																		; z - verical direction
					)
)
  
 
  
  
;the flow is likely to deflect more in the outboard part of the wing, the "xfoil-spanwisely" can vary between 0 and 1.00:
  (flow_deflection_factor_Fin
							(if (<= (the xfoil-fin-spanwisely) 0.25)
								0.45
								(if (and (> (the xfoil-fin-spanwisely) 0.25) (<= (the xfoil-fin-spanwisely) 0.50) )
									0.55
									(if (and (> (the xfoil-fin-spanwisely) 0.50) (<= (the xfoil-fin-spanwisely) 0.75) )
										0.65
										(when (and (> (the xfoil-fin-spanwisely) 0.75) (<= (the xfoil-fin-spanwisely) 1.0) )
											0.75
										)
									)
								)
							)
	)

	
	
;points obtained from the resulting intersection:	
(xfoil_fin_3D_points-1
						(the planar-section-curve-for-fin    control-points-local) 
)


(xfoil_fin_3D_points-2 (mapcar #'(lambda (x)
										(rotate-vector 	
														x
														(* -1 (the flow_deflection_factor_Fin) (/ pi 180) (the fin-sweep)) 
														(the (face-normal-vector :top))
										) 
								)
								(the xfoil_fin_3D_points-1)
				    )
)
	
(xfoil_fin_3D_points (mapcar #'(lambda (x)
										(rotate-vector-d 	
														x
														-25 								;just for the direction purpose
														(the (face-normal-vector :top))
										) 
								)
								(the xfoil_fin_3D_points-2)
				    )
)


;(the xfoil-wing-cutting planar-section-curve-for-wing control-points-local)
	
;end of computed-slots:	
)	

	
	:objects
(
	
;upper line:
(line_Point_A_front_F_up_Point_A_rear_F_up
					:type 'b-spline-curve
					
					:hidden? t
					
					:display-controls (list :color :silver 
											:transparency 0.5
											:line-thickness 0.1)
					:control-points (list (the Point_A_front_F_up) 
										  (the Point_A_rear_F_up))
					:degree 1)

;lower line:
(line_Point_A_front_F_low_Point_A_rear_F_low
					:type 'b-spline-curve
					
					:hidden? t
					
					:display-controls (list :color :silver 
											:transparency 0.5
											:line-thickness 0.1)
					:control-points (list (the Point_A_front_F_low) 
										  (the Point_A_rear_F_low))
					:degree 1)

					
	
;Lofted surface:
(surf_xfoil_fin
	:type 'lofted-surface
	
	:hidden? t
	
	:end-caps-on-brep? t
	:display-controls (list :color :grey 
							:transparency 0.10
							:line-thickness 0.5) 
	:curves (list (the line_Point_A_front_F_low_Point_A_rear_F_low) 
				  (the line_Point_A_front_F_up_Point_A_rear_F_up)))



;intersection:
	(planar-section-curve-for-fin
	
			:type 'planar-section-curve
  
			:surface  (the loft-fin)
						 
            :plane-normal (rotate-vector 
										(the (face-normal-vector :bottom))									;normal vector of the surface
										(* (the flow_deflection_factor_Fin) (/ pi 180) (the fin-sweep))		;rotation angle in [rad] -> boils down to sweep
										(the rotation_vector_F)												;vector around which the rotation takes place
						  )
										
            :plane-point (the Point_front_xfoil_F_0)													;leading edge - depending on the "xfoil-spanwisely" 
						 
            :display-controls (list :color :purple 
									:line-thickness 1.5)
	) 
	
	
	
	
		    (plane-point-test1 	:type 'sphere
			
							:hidden? t
		
							:radius 0.2
		
							:center (the Point_front_xfoil_F_0)
							:number-of-vertical-sections 90
							:number-of-horizontal-sections 90
							
							:display-controls (list :color :red)
			)
	
		    (plane-point-test2 	:type 'sphere
		
							:hidden? t
		
							:radius 0.2
		
							:center (the rotation_vector_F)
							:number-of-vertical-sections 90
							:number-of-horizontal-sections 90
							
							:display-controls (list :color :green)
			)	
	
	
	
)


;end of define-object:
)
