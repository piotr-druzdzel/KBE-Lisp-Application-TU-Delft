;the definition of engines is based upon a similar principle as a design of the fuselage

(define-object engine-type (cylinder)
				
  :input-slots (
  		
		engine_diameter 
		engine_length

		fuselage_radius
		dihedral
		thickness
		c-root
		semi-span
		sweep
		
		fuselage_cylinder_length
		fuselage_aft_cone_length
		
		engines_podded_0_mounted_1
		boolean_top_or_bottom_wing
		wing_position
		
		cross-section-percents-engines
		child_number		
		engine_number 
		
		3_rd_engine 
		
			  )

  :computed-slots ( 
 
 
(engine_radius (/ (the engine_diameter) 2))
 
 
;--- 2 or 4 engines parametrization ---
 
;spanwise translation when 2 or 4 engines:
(spanwise_translation
    (when  (or (eql 2 (the engine_number)) (eql 4 (the engine_number)) ) 
			 
;podded/fuselage mounted ecase:		     
	 (ecase (the engines_podded_0_mounted_1) 

;ecase when podded:	 
		(0 
		
;left or right side spanwise translation. if the child index of the engine is smaller than half of the engine_number, translate along left wing:
   (if (eql (rem (the child_number) 2) 0 )
    
;(for engine 0 -> parameter=1 -> 1/2 -> rest=1)   
;(for engine 1 -> parameter=2 -> 2/2 -> rest=0)
;(for engine 2 -> parameter=3 -> 3/2 -> rest=1)
;(for engine 3 -> parameter=4 -> 4/2 -> rest=0)

;true, left wing: (rest from division by 2 is 0, engines 1 and 3)  
      (* (the semi-span) (* (/ 1 (+ 5 (/ (the engine_number) 2))) (+ (the child_number) 0)) )   

;false, right wing: (rest from division by 2 is 1, engines 0 and 2)
(* -1 (* (the semi-span) (* (/ 1 (+ 5 (/ (the engine_number) 2))) (+ (the child_number) 1)) ) )) )

;ecase when mounted in fuselage:
		(1 
		
	(if (eql (rem (the child_number) 2) 0 )
;left side:
		(+ (* (+ (the child_number) 0) (/ (the engine_diameter) 1.80)) (* 0.60 (+ (the fuselage_radius) (the engine_radius)) )) 	
;right side:		
  (* -1 (+ (* (+ (the child_number) 1) (/ (the engine_diameter) 1.80)) (* 0.60 (+ (the fuselage_radius) (the engine_radius)) )) ) ))))
		
)




;vertical translation when 2 or 4 engines:
(vertical_translation
    (when  (or (eql 2 (the engine_number)) (eql 4 (the engine_number)) ) 
			 
;podded/fuselage mounted ecase:		     
	 (ecase (the engines_podded_0_mounted_1) 

;ecase when podded:	 
		(0 
		
;left or right side spanwise translation. if the child index of the engine is smaller than half of the engine_number, translate along left wing:
   (if (eql (rem (the child_number) 2) 0 )
   
;true: rest from division by 2 is 0, engines 1 and 3 (left side): 
;(for engine 0 -> parameter=1 -> 1/2 -> rest=1)   
;(for engine 1 -> parameter=2 -> 2/2 -> rest=0)
;(for engine 2 -> parameter=3 -> 3/2 -> rest=1)
;(for engine 3 -> parameter=4 -> 4/2 -> rest=0)
    
     (- (* 1.0 (tan (* (/ pi 180) (the dihedral))) (* (the semi-span) (* (/ 1 (+ 4 (/ (the engine_number) 2))) (+ (the child_number) 0)) ) )
	  	(+ (* (the boolean_top_or_bottom_wing) 0.60 (the fuselage_radius))  (the engine_radius)  (the thickness) )) 
	  
;false: rest from division by 2 is 1, engines 0 and 2: 
     (- (* 1.0 (tan (* (/ pi 180) (the dihedral))) (* (the semi-span) (* (/ 1 (+ 4 (/ (the engine_number) 2))) (+ (the child_number) 1)) ))  
		(+ (* (the boolean_top_or_bottom_wing) 0.60 (the fuselage_radius) ) (the engine_radius)  (the thickness) ))  ))
   
;ecase when mounted in fuselage:
		(1 
		
	(if (eql (rem (the child_number) 2) 0 )
;true, left side:
		(/ (the fuselage_radius) 2)
;false, right side:
        (/ (the fuselage_radius) 2) )) ))

)




;rear translation when 2 or 4 engines:
(rear_translation
    (when  (or (eql 2 (the engine_number)) (eql 4 (the engine_number)) ) 
			 
;podded/fuselage mounted ecase:		     
	 (ecase (the engines_podded_0_mounted_1) 

;ecase when podded:	 
		(0 
		
;left or right side spanwise translation. if the child index of the engine is smaller than half of the engine_number, translate along left wing:
   (if (eql (rem (the child_number) 2) 0 )
   
;true: rest from division by 2 is 0, engines 1 and 3: 
;(for engine 0 -> parameter=1 -> 1/2 -> rest=1)   
;(for engine 1 -> parameter=2 -> 2/2 -> rest=0)
;(for engine 2 -> parameter=3 -> 3/2 -> rest=1)
;(for engine 3 -> parameter=4 -> 4/2 -> rest=0)
    
      (- (+ (/ (the c-root) 2.0) (the wing_position)) (* (tan (* (the sweep) (/ pi 180)))
	  
	  ;spanwise translation:
	  (* (the semi-span) (* (/ 1 (+ 5 (/ (the engine_number) 2))) (+ (the child_number) 0)) )  
	  
	  )) 
	  
;false: rest from division by 2 is 1, engines 0 and 2: 
      (- (+ (/ (the c-root) 2.0) (the wing_position)) (* (tan (* (the sweep) (/ pi 180))) 
	  
	  ;spanwise translation:
	  (* 1 (* (the semi-span) (* (/ 1 (+ 5 (/ (the engine_number) 2))) (+ (the child_number) 1)) ) )
	  
	  ))  
		))
   
;ecase when mounted in fuselage:
		(1 
		
	(if (eql (rem (the child_number) 2) 0 )
;true, left side:
		(* -1 (* 0.50 (the fuselage_cylinder_length) ) )
;false, right side:
        (* -1 (* 0.50 (the fuselage_cylinder_length) ) ) )) ))

;end of the rear tranlation
)




;--- 3 engines parametrization ---


;------
;distinguishing betweeen 3 and (2 and 4) engine configuration for the cenetering parameter:
(child_number-aux

(if (eql 3 (the engine_number))

	(if (eql 3 (the child_number))
		0
		(the child_number)
	)
	
	(the child_number)
)
)
;------

;------
;a tiny function to divide the parameter responsible for centering the engine on the left wing (dividing this particular by one yields 1)
;therefore the engine 0 and 1 are distributed evenly along the wingspan with a scaling factor eqial to 1. (not 1 and 2 as earlier)
(aux-division 
		(if (eql 2 (the child_number-aux))
		2
		1
		)
)		
;------	



(spanwise_translation_3
    (when (eql 3 (the engine_number)) 
			 
;podded/fuselage mounted ecase:		     
	 (ecase (the engines_podded_0_mounted_1) 

;ecase when podded:	 
		(0 
		
;left or right side spanwise translation. if the child index of the engine is smaller than half of the engine_number, translate along left wing:
   (if (eql (rem (the child_number) 2) 0 )
    
;(for engine 0 -> parameter=1 -> 1/2 -> rest=1)   
;(for engine 1 -> parameter=2 -> 2/2 -> rest=0)
;(for engine 2 -> parameter=3 -> 3/2 -> rest=1)
;(for engine 3 -> parameter=4 -> 4/2 -> rest=0)

;true, left wing: (rest from division by 2 is 0, engines 1 and 3)  
      (* (the semi-span) 0.35 (/ (the child_number-aux) (the aux-division))   )   

;false, right wing: (rest from division by 2 is 1, engines 0 and 2)
(* -1 (* (the semi-span) 0.35 (/ (the child_number-aux) (the aux-division))   )   ) ) )

;ecase when mounted in fuselage:
		(1 
		
	(if (eql (rem (the child_number) 2) 0 )

		(* (+ (the engine_diameter) (the fuselage_radius))  0.9 (/ (the child_number-aux) (the aux-division))   ) 	
		
  (* -1 (* (+ (the engine_diameter) (the fuselage_radius))) 0.9 (/ (the child_number-aux) (the aux-division))   )  ))))
		

)


(vertical_translation_3
    (when  (eql 3 (the engine_number)) 
			 
;podded/fuselage mounted ecase:		     
	 (ecase (the engines_podded_0_mounted_1) 

;ecase when podded:	 
		(0 
		
(if (eql 0 (the child_number-aux))

	(+ (the fuselage_radius) (/ (the engine_diameter) 1.0) )		
		
;left or right side spanwise translation. if the child index of the engine is smaller than half of the engine_number, translate along left wing:
   (if (eql (rem (the child_number) 2) 0 )
   
;true: rest from division by 2 is 0, engines 1 and 3: 
;(for engine 0 -> parameter=1 -> 1/2 -> rest=1)   
;(for engine 1 -> parameter=2 -> 2/2 -> rest=0)
;(for engine 2 -> parameter=3 -> 3/2 -> rest=1)
;(for engine 3 -> parameter=4 -> 4/2 -> rest=0)
    
     (- (* 1.0 (tan (* (/ pi 180) (the dihedral))) (* (the semi-span) (* (/ 1 (+ 4 (/ (the engine_number) 2))) (+ (the child_number) 0)) ) )
	  	 (+ (* (the boolean_top_or_bottom_wing) 0.60 (the fuselage_radius))  (the engine_radius)  (the thickness) )) 
	  
;false: rest from division by 2 is 1, engines 0 and 2: 
     (- (* 1.0 (tan (* (/ pi 180) (the dihedral))) (* (the semi-span) (* (/ 1 (+ 4 (/ (the engine_number) 2))) (+ (the child_number) 1)) ))  
		(+ (* (the boolean_top_or_bottom_wing) 0.60 (the fuselage_radius) )  (the engine_radius)  (the thickness) ))  )))
   
;ecase when mounted in fuselage:
		(1 
		
(if (eql 0 (the child_number-aux))

	(+ (the fuselage_radius) (/ (the engine_diameter) 1.5) )
		
	(if (eql (rem (the child_number) 2) 0 )
;true, left side:
		(/ (the fuselage_radius) 2)
;false, right side:
        (/ (the fuselage_radius) 2) 
	)
) )))

)


(rear_translation_3
    (when  (eql 3 (the engine_number)) 
			 
;podded/fuselage mounted ecase:		     
	 (ecase (the engines_podded_0_mounted_1) 

;ecase when podded:	 
		(0 
		

(if (eql 0 (the child_number-aux))


	(* -1 (- (the 3_rd_engine) (* 0.2 (the engine_length)) ) )
		
		
;left or right side spanwise translation. if the child index of the engine is smaller than half of the engine_number, translate along left wing:
   (if (eql (rem (the child_number) 2) 0 )
   
;true: rest from division by 2 is 0, engines 1 and 3: 
;(for engine 0 -> parameter=1 -> 1/2 -> rest=1)   
;(for engine 1 -> parameter=2 -> 2/2 -> rest=0)
;(for engine 2 -> parameter=3 -> 3/2 -> rest=1)
;(for engine 3 -> parameter=4 -> 4/2 -> rest=0)

;engines 1 and 3, left wing:
      (- (+ (/ (the c-root) 2.5) (the wing_position)) (* (tan (* (the sweep) (/ pi 180)))
	  
	  ;spanwise translation:
	  (* (the semi-span) (* (/ 1 (+ 5 (/ (the engine_number) 2))) (+ (the child_number) 0)) )  
	  
	  )) 
	  
;false: rest from division by 2 is 1, engines 0 and 2: 
      (- (+ (/ (the c-root) 2.5) (the wing_position)) (* (tan (* (the sweep) (/ pi 180))) 
	  
	  ;spanwise translation:
	  (* 1 (* (the semi-span) (* (/ 1 (+ 5 (/ (the engine_number) 2))) (+ (the child_number) 1)) ) )
	  
	  ))  )
		))
   
;ecase when mounted in fuselage:
		(1 
		
		
(if (eql 0 (the child_number-aux))


	(* -1 (- (the 3_rd_engine) (* 1.30 (the engine_length)) ) )
	
		
	(if (eql (rem (the child_number) 2) 0 )
;true, left side:
		(* -1 (* 0.50 (the fuselage_cylinder_length) ) )
;false, right side:
        (* -1 (* 0.50 (the fuselage_cylinder_length) ) ) )) )) )

;end of the rear tranlation
)





;three functions to distinguish between 3 and (2 and 4) engines config. for the positioning the 'center' of the object:
(longitudinal_translation

	(if (eql 3 (the engine_number))
		
		(the rear_translation_3)
		(the rear_translation)
	)
)

(sideway_translation

	(if (eql 3 (the engine_number))
		
		(the spanwise_translation_3)
		(the spanwise_translation)
	)
)

(top_translation

	(if (eql 3 (the engine_number))
		
		(the vertical_translation_3)
		(the vertical_translation)
	)
)




;the center of the object 'engine-type' depending on the child number:
(center (translate (make-point 0 0 0) 
				      :front  (the longitudinal_translation)
				      :right  (the sideway_translation) 
				      :top    (the top_translation)))


;definition of the engine is similar to that of the fuselage in primi-plane example:		  
(radius (half   (the engine_diameter)))
(length         (the engine_length))
		   
(section-offset-percentages (plist-keys (the cross-section-percents-engines)))
                                                                     
(section-centers (let ((nose-point (the (face-center :front))))
				      (mapcar #'(lambda(percentage )
					  (translate nose-point :rear 
					  (* percentage 1/100 
					  (the length))))
                      (the section-offset-percentages))))
		   
(section-diameter-percentages (plist-values (the cross-section-percents-engines))) 

(section-radii (mapcar #'(lambda(percentage) 
		       (* 1/100 percentage (the radius)))
			   (the section-diameter-percentages)))
			   
