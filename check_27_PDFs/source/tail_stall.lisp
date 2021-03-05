(define-object tail-wake (base-object)

:input-slots
(
tail-root-center

tail-c-root
tail-c-tip 

tail-sweep 
tail-semi-span
tail-dihedral 

)

	:computed-slots
(

;For the numeration and interpretation- see drawing		  
		  
;Alpha - the angle of the first tringle visualizing the wake (starting from the leading edge):
(alpha_2 60) ; [deg] - careful - approximately from what can be concludeed from the slide 15 - support package 	! ! !

;Beta - the angle of the second triangle (starting from the trailing edge)
(betha_2 30) ; [deg] - careful - approximately from what can be concludeed from the slide 15 - support package 	! ! !


;P O I N T S:

;LEFT WING:

;Points for the lines which will be later on used to create surfaces:
;---------------------------------------------------------------------------------------------------------------- 

;leading edge, root profile:
	(Pt_LE_0 (translate (the tail-root-center)
				:front (/ (the tail-c-root) 2)
			 )
	)
;trailing edge, root profile:
	(Pt_TE_2 (translate (the Pt_LE_0)
				:rear (the tail-c-root)
			 )
	)
	

;leading egde, tip profile:
	(Pt_LE_1 (translate (the Pt_LE_0)
				:rear  (* (the tail-semi-span) (tan (* (/ pi 180) (the tail-sweep))))		;longitudinally
				:top   (* (the tail-semi-span) (sin (* (/ pi 180) (the tail-dihedral))))	;vertically
				:right (* (the tail-semi-span) (cos (* (/ pi 180) (the tail-dihedral))))	;spanwisely
			 )
	)	
;trailing edge, tip profile:
	(Pt_TE_3 (translate (the Pt_LE_1)
				:rear (the tail-c-tip)
			 )
	)

	
	
;End of wake (the part of the triangle somewhere behind the tail)
;---------------------------------------------------------------------------------------------------------------- 

;end of wake - root - leading e. - connecting with Pt_LE_0:
	(Pt_EW_0 (translate (the Pt_LE_0)
				:rear  (+ (* 1.5 (the tail-c-root)) (* (the tail-semi-span) (tan (* (/ pi 180) (the tail-sweep))) ) (the tail-c-root) )
				:top   (* (* 1.5 (the tail-c-root)) (tan (* (the alpha_2) (/ pi 180) )) )
			 )
	)		
;end of wake - root - trailing e. - connecting with Pt_TE_2:
	(Pt_EW_2 (translate (the Pt_TE_2)
				:rear  (+ (* 1.5 (the tail-c-root)) (* (the tail-semi-span) (tan (* (/ pi 180) (the tail-sweep))) ) (the tail-c-root) )
				:top   (* (* 1.5 (the tail-c-root)) (tan (* (the betha_2) (/ pi 180) )) )
			 )
	)
	

	
;end of wake - tip - leading e. - connecting with Pt_LE_1:
	(Pt_EW_1 (translate (the Pt_LE_1)
				:rear  (+ (* 1.5 (the tail-c-root)) (* (the tail-semi-span) (tan (* (/ pi 180) (the tail-sweep))) ) (the tail-c-root) )
				:top   (* (* 1.5 (the tail-c-root)) (tan (* (the alpha_2) (/ pi 180) )) )
			 )
	)		
;end of wake - tip - trailing e. - connecting with Pt_TE_3:
	(Pt_EW_3 (translate (the Pt_TE_3)
				:rear  (+ (* 1.5 (the tail-c-root)) (* (the tail-semi-span) (tan (* (/ pi 180) (the tail-sweep))) ) (the tail-c-root) )
				:top   (* (* 1.5 (the tail-c-root)) (tan (* (the betha_2) (/ pi 180) )) )
			 )
	)
	
	
;RIGHT WING:

;Points for the lines which will be later on used to create surfaces:
;---------------------------------------------------------------------------------------------------------------- 

;leading egde, tip profile:
	(Pt_LE_R1 (translate (the Pt_LE_0)
				:rear  (* (the tail-semi-span) (tan (* (/ pi 180) (the tail-sweep))))		;longitudinally
				:top   (* (the tail-semi-span) (sin (* (/ pi 180) (the tail-dihedral))))	;vertically
				:left  (* (the tail-semi-span) (cos (* (/ pi 180) (the tail-dihedral))))	;spanwisely
			)
	)	
;trailing edge, tip profile:
	(Pt_TE_R3 (translate (the Pt_LE_R1)
				:rear (the tail-c-tip)
			  )
	)

;End of wake (the part of the triangle somewhere behind the tail)
;---------------------------------------------------------------------------------------------------------------- 
	
;end of wake - root - leading e. - connecting with Pt_LE_0:
	(Pt_EW_R1 (translate (the Pt_LE_R1)
				:rear  (+ (* 1.5 (the tail-c-root)) (* (the tail-semi-span) (tan (* (/ pi 180) (the tail-sweep))) ) (the tail-c-root) )
				:top   (* (* 1.5 (the tail-c-root)) (tan (* (the alpha_2) (/ pi 180) )) )
			 )
	)		
;end of wake - root - trailing e. - connecting with Pt_TE_2:
	(Pt_EW_R3 (translate (the Pt_TE_R3)
				:rear  (+ (* 1.5 (the tail-c-root)) (* (the tail-semi-span) (tan (* (/ pi 180) (the tail-sweep))) ) (the tail-c-root) )
				:top   (* (* 1.5 (the tail-c-root)) (tan (* (the betha_2) (/ pi 180) )) )
			 )
	)	
	
	
	
	
;end of computed slots:
)	
	
	
	:objects 
(	
	
;L I N E S:

;LEFT WING:

;Lines which will be later on used to create surfaces:
;---------------------------------------------------------------------------------------------------------------- 

;leading edge triangle, line from root nose to the end of wake:
(line_Pt_LE_0_Pt_EW_0
					:type 'b-spline-curve
					:display-controls (list :color :blue 
											:transparency 0.5
											:line-thickness 2)
					:control-points (list (the Pt_LE_0) 
										  (the Pt_EW_0))
					:degree 1)

;trailing edge triangle, line from root trailing edge to the end of wake:
(line_Pt_TE_2_Pt_EW_2
					:type 'b-spline-curve
					:display-controls (list :color :blue 
											:transparency 0.5
											:line-thickness 2)
					:control-points (list (the Pt_TE_2) 
										  (the Pt_EW_2))
					:degree 1)


					
;leading edge triangle, line from tip nose to the end of wake:
(line_Pt_LE_1_Pt_EW_1
					:type 'b-spline-curve
					:display-controls (list :color :blue 
											:transparency 0.5
											:line-thickness 0.1)
					:control-points (list (the Pt_LE_1) 
										  (the Pt_EW_1))
					:degree 1)

;trailing edge triangle, line from tip trailing edge to the end of wake:
(line_Pt_TE_3_Pt_EW_3
					:type 'b-spline-curve
					:display-controls (list :color :blue 
											:transparency 0.5
											:line-thickness 0.1)
					:control-points (list (the Pt_TE_3) 
										  (the Pt_EW_3))
					:degree 1)

					
					
					
					
;RIGHT WING:					
					
					
;leading edge triangle, line from tip nose to the end of wake:
(line_Pt_LE_R1_Pt_EW_R1
					:type 'b-spline-curve
					:display-controls (list :color :blue 
											:transparency 0.5
											:line-thickness 0.1)
					:control-points (list (the Pt_LE_R1) 
										  (the Pt_EW_R1))
					:degree 1)

;trailing edge triangle, line from tip trailing edge to the end of wake:
(line_Pt_TE_R3_Pt_EW_R3
					:type 'b-spline-curve
					:display-controls (list :color :blue 
											:transparency 0.5
											:line-thickness 0.1)
					:control-points (list (the Pt_TE_R3) 
										  (the Pt_EW_R3))
					:degree 1)					
					

					

;S U R F A C E S:

;LEFT TAIL WING:

;leading edge:
(surf_line_Pt_LE_0_Pt_EW_0_and_line_Pt_LE_1_Pt_EW_1
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :silver 
							:transparency 0.10
							:line-thickness 0.25) 
	:curves (list (the line_Pt_LE_0_Pt_EW_0) 
				  (the line_Pt_LE_1_Pt_EW_1)))				
					
;trailing edge:
(surf_line_Pt_TE_2_Pt_EW_2_and_line_Pt_TE_3_Pt_EW_3
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :yellow 
							:transparency 0.10
							:line-thickness 0.25) 
	:curves (list (the line_Pt_TE_2_Pt_EW_2) 
				  (the line_Pt_TE_3_Pt_EW_3)))


