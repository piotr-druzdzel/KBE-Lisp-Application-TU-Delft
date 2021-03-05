
;Two wings:
;An object box-wings is a type of base-object:
(define-object box-wings (base-object)

  :input-slots(
  
	;Variables from the primi-plnae tutorial:
				root-center
				semi-span
				c-root
				c-tip
				thickness
				dihedral
				
				wing-profile
	;New ones:
				c-kink 
				spanwise-position-kink
				sweep
				MAC_distance_from_root 
				c-MAC 
				MAC_rear_transl
		     )

  :objects(

;Wings are of type box-wing, similarly to the primi-plane example as a sequence of 2 objects:
	(wings :type 'box-wing
		   :sequence (:size 2)
		   
;The root center is either at the bottom either at the top of the fuselage structure - depending on the boolean variable,
;See: wing-assembly object in the file airplane*.lisp 

		   :root-point (the root-center)
		  
;An ecase means that the child side should evaluate either to right or left - if not -> an error occurs
		   :side (ecase (the-child index)
										 (0 :right)
										 (1 :left ))

   		   :semi-span		   (the semi-span)	  
		   :c-root             (the c-root)
		   :c-tip              (the c-tip)
		   :thickness          (the thickness)
		   :wing-profile  	   (the wing-profile)

;New ones:
		   :sweep 		  	   		(the sweep)
		   :c-kink 		  	   		(the c-kink)
	       :MAC_distance_from_root  (the MAC_distance_from_root)
	       :c-MAC 		  	   		(the c-MAC)
	       :MAC_rear_transl 	  	(the MAC_rear_transl)
	       :spanwise-position-kink 	(the spanwise-position-kink)
		   
;Left wing will get a left-handed coordinate system and be a mirror of the right one
;Local variables binding by means of let* - therefore the second one (right) can depend on the first one (hinge)
;List of binding is very similar to computed slots, variable name--> value, here we are binding the hinge to be the face normal 
;An ecase means that the child side should evaluate either to right or left - if not -> an error occurs
;Therefore based on the child side we are establishing a hinge: 

;With a right hand pointing a thumb in the direction of the hinge - for the right hand the hinge is the FRONT vector:

		  :orientation (let* ((hinge (the (face-normal-vector 
															(ecase (the-child side)
																					(:right :front)
																					(:left  :rear )))))
							  (right (rotate-vector-d (the (face-normal-vector 
								     (the-child side)))
							         (the dihedral)
								      hinge)))

;Left handed coordinate system change is directly affected by ':right left' (the right face of the reference box goes along the left vector 
;(sth close to the left global vector)): 
				     (alignment
							:right right
							
;Top face is a result of crossing that hinge with the right vector:
 							:top (cross-vectors hinge right)
							:front (the (face-normal-vector :front))
					 ))
		))
		
;end of box-wings object:
)

;------------------------------------------------------------------------------------------					
;One wing:
;The box-wing itself contains hidden child objects and child ojects
;Based on the object of type box as in the primi-plane example 
					
