(define-object wing-wake (base-object)

:input-slots
(
fuselage_total_length
fuselage_radius
wing_position
boolean_top_or_bottom_wing

c-root
c-tip
sweep
semi-span
dihedral
spanwise-position-kink

)

	:computed-slots
(

;For the numeration and interpretation- see drawing		  
		  
;Alpha - the angle of the first tringle visualizing the wake (starting from the leading edge):
(alpha_1 (* (atan (/ 1 2.5)) (/ 180 pi) )) ;careful - approximately from what can be concludeed from the slide 15 - support package 	! ! !

;Beta - the angle of the second triangle (starting from the trailing edge)
(betha_1 (* (atan (/ 1 5.0)) (/ 180 pi) )) ;careful - approximately from what can be concludeed from the slide 15 - support package 	! ! !



;P O I N T S:

;LEFT WING:

;Points for the lines which will be later on used to create surfaces:
;---------------------------------------------------------------------------------------------------------------- 

;leading edge, root profile:
    (P_LE_0 (make-point 0 																		;spanwisely
					   (+  (* -1 (/ (the c-root) 2)) (* -1 (the wing_position)) )				;longitudinally 
					   (* -1 (* (the boolean_top_or_bottom_wing) 0.60 (the fuselage_radius)) )	;vertically
		)
	)
;trailing edge, root profile:
	(P_TE_2 (translate (the P_LE_0)
				:rear (the c-root)
			)
	)


	
;leading egde, tip profile:
	(P_LE_1 (translate (the P_LE_0)
				:rear  (* (the semi-span) (tan (* (/ pi 180) (the sweep))))		;longitudinally
				:top   (* (the semi-span) (sin (* (/ pi 180) (the dihedral))))	;vertically
				:right (* (the semi-span) (cos (* (/ pi 180) (the dihedral))))	;spanwisely
			)
	)	
;trailing edge, tip profile:
	(P_TE_4 (translate (the P_LE_1)
				:rear (the c-tip)
			)
	)



;trailing edge, kink profile:
	(P_TE_3 (translate (the P_TE_2)
				:right (* (the spanwise-position-kink) (the semi-span))
			)
	)

	
	
;End of wake (the part of the triangle somewhere behind the tail)
;---------------------------------------------------------------------------------------------------------------- 

;end of wake - root - leading e. - connecting with P_LE_0:
	(P_EW_0 (translate (the P_LE_0)
				:rear  (+ (* 0.55 (the fuselage_total_length)) (* (the semi-span) (tan (* (/ pi 180) (the sweep))) ) (the c-root) )
				:top   (* (* 0.55 (the fuselage_total_length)) (tan (* (the alpha_1) (/ pi 180) )) )
			)
	)
;end of wake - root - trailing e. - connecting with P_TE_2:
	(P_EW_2 (translate (the P_LE_0)
				:rear  (+ (* 0.55 (the fuselage_total_length)) (* (the semi-span) (tan (* (/ pi 180) (the sweep))) ) (the c-root) )
				:top   (* (* 0.55 (the fuselage_total_length)) (tan (* (the betha_1) (/ pi 180) )) )
			)
	)	
	


;end of wake - tip - leading e. - connecting with P_LE_1:
	(P_EW_1 (translate (the P_LE_1)
				:rear  (+ (* 0.55 (the fuselage_total_length)) (* (the semi-span) (tan (* (/ pi 180) (the sweep))) ) (the c-root) )
				:top   (* (* 0.55 (the fuselage_total_length)) (tan (* (the alpha_1) (/ pi 180) )) )
			)
	)	
;end of wake - tip - trailing e. - connecting with P_TE_4:
	(P_EW_4 (translate (the P_TE_4)
				:rear  (+ (* 0.55 (the fuselage_total_length)) (* (the semi-span) (tan (* (/ pi 180) (the sweep))) ) )
				:top   (* (* 0.55 (the fuselage_total_length)) (tan (* (the betha_1) (/ pi 180) )) )
			)
	)	

	

;end of wake - kink - trailing e. - connecting with P_TE_4:
	(P_EW_3 (translate (the P_TE_3)
				:rear  (+ (* 0.55 (the fuselage_total_length)) (* (the semi-span) (tan (* (/ pi 180) (the sweep))) ))
				:top   (* (* 0.55 (the fuselage_total_length)) (tan (* (the betha_1) (/ pi 180) )) )
			)
	)	

	
	
;RIGHT WING:

;Points for the lines which will be later on used to create surfaces:
;---------------------------------------------------------------------------------------------------------------- 

;leading egde, tip profile:
	(P_LE_R1 (translate (the P_LE_0)
				:rear  (* (the semi-span) (tan (* (/ pi 180) (the sweep))))		;longitudinally
				:top   (* (the semi-span) (sin (* (/ pi 180) (the dihedral))))	;vertically
				:left  (* (the semi-span) (cos (* (/ pi 180) (the dihedral))))	;spanwisely - note it's opposite to left wing
			)
	)	
;trailing edge, tip profile:
	(P_TE_R4 (translate (the P_LE_R1)
				:rear (the c-tip)
			)
	)
	
	

;trailing edge, kink profile:
	(P_TE_R3 (translate (the P_TE_2)
				:left (* (the spanwise-position-kink) (the semi-span))
			)
	)	
	
	
	
;End of wake (the part of the triangle somewhere behind the tail)
;---------------------------------------------------------------------------------------------------------------- 

;end of wake - tip - leading e. - connecting with P_LE_1:
	(P_EW_R1 (translate (the P_LE_R1)
				:rear  (+ (* 0.55 (the fuselage_total_length)) (* (the semi-span) (tan (* (/ pi 180) (the sweep))) ) (the c-root) )
				:top   (* (* 0.55 (the fuselage_total_length)) (tan (* (the alpha_1) (/ pi 180) )) )
			)
	)	
;end of wake - tip - trailing e. - connecting with P_TE_4:
	(P_EW_R4 (translate (the P_TE_R4)
				:rear  (+ (* 0.55 (the fuselage_total_length)) (* (the semi-span) (tan (* (/ pi 180) (the sweep))) ) )
				:top   (* (* 0.55 (the fuselage_total_length)) (tan (* (the betha_1) (/ pi 180) )) )
			)
	)	
	
	
	
;end of wake - kink - trailing e. - connecting with P_TE_4:
	(P_EW_R3 (translate (the P_TE_R3)
				:rear  (+ (* 0.55 (the fuselage_total_length)) (* (the semi-span) (tan (* (/ pi 180) (the sweep))) ))
				:top   (* (* 0.55 (the fuselage_total_length)) (tan (* (the betha_1) (/ pi 180) )) )
			)
	)	
	
	

	
;end of computed-slots:			
)

	


	:objects 
(

; L I N E S:

;LEFT WING:
;---------------------------------------------------------------------------------------------------------------- 

;Lines joining the boundary points of wake (the planes will be visualized as lofted surfaces):

;leading edge triangle, line from root nose to the end of wake:
(line_P_LE_0_P_EW_0
					:type 'b-spline-curve
					:display-controls (list :color :red 
											:transparency 0.5
											:line-thickness 3)
					:control-points (list (the P_LE_0) 
										  (the P_EW_0))
					:degree 1)				
;trailing edge triangle, line from root trailing edge to the end of wake:
(line_P_TE_2_P_EW_2
					:type 'b-spline-curve
					:display-controls (list :color :red 
											:transparency 0.5
											:line-thickness 3)
					:control-points (list (the P_TE_2) 
										  (the P_EW_2))
					:degree 1)


					
;leading edge triangle, line from tip leading edge to the end of wake:
(line_P_LE_1_P_EW_1
					:type 'b-spline-curve
					:display-controls (list :color :blue-steel 
											:transparency 0.5)
					:control-points (list (the P_LE_1) 
										  (the P_EW_1))
					:degree 1)	
;trailing edge triangle, line from tip trailing edge to the end of wake:
(line_P_TE_4_P_EW_4
					:type 'b-spline-curve
					:display-controls (list :color :blue-steel 
											:transparency 0.5)
					:control-points (list (the P_TE_4) 
										  (the P_EW_4))
					:degree 1)		
	
	
	
;trailing edge triangle, line from kink trailing edge to the end of wake:
(line_P_TE_3_P_EW_3
					:type 'b-spline-curve
					:display-controls (list :color :blue-steel 
											:transparency 0.5)
					:control-points (list (the P_TE_3) 
										  (the P_EW_3))
					:degree 1)	
	
	
;RIGHT WING:
;---------------------------------------------------------------------------------------------------------------- 

;Lines joining the boundary points of wake (the planes will be visualized as lofted surfaces):

;leading edge triangle, line from tip leading edge to the end of wake:
(line_P_LE_R1_P_EW_R1
					:type 'b-spline-curve
					:display-controls (list :color :blue-steel 
											:transparency 0.5)
					:control-points (list (the P_LE_R1) 
										  (the P_EW_R1))
					:degree 1)	
;trailing edge triangle, line from tip trailing edge to the end of wake:
(line_P_TE_R4_P_EW_R4
					:type 'b-spline-curve
					:display-controls (list :color :blue-steel 
											:transparency 0.5)
					:control-points (list (the P_TE_R4) 
										  (the P_EW_R4))
					:degree 1)	

	
;trailing edge triangle, line from kink trailing edge to the end of wake:
(line_P_TE_R3_P_EW_R3
					:type 'b-spline-curve
					:display-controls (list :color :blue-steel 
											:transparency 0.5)
					:control-points (list (the P_TE_R3) 
										  (the P_EW_R3))
					:degree 1)	
	
	

	
	
;S U R F A C E S:
	
	
;LEFT WING:
;---------------------------------------------------------------------------------------------------------------- 
	
;Lofted surfaces:

;leading edge:
(surf_line_P_LE_0_P_EW_0_and_line_P_LE_1_P_EW_1
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :silver 
							:transparency 0.10
							:line-thickness 0.05) 
	:curves (list (the line_P_LE_0_P_EW_0) 
				  (the line_P_LE_1_P_EW_1)))	

;trailing edge - outer wing:				  
(surf_line_P_TE_4_P_EW_4_and_line_P_TE_3_P_EW_3
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :yellow 
							:transparency 0.10
							:line-thickness 0.05) 
	:curves (list (the line_P_TE_4_P_EW_4) 
				  (the line_P_TE_3_P_EW_3)))

;trailing edge - inner wing:				  
(surf_line_P_TE_3_P_EW_3_and_line_P_TE_2_P_EW_2
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :pink 
							:transparency 0.90
							:line-thickness 0.5) 
	:curves (list (the line_P_TE_3_P_EW_3) 
				  (the line_P_TE_2_P_EW_2)))	
	

	
;RIGHT WING:
;---------------------------------------------------------------------------------------------------------------- 
	
;Lofted surfaces:

;leading edge:
(surf_line_P_LE_0_P_EW_0_and_line_P_LE_R1_P_EW_R1
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :silver 
							:transparency 0.10
							:line-thickness 0.05) 
	:curves (list (the line_P_LE_0_P_EW_0) 
				  (the line_P_LE_R1_P_EW_R1)))	

;trailing edge - outer wing:
(surf_line_P_TE_R4_P_EW_R4_and_line_P_TE_R3_P_EW_R3
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :yellow 
							:transparency 0.10
							:line-thickness 0.05) 
	:curves (list (the line_P_TE_R4_P_EW_R4) 
				  (the line_P_TE_R3_P_EW_R3)))	
				  
;trailing edge - inner wing:
(surf_line_P_TE_R3_P_EW_R3_and_line_P_TE_2_P_EW_2
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :pink 
							:transparency 0.90
							:line-thickness 0.3) 
	:curves (list (the line_P_TE_R3_P_EW_R3) 
				  (the line_P_TE_2_P_EW_2)))
				  
				  
				  
				  
;AUXILIARY surface - verical surface cutting fin symmetrically:
(surf_line_P_LE_0_P_EW_0_and_line_P_TE_2_P_EW_2
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :violet 
							:transparency 0.10
							:line-thickness 0.5) 
	:curves (list (the line_P_LE_0_P_EW_0) 
				  (the line_P_TE_2_P_EW_2)))
				  
				  
				  
				  
;end of obcjects:
)		

;end of define-object:
)
	