;end of computed-slots:
)
				  
				  
  :hidden-objects ((section-curves
									:type 'arc-curve
									:sequence (:size (length (the section-centers)))
									:center (nth (the-child index) (the section-centers))
									:radius (nth (the-child index) (the section-radii))
									:orientation (alignment :top (the (face-normal-vector :rear)))))

  :objects(

	(loft-engine :type 'lofted-surface
				 :end-caps-on-brep? t
				 :curves (list-elements (the section-curves)))
          )
		  
;end of engine type object:
)


;------------------------------------------------------------------------------------------

;the parent of each engine:
;the engine-assembly in the main airplane file is of type 'engines
;
(define-object engines (base-object)

  :input-slots (
  
		engine_diameter
		engine_length
		
		semi-span
		thickness
		c-root
		dihedral
		sweep
		fuselage_radius
		
		fuselage_cylinder_length
		fuselage_aft_cone_length
				
		boolean_top_or_bottom_wing
		engines_podded_0_mounted_1
		wing_position
		
		3_rd_engine
		
		engine_number

				)
  
  
  :objects (
  
			( engine 	
			
				:type 'engine-type
				
				:sequence (:size (the engine_number))

				:engine_diameter (the engine_diameter)
				:engine_length   (the engine_length)
				
				:engine_number (the engine_number)
				
				:dihedral (the dihedral)
				:sweep(the sweep)
				:semi-span (the semi-span)
				:thickness (the thickness)
				:c-root (the c-root)
				:fuselage_radius (the fuselage_radius)
				
				:fuselage_cylinder_length (the fuselage_cylinder_length)
				:fuselage_aft_cone_length (the fuselage_aft_cone_length)
				
				:engines_podded_0_mounted_1 (the engines_podded_0_mounted_1)
				:boolean_top_or_bottom_wing (the boolean_top_or_bottom_wing)
				:wing_position (the wing_position)
				
				:3_rd_engine (the 3_rd_engine)
				
				:child_number (+ 1 (the-child index))
				
				:display-controls (list :color :blue
										:transparency 0.2
										:line-thickness 0.1)
				
				:cross-section-percents-engines ( list 	0   100
														10  100
														20  100
														30  60
														40  50
														50  40
														60  40
														70  50
														80  40
														90  30
														100 20
												)
		     ))

;end of object engines
)