(define-object box-wing (box)

  :input-slots(
				root-point
				side
				semi-span
				c-root
				c-tip
				thickness
				
				wing-profile
		
				sweep 
				spanwise-position-kink 
				c-kink
				
				MAC_distance_from_root 
				c-MAC 
				MAC_rear_transl
			   ) 
			   
;the dimensions of the box are based on the convention in the box object type (we are mixing-in box here, see: primi-plane):
  :computed-slots(
					(width  (the semi-span))
					(length (the c-root))
					(height (the thickness))

;Putting center of the box-wing in the half of the half-span so that it ends up with its root in the middle of the fuselage (simplification)
;It simply takes the root point from the center of the fuselage and translates it in the spanwise direction by half the semi-span (here: the width)
;MORE IMPORTANTLY: for both of the wings, the face-normal-vector right is pointing outwards, irrespectively of the fact whether it is right or left wing
					
					(center (translate-along-vector
							(the root-point)
							(the (face-normal-vector :right))
							(half (the width))))
				 )
			   
  :hidden-objects(
		
		(box 
			 :type 'box
		)

;Root profile determined exactly the same as in the primi-plane:
	    (root-profile 
			 :type   'boxed-curve
			 
			 :curve-in (the wing-profile)
			 
			 :scale-x (/ (the c-root) (the wing-profile chord))
			 :scale-y (/ (the thickness) (the wing-profile max-thickness))
			 
			 :center (the (edge-center :left :front))
			 
			 :orientation (alignment :top  (the (face-normal-vector :right))
									 :right(the (face-normal-vector :rear ))
									 :rear (the (face-normal-vector :top  )))
		)

	    (tip-profile  
			 :type   'boxed-curve
			 
			 :curve-in (the wing-profile)
			 
			 :scale-x (/ (the c-tip) (the wing-profile chord))
			 :scale-y (/ (the thickness) (the wing-profile max-thickness))

;How much the tip profile is BACK - depends on the leading-edge-sweep angle
;The orientation is maintained the same for the both kink and tip:			 
			 :center (translate (the (edge-center :right :front))
					    :rear (* (the semi-span) (tan (* (the sweep) (/ pi 180))) ) )
					    
			 :orientation (the root-profile orientation)
		)

	   (kink-profile  
			 :type   'boxed-curve
			 
			 :curve-in (the wing-profile)
			 
			 :scale-x (/ (the c-kink) (the wing-profile chord))
			 :scale-y (/ (the thickness) (the wing-profile max-thickness))
			 
			 :center (translate (the (edge-center :left :front))
							:right (* (the spanwise-position-kink) (the semi-span))
							:rear  (- (the c-root)(the c-kink)))
			 
			 :orientation (the root-profile orientation)
		)
				  )

;To graphically show the MAC - a boxed curve is introduced, defined similarly to root, kink and tip profile:
:objects(
	    (MAC 
			:type   'boxed-curve
			
			:curve-in (the wing-profile)
			
			:scale-x  (/ (the c-MAC) (the wing-profile chord))
			:scale-y  (/ (the thickness) (the wing-profile max-thickness))
			 
			:center   (translate (the (edge-center :left :front))
							:right (the MAC_distance_from_root)
							:rear  (the MAC_rear_transl))
						
			:orientation (the root-profile orientation)
			
			:display-controls (list :color :red
									:line-thickness 1
							  )
		)

;Internal and external wing - defined as two lofted surfaces:
	   (loft-inner 
			:type 'lofted-surface 			 
			:end-caps-on-brep? t
		    
			:curves (list 
						(the root-profile)
						(the kink-profile)
					)
		    
			:display-controls (list :color :green
									:transparency 0.5
									:line-thickness 0.1))
			 
	   (loft-outer
			:type 'lofted-surface
		    :end-caps-on-brep? t
		    
			:curves (list 
						(the kink-profile) 
						(the tip-profile)
					)
			
			:display-controls (list :color :orange
									:transparency 0.5
									:line-thickness 0.1)
		)
		
		))



		
; Bear in mind that unlike in the primi-plane - we have to use CST coeff.
; Moreover, the file cannot be prepareed, no colons etc
;It is perfectly legitimate to MIX-IN fitted curve here to spline the points (therefore profile-curve is of type 'fitted-curve'):

;dru
(define-object profile-curve (fitted-curve)

;'points' are the coordinate points in a cartesian form
;coordinats object of type CST generator takes an input from CST coefficients
;directly from the file by means of with-open-file (see: input-slots for aircraft.lisp)

;because we use fitted-curve as a mix-in - we are passing it directly from the parent:
  :input-slots (points)

  :computed-slots (

;here, most and least are simple lisp functions (see: primi-plane): 
		   (x-max (most  'get-x (the points)))
		   (x-min (least 'get-x (the points)))

;chord length calculated as a distance between the last and first point in the coordinates
		   (chord (- (get-x (the x-max)) 
					 (get-x (the x-min))))
					 
;similarly to x direction, it can be applied to vertical dir. of the profile:		   		   
		   (y-max (most  'get-y (the points)))
		   (y-min (least 'get-y (the points)))
		   
;distance between the upper and lower surface based on the coordinate points obtained from CST coefficients:		   
		   (max-thickness (- (get-y (the y-max))
				             (get-y (the y-min))))
				  )
)