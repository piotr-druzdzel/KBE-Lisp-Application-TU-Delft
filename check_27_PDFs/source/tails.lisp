; TAIL stuff:

;0 conventional
;1 T - tail
;2 cruciform
;3 V - tail
;4 C - tail
;5 H - tail


;H and C tail configuration:

(define-object H_and_C-tail (box-wings-tail) 

:input-slots
(
  fin-span 
  fin-sweep 
  fin-c-root 
  fin-c-tip 
  fin-thickness
			 
  fin-root-center 
  
  MAC_VT_distance_from_center
  MAC_VT
  
tail-type											
tail-c-root 
tail-sweep 
tail-c-tip 
tail-thickness
tail-dihedral
tail-semi-span
	
)


:objects
(
	(fin
		:type 'box-wing-tail-fin
		
;number of fins depends on the tail-type, this object is active only when tail type is C or H so only those cases are considered below:
		:sequence (:size (ecase (the tail-type)
										(4 2) ;;C-tail - case 4 -> 2 fins
										(5 4) ;;H-tail - case 5 -> 4 fins
						 )
				  )
;verical translation of the sideway fins' root points:
		:fin-root-point (translate (the fin-root-center) 
						:top (* (sin (* (/ pi 180) (the tail-dihedral))) (the tail-semi-span))
					)
		
		:fin-span 					 (the fin-span)
		:fin-c-root 				 (the fin-c-root)
		
		:tail-type 					 (the tail-type)	
		:tail-semi-span 			 (the tail-semi-span)
		
		:fin-c-tip 					 (the fin-c-tip)
		:fin-sweep 					 (the fin-sweep)
		:fin-thickness 				 (the fin-thickness)
	
		:MAC_VT_distance_from_center (the MAC_VT_distance_from_center)
		:MAC_VT 					 (the MAC_VT)
		
		:fin_number 				(the-child index)
		:tail-dihedral 				(the tail-dihedral)
		
		
		:orientation (ecase (the-child index) 	(0 (alignment :right (the (face-normal-vector :top))		;right side - upper one
															  :top   (the (face-normal-vector :left)))) 
												
												(1 (alignment :right (the (face-normal-vector :top))		;left side - upper one
															  :top   (the (face-normal-vector :left))))
												
												(2 (alignment :left   (the (face-normal-vector :top))		;left side - lower one
															  :bottom (the (face-normal-vector :left))))
												
												(3 (alignment :left   (the (face-normal-vector :top))		;right side - lower one
															  :bottom (the (face-normal-vector :left))))
					)
	)

;end of objects:	
)

;end of H_and_C-tail object:
)



;Conventional, T-tail, cruciform and V-tail work with this, note that we are mixing-in box-wing-tail !!!
(define-object box-tail (box-wings-tail)
  :input-slots 
(
  fin-span 
  fin-sweep 
  fin-c-root 
  fin-c-tip 
  fin-thickness
			 
  fin-root-center 
  
  MAC_VT_distance_from_center
  MAC_VT MAC_HT_distance_from_center 
  
  tail-type
  
)

  :computed-slots () 


  :objects
(
(fin 
	:type 'box-wing-tail-fin
	
	:tail-type (the tail-type)
	
	:hidden? (if (eql 3 (the tail-type)) 
										t
										nil
			 )
	
	:fin-root-point 				 (the fin-root-center)
	
	:fin-span 						 (the fin-span) ;; <-- :span (the fin-span) = :fin-span (the fin-span) - depends on the definition in box-wing-tail-fin only!
 	:fin-c-root 					 (the fin-c-root)
	
	:fin-c-tip 						 (the fin-c-tip)
	:fin-sweep 						 (the fin-sweep)
	:fin-thickness 					 (the fin-thickness)
	
	:MAC_VT_distance_from_center (the MAC_VT_distance_from_center)
	:MAC_VT 					 (the MAC_VT)	
	
	:orientation (alignment  :right (the (face-normal-vector :top))     ;if face-normal-vector is to the :BOTTOM - it points downwards (like in some drones) 
							 :top   (the (face-normal-vector :left))    ;if face-normal-vector is to the :RIGHT  - the sweep is in the opposite direction 
				 )
;end of fin:
)
)

)



 
(define-object box-wing-tail-fin (box)

  :input-slots 
(
fin-root-point 
side 
fin-span

fin-c-root 
fin-sweep 
fin-c-tip 
fin-thickness
 
tail-dihedral

fin-profile  

MAC_VT_distance_from_center 
MAC_VT 

tail-type

tail-semi-span

fin_number
)
  
  :computed-slots 
(
	(width  (the fin-span))
	(length (the fin-c-root))
	(height (the fin-thickness))

	
;the center of the fin must strictly depend on the type of tail
;for case 0 - conventional, case 1 - T-tail, case 2 - cruciform, case 3 - V-tail it will be standard - thus center of the box will be half the fin-span

;the fin-span is passed to :span in the 'fin which is a child object of 'box-tail which is mixing-in 'box-wings-tail
;'fin is of type 'box-wing-tail-fin 

;the root-point is in the fin-root-center:
	(center  
			(ecase (the tail-type)
			
			(0 (translate-along-vector (the fin-root-point)
									   (the (face-normal-vector :right))
									   (half (the width))) )									;vertically by half the fin span
									 
			(1 (translate-along-vector (the fin-root-point)
									   (the (face-normal-vector :right))
									   (half (the width))) )						 
									 
			(2 (translate-along-vector (the fin-root-point)
									   (the (face-normal-vector :right))
									   (half (the width))) )
			
			(3 (translate-along-vector (the fin-root-point)											;it is a V-tail so no fin is visible
									   (the (face-normal-vector :right))
									   (half (the width))) )
									 
;;C-tail: translation of the box center by half the tail-semi-span spanwisely and vertically depending on the child number:									 
			(4 (translate (the fin-root-point)
											:right  (half (the width))
											:top    (the H_and_C-spanwise-translation) ) )
									 
;;H-tail: translation of the box center by half the tail-semi-span:									 
			(5 (translate (the fin-root-point)
											:right  (half (the width))							;vertically at the tail tips
											:top    (the H_and_C-spanwise-translation) ) )		;spanwisely
			)						 
	) 

	
	
;in case (4) - C-tail or (5) - H-tail, the spanwise translation of the fin centers:	

(H_and_C-spanwise-translation
								(ecase (the fin_number)
								
											(0 		 (* (cos (* (/ pi 180) (the tail-dihedral))) (the tail-semi-span)) ) 	;right side, up
												
											(1 (* -1 (* (cos (* (/ pi 180) (the tail-dihedral))) (the tail-semi-span))) )	;left side, up
														
											(2 		 (* (cos (* (/ pi 180) (the tail-dihedral))) (the tail-semi-span)) ) 	;left side, down  (left handed)
												
											(3 (* -1 (* (cos (* (/ pi 180) (the tail-dihedral))) (the tail-semi-span))) )	;right side, down (left handed)
								)
)	
	

	
;end of computed slots:	
)


  :hidden-objects 
(
(box 
	:type 'box		
)

(fin-root-profile
		    :type 'boxed-curve
		    
			:curve-in (the fin-profile)
			
		    :scale-y (/ (the fin-thickness) (the fin-profile max-thickness))
		    :scale-x (/ (the fin-c-root) (the fin-profile chord))
		    
			:center (the (edge-center :left :front))
		    
			:orientation (alignment :top   (the (face-normal-vector :right))
									:right (the (face-normal-vector :rear))
									:rear  (the (face-normal-vector :top))))

(fin-tip-profile 
			:type 'boxed-curve
			
			:curve-in (the fin-profile)
			:scale-y (/ (the fin-thickness) (the fin-profile max-thickness))
			:scale-x (/ (the fin-c-tip) (the fin-profile chord))

;;according to the sweep given at the input, the rear translation of the (center?) of the tip:
			:center (translate (the (edge-center :right :front))
						   :rear (* (tan(* (the fin-sweep) (/ pi 180))) (the fin-span)))						;later on: fin-span
			
			:orientation (the fin-root-profile orientation)))

  :objects 
(
(fin-MAC 
		:type 'boxed-curve
		
		:curve-in (the fin-profile)
		:scale-y (/ (the fin-thickness) (the fin-profile max-thickness))
		:scale-x (/ (the MAC_VT) (the fin-profile chord))				
	    
		:orientation (the fin-root-profile orientation)
	    
		:center (translate (the (edge-center :left :front))
						:right (the MAC_VT_distance_from_center)
						:rear  (* (tan (* (the fin-sweep) (/ pi 180))) (the MAC_VT_distance_from_center)))
	    
		:display-controls (list :color :red 
								:line-thickness 1
						  )
)
	    
(fin-loft 
		:type 'lofted-surface
		:end-caps-on-brep? t
		:display-controls   (list :color :orange
								  :transparency 0.2
								  :line-thickness 0.1
							)
		:curves (list (the fin-root-profile) (the fin-tip-profile))
)

)
)





(define-object box-wings-tail (base-object) ;same as box-wings but now its objects are of type box-wing-tail
  
  :input-slots 
(  
  tail-root-center 
  tail-semi-span 
  tail-c-root 
  tail-sweep 
  tail-c-tip 
  tail-thickness
 
  tail-dihedral

  tail-profile 
  
  MAC_HT_distance_from_center 
  MAC_HT 
  
)
  
  :objects
(
(wings 
	  :type 'box-wing-tail

	  :sequence 	(:size 2)  
	  :tail-root-point 	(the tail-root-center)
	  :side 		(ecase (the-child index) (0 :right) (1 :left))
	  
	  :tail-sweep 		(the tail-sweep)
	  :tail-semi-span 	(the tail-semi-span)
	  :tail-c-root 		(the tail-c-root)
	  :tail-c-tip 		(the tail-c-tip)
	  :tail-thickness 	(the tail-thickness)
	  
	  :tail-profile 	(the tail-profile)
	  
	  :MAC_HT_distance_from_center (the MAC_HT_distance_from_center)
	  :MAC_HT 					   (the MAC_HT)
	  
;; Left wing will get a left-handed coordinate system and be a mirror of the right.
	  
	  :orientation (let* ((hinge (the (face-normal-vector (ecase (the-child side)
								 (:right :front)
								 (:left :rear)))))
						  
						  (right (rotate-vector-d (the (face-normal-vector (the-child side)))
																			(the tail-dihedral)
																			 hinge)
						  ))
			 
					(alignment  :right right
								:top (cross-vectors hinge right)
								:front (the (face-normal-vector :front))
					)
					)
)
)
)




;similarly to box-wing object for the wing (mixing-in 'box):

(define-object box-wing-tail (box) 

  :input-slots 
(
tail-root-point 
side
 
tail-semi-span 
tail-sweep
tail-c-root  
tail-c-tip 
tail-thickness

tail-profile 

MAC_HT_distance_from_center 
MAC_HT 
)
  
  :computed-slots 
(
(width  (the tail-semi-span))
(length (the tail-c-root))
(height (the tail-thickness))

;wingbox center itself is in the middle of the wing in the spanwise direction:
(center (translate-along-vector (the tail-root-point)
												(the (face-normal-vector :right))
												(half (the width))
		)
)
;end of computed slots:
)

  :hidden-objects 
(
(box 
	:type 'box
)

(tail-root-profile
		    :type 'boxed-curve
		    
			:curve-in (the tail-profile)
			
		    :scale-y (/ (the tail-thickness) (the tail-profile max-thickness))
		    :scale-x (/ (the tail-c-root) (the tail-profile chord))
		    
			:center (the (edge-center :left :front))
		    
			:orientation (alignment :top   (the (face-normal-vector :right))
									:right (the (face-normal-vector :rear))
									:rear  (the (face-normal-vector :top))))

(tail-tip-profile 
			:type 'boxed-curve
			
			:curve-in (the tail-profile)
			
			:scale-y (/ (the tail-thickness) (the tail-profile max-thickness))
			:scale-x (/ (the tail-c-tip) (the tail-profile chord))
			
			:center (translate (the (edge-center :right :front))
						   :rear (* (tan(* (the tail-sweep) (/ pi 180))) (the tail-semi-span)))
			
			:orientation (the tail-root-profile orientation)))

  :objects 
(
(tail-MAC 
		:type 'boxed-curve
		
		:curve-in (the tail-profile)
		
		:scale-y (/ (the tail-thickness) (the tail-profile max-thickness))
		:scale-x (/ (the MAC_HT) (the tail-profile chord))				
		
		:center (translate (the  (edge-center :left :front))
					 :rear (* (tan (* (the tail-sweep) (/ pi 180))) (the MAC_HT_distance_from_center))
					 :right (the MAC_HT_distance_from_center))
		
		:display-controls (list :color :red
								:line-thickness 1
						  )

		:orientation (the tail-root-profile orientation)
)		    

(tail-loft 
		:type 'lofted-surface
		:end-caps-on-brep? t
		:display-controls  (list :color :green
								 :transparency 0.5
								 :line-thickness 0.1)
		:curves (list (the tail-root-profile) 
					  (the tail-tip-profile)
				)
)
)
)