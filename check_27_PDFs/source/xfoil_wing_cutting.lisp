
(define-object cutting-wing-x-foil (base-object)

:input-slots
(
fuselage_radius
wing_position
boolean_top_or_bottom_wing

c-root
c-tip
sweep
semi-span
dihedral

xfoil-spanwisely
thickness
spanwise-position-kink

  loft-outer
  loft-inner

)

	:computed-slots
(

;P a r t  1:

;creating auxiliary intersection chordwisely:

;leading edge, root profile:
    (Point_LE_0 (make-point 0 																		;spanwisely
							(+  (* -1 (/ (the c-root) 2)) (* -1 (the wing_position)) )				;longitudinally 
							(* -1 (* (the boolean_top_or_bottom_wing) 0.60 (the fuselage_radius)) )	;vertically
				)
	)
	
;somewhere down the span <- where exactly - depends directly on the user: see xfoil-spanwisely variable:
	(Point_front_0 (translate (the Point_LE_0)
					:right (* (the semi-span) (the xfoil-spanwisely) (cos (* (/ pi 180) (the dihedral))) )
					:top   (* (the semi-span) (the xfoil-spanwisely) (sin (* (/ pi 180) (the dihedral))) )
			)
	)

;somewhere down the span + translated rear (for example by the length of the root chord and sweep dist. to make sure it is enough) to make a line for surface:
	(Point_rear_0 (translate (the Point_front_0)
					:rear (+ (the c-root) (* (the semi-span) (the xfoil-spanwisely) (tan (* (/ pi 180) (the sweep)))) )
			)
	)
	
;looking at the aircraft from the right and having the nose fuselage pointed tot he left we have the following nomenclature:

;point A front up:
	(Point_A_front_up (translate (the Point_front_0)
						:top (* 6 (the thickness))
					  )
	)

;point A front low:
	(Point_A_front_low (translate (the Point_front_0)
						:bottom (* 6 (the thickness))
					   )
	)

;point A rear up:
	(Point_A_rear_up (translate (the Point_rear_0)
						:top (* 6 (the thickness))
					  )
	)

;point A rear low:
	(Point_A_rear_low (translate (the Point_rear_0)
						:bottom (* 6 (the thickness))
					  )
	)	


  
 	(Point_front_xfoil_0 (translate (the Point_LE_0)
							
							:right (* (the semi-span) (the xfoil-spanwisely) (cos (* (/ pi 180) (the dihedral))) )	;spanwisely
							:rear  (* (the semi-span) (the xfoil-spanwisely) (tan (* (/ pi 180) (the sweep))) )		;longitudinally
							:top   (* (the semi-span) (the xfoil-spanwisely) (sin (* (/ pi 180) (the dihedral))) )	;vertically
						 )
	) 
  
;convention: y, x, z:
  (rotation_vector  (make-vector
								(* (the semi-span) (the xfoil-spanwisely) (cos (* (/ pi 180) (the dihedral))) )		; y - spanwise direction
								(* (the semi-span) (the xfoil-spanwisely) (tan (* (/ pi 180) (the sweep   ))) )		; x - rear direction
								(* (the semi-span) (the xfoil-spanwisely) (sin (* (/ pi 180) (the dihedral))) )		; z - verical direction
					)
  )
  
;the flow is likely to deflect more in the outboard part of the wing, the "xfoil-spanwisely" can vary between 0 and 1.00:
  (flow_deflection_factor
							(if (<= (the xfoil-spanwisely) 0.25)
								1.00
								(if (and (> (the xfoil-spanwisely) 0.25) (<= (the xfoil-spanwisely) 0.50) )
									1.25
									(if (and (> (the xfoil-spanwisely) 0.50) (<= (the xfoil-spanwisely) 0.75) )
										1.50
										(when (and (> (the xfoil-spanwisely) 0.75) (<= (the xfoil-spanwisely) 1.0) )
											1.75
										)
									)
								)
							)
	)




;points obtained from the resulting intersection:	
(xfoil_wing_3D_points-1
					(the planar-section-curve-for-wing    control-points-local) 
)

(xfoil_wing_3D_points-2 (mapcar #'(lambda (x)
										(rotate-vector 	
														x
														(* -1 (the flow_deflection_factor) (/ pi 180) (the sweep)) 
														(the (face-normal-vector :top))
										) 
								)
								(the xfoil_wing_3D_points-1)
				    )
)

(xfoil_wing_3D_points-3 (mapcar #'(lambda (x)
										(rotate-vector-d 	
														x
														75 												;trial and error thing
														(the (face-normal-vector :front))
										) 
								)
								(the xfoil_wing_3D_points-2)
				    )
)

(xfoil_wing_3D_points (mapcar #'(lambda (x)
										(rotate-vector-d 	
														x
														-25											;just for the direction purpose 
														(the (face-normal-vector :top))
										) 
								)
								(the xfoil_wing_3D_points-3)
				    )
)	
;end of computed-slots:	
)	

	
	:objects
(
	
;upper line:
(line_Point_A_front_up_Point_A_rear_up
					:type 'b-spline-curve
					
					:hidden? t
					
					:display-controls (list :color :silver 
											:transparency 0.5
											:line-thickness 0.1)
					:control-points (list (the Point_A_front_up) 
										  (the Point_A_rear_up))
					:degree 1)

;lower line:
(line_Point_A_front_low_Point_A_rear_low
					:type 'b-spline-curve
					
					:hidden? t
					
					:display-controls (list :color :silver 
											:transparency 0.5
											:line-thickness 0.1)
					:control-points (list (the Point_A_front_low) 
										  (the Point_A_rear_low))
					:degree 1)

					
	
;Lofted surface:
(surf_xfoil_wing
	:type 'lofted-surface
	
	:hidden? t
	
	:end-caps-on-brep? t
	:display-controls (list :color :silver 
							:transparency 0.10
							:line-thickness 0.5) 
	:curves (list (the line_Point_A_front_low_Point_A_rear_low) 
				  (the line_Point_A_front_up_Point_A_rear_up)))



;intersection:
	(planar-section-curve-for-wing 
	
			:type 'planar-section-curve
  
			:surface  (if (>= (the xfoil-spanwisely) (the spanwise-position-kink) )
							  (the loft-outer)
							  (the loft-inner)
					  )
						 
            :plane-normal (rotate-vector 
										(the (face-normal-vector :right))							;normal vector of the surface
										(* (the flow_deflection_factor) (/ pi 180) (the sweep))		;rotation angle in [rad] -> boils down to sweep
										(the rotation_vector)										;vector around which the rotation takes place
						  )
										
            :plane-point (the Point_front_xfoil_0 )													;leading edge - depending on the "xfoil-spanwisely" 
						 
            :display-controls (list :color :purple 
									:line-thickness 1.5)
	) 
)


;end of define-object:
)

;the resulting intersection 3D points can be checked here: (the xfoil-wing-cutting planar-section-curve-for-wing control-points-local)