;RIGHT TAIL WING:

;leading edge:
(surf_line_Pt_LE_R0_Pt_EW_R0_and_line_Pt_LE_R1_Pt_EW_R1
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :silver 
							:transparency 0.10
							:line-thickness 0.05) 
	:curves (list (the line_Pt_LE_0_Pt_EW_0) 
				  (the line_Pt_LE_R1_Pt_EW_R1)))
;trailing edge:
(surf_line_Pt_TE_2_Pt_EW_2_and_line_Pt_TE_R3_Pt_EW_R3
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :yellow 
							:transparency 0.10
							:line-thickness 0.05) 
	:curves (list (the line_Pt_TE_2_Pt_EW_2) 
				  (the line_Pt_TE_R3_Pt_EW_R3)))
				  
				  
;AUXILIARY surface - verical surface cutting fin symmetrically:
(surf_line_Pt_LE_0_Pt_EW_0_and_line_Pt_TE_2_Pt_EW_2
	:type 'lofted-surface
	:end-caps-on-brep? t
	:display-controls (list :color :violet 
							:transparency 0.10
							:line-thickness 0.5) 
	:curves (list (the line_Pt_LE_0_Pt_EW_0) 
				  (the line_Pt_TE_2_Pt_EW_2)))				  
				  
	
;end of objects:
)


;end of define object:
)

; (define-object fin-surface-for-wake (base-object)
; :input-slots
; (
; fin-c-root
; fin-c-tip
; fin-span
; )

; :computed-slots
; (
; (fin-surface-for-wake (* (+ (the fin-c-root) (the fin-c-tip)) (the fin-span) 0.5 ))

; )


; (define-object tail-wake-intersect (base-object)
  ; :objects
  ; ((intersect
    ; :type 'intersected-solid
    ; :display-controls (list :line-thickness 2 :color :blue)
    ; :brep (the box)
    ; :other-brep (the cone)))
  ; :hidden-objects
  ; ((box
    ; :type 'box-solid
    ; :length 50
    ; :width 50
    ; :height 50)
   ; (cone
    ; :type 'cone-solid
    ; :length 100
    ; :radius-1 5
    ; :radius-2 20)))