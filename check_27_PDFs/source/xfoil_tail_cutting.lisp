
(define-object cutting-tail-x-foil (base-object)

:input-slots
(

tail-root-center

tail-c-root
tail-c-tip 

tail-sweep 
tail-semi-span
tail-dihedral
tail-thickness

xfoil-tail-spanwisely

loft-tail

)

	:computed-slots
(

;P a r t  1:

;creating auxiliary intersection chordwisely:

;leading edge, root profile:
	(Pt_LE_xfoil_T_0 (translate (the tail-root-center)
						:front (/ (the tail-c-root) 2)
					 )
	)
	
;somewhere down the span <- where exactly - depends directly on the user: see xfoil-spanwisely variable:
	(Pt_front_xfoil_T_0 (translate (the Pt_LE_xfoil_T_0)
						:top   (* (the tail-semi-span) (the xfoil-tail-spanwisely) (sin (* (/ pi 180) (the tail-dihedral))))	;vertically
						:right (* (the tail-semi-span) (the xfoil-tail-spanwisely) (cos (* (/ pi 180) (the tail-dihedral))))	;spanwisely
					 )
	)

;somewhere down the span + translated rear (for example by the length of the root chord and sweep dist. to make sure it is enough) to make a line for surface:
	(Pt_rear_xfoil_T_0 	(translate (the Pt_front_xfoil_T_0)
								:rear (+ (the tail-c-root) (* (the tail-semi-span) (the xfoil-tail-spanwisely) (tan (* (/ pi 180) (the tail-sweep)))) )
							)
	)
	
;looking at the aircraft from the right and having the nose fuselage pointed tot he left we have the following nomenclature:

;point A front up:
	(Point_A_front_T_up (translate (the Pt_front_xfoil_T_0)
						:top (* 6 (the tail-thickness))
					  )
	)

;point A front low:
	(Point_A_front_T_low (translate (the Pt_front_xfoil_T_0)
						:bottom (* 6 (the tail-thickness))
					   )
	)

;point A rear up:
	(Point_A_rear_T_up (translate (the Pt_rear_xfoil_T_0)
						:top (* 6 (the tail-thickness))
					  )
	)

;point A rear low:
	(Point_A_rear_T_low (translate (the Pt_rear_xfoil_T_0)
						:bottom (* 6 (the tail-thickness))
					  )
	)	



  
 	(Point_front_xfoil_T_0 (translate (the Pt_LE_xfoil_T_0)
							
							:right (* (the tail-semi-span) (the xfoil-tail-spanwisely) (cos (* (/ pi 180) (the tail-dihedral))) )	;spanwisely
							:rear  (* (the tail-semi-span) (the xfoil-tail-spanwisely) (tan (* (/ pi 180) (the tail-sweep))) )		;longitudinally
							:top   (* (the tail-semi-span) (the xfoil-tail-spanwisely) (sin (* (/ pi 180) (the tail-dihedral))) )	;vertically
						 )
	) 
  
;convention: y, x, z:
  (rotation_vector_T  (make-vector
								(* (the tail-semi-span) (the xfoil-tail-spanwisely) (cos (* (/ pi 180) (the tail-dihedral))) )		; y - spanwise direction
								(* (the tail-semi-span) (the xfoil-tail-spanwisely) (tan (* (/ pi 180) (the tail-sweep   ))) )		; x - rear direction
								(* (the tail-semi-span) (the xfoil-tail-spanwisely) (sin (* (/ pi 180) (the tail-dihedral))) )		; z - verical direction
					)
  )
  
;the flow is likely to deflect more in the outboard part of the wing, the "xfoil-spanwisely" can vary between 0 and 1.00:
  (flow_deflection_factor_Tail
							(if (<= (the xfoil-tail-spanwisely) 0.25)
								1.00
								(if (and (> (the xfoil-tail-spanwisely) 0.25) (<= (the xfoil-tail-spanwisely) 0.50) )
									1.15
									(if (and (> (the xfoil-tail-spanwisely) 0.50) (<= (the xfoil-tail-spanwisely) 0.75) )
										1.25
										(when (and (> (the xfoil-tail-spanwisely) 0.75) (<= (the xfoil-tail-spanwisely) 1.0) )
											1.50
										)
									)
								)
							)
	)

	
	
;points obtained from the resulting intersection:	
(xfoil_tail_3D_points-1
					(the planar-section-curve-for-tail    control-points-local)
)

(xfoil_tail_3D_points-2 (mapcar #'(lambda (x)
										(rotate-vector 	
														x
														(* -1 (the flow_deflection_factor_Tail) (/ pi 180) (the tail-sweep)) 
														(the (face-normal-vector :top))
										) 
								)
								(the xfoil_tail_3D_points-1)
						)
)

(xfoil_tail_3D_points-3 (mapcar #'(lambda (x)
										(rotate-vector-d 	
														x
														55 											;trial and error thing
														(the (face-normal-vector :front))
										) 
								)
								(the xfoil_tail_3D_points-2)
						)
)

(xfoil_tail_3D_points (mapcar #'(lambda (x)
										(rotate-vector-d 	
														x
														-25 										;just for the direction purpose
														(the (face-normal-vector :top))
										) 
								)
								(the xfoil_tail_3D_points-3)
						)
)

	
;end of computed-slots:	
)	

	
	:objects
(
	
;upper line:
(line_Point_A_front_T_up_Point_A_rear_T_up
					:type 'b-spline-curve
					
					:hidden? t
					
					:display-controls (list :color :silver 
											:transparency 0.5
											:line-thickness 0.1)
					:control-points (list (the Point_A_front_T_up) 
										  (the Point_A_rear_T_up))
					:degree 1)

;lower line:
(line_Point_A_front_T_low_Point_A_rear_T_low
					:type 'b-spline-curve
					
					:hidden? t
					
					:display-controls (list :color :silver 
											:transparency 0.5
											:line-thickness 0.1)
					:control-points (list (the Point_A_front_T_low) 
										  (the Point_A_rear_T_low))
					:degree 1)

					
	
;Lofted surface:
(surf_xfoil_tail
	:type 'lofted-surface
	
	:hidden? t
	
	:end-caps-on-brep? t
	:display-controls (list :color :grey 
							:transparency 0.10
							:line-thickness 0.5) 
	:curves (list (the line_Point_A_front_T_low_Point_A_rear_T_low) 
				  (the line_Point_A_front_T_up_Point_A_rear_T_up)))



;intersection:
	(planar-section-curve-for-tail
	
			:type 'planar-section-curve
  
			:surface  (the loft-tail)
						 
            :plane-normal (rotate-vector 
										(the (face-normal-vector :right))									;normal vector of the surface
										(* (the flow_deflection_factor_Tail) (/ pi 180) (the tail-sweep))	;rotation angle in [rad] -> boils down to sweep
										(the rotation_vector_T)												;vector around which the rotation takes place
						  )
										
            :plane-point (the Point_front_xfoil_T_0)													;leading edge - depending on the "xfoil-spanwisely" 
						 
            :display-controls (list :color :purple 
									:line-thickness 1.5)
	) 
)


;end of define-object:
)
