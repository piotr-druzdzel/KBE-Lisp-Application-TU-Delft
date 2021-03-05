(define-object fuselage-object (cylinder)

  :input-slots (
				d  							;diameter
				l  							;length 
				cross-section-percents		;spacing of the cross-section curves
				cross-section-clearance		;clearance for the tail section (mainly for take-off cond.)
			   )

  :computed-slots ((radius (half (the d)))   ;radius of the fuselage section
				   (length       (the l))    ;length of the fuselage

;"cross-section-percents" is a plist (a list of paired elements) from which the first column will be used as 'keys' 
;to distiguish position in the fuselage (plist-keys is standard lisp function - see the main airplane.lisp file):
(section-offset-percentages (plist-keys (the cross-section-percents))) 

;aft part of the fuselage - see primi-plane:		                                                                          
(section-centers (let ((aft-part (the (face-center :front))))
				      
;taking into account clearance of the aft part of the fuselage with an (undefined) lambda function:
					  (mapcar #'(lambda (percentage clearance)
								(translate aft-part 
;the percentage of the length is translate to the rear (see: primi-plane)
								 :rear
							     (* percentage 1/100 ;row of the list "cross-section-percents"
								 (the length))
;the clearance is translated to the top (upwards along the z axis):
							     :top clearance))
					             (the section-offset-percentages) (the cross-section-clearance)
					  )
				 )
)

;again, the "cross-section-percents" list's second column can be gicen as: (see: primi-plane)
(section-diameter-percentages (plist-values (the cross-section-percents))) 

;scales the base radius to the percentages set in the second column of the "cross-section-percents"
(section-radii (mapcar #'(lambda(percentage) 
					      (* 1/100 percentage (the radius)))
					      (the section-diameter-percentages))))

;specifying the section curves for the lofted surace of the fuselage:
  :hidden-objects ((section-curves
		    :type 'arc-curve
		    :sequence (:size (length (the section-centers)))
		    :center (nth (the-child index) (the section-centers))
		    :radius (nth (the-child index) (the section-radii))
		    :orientation (alignment :top (the (face-normal-vector :rear)))))

;from the primi-plane example, a lofted-surface is a surface through a list of curves which here are specified as fuselage cross-section (circles):
  :objects(
	   (loft 
			:type 'lofted-surface
			:end-caps-on-brep? t		;A closed shell forms a region.
										;A brep can have zero or more shells and one or more regions
										;There is always the infinite region (all of space outside the brep)
		 
			:curves (list-elements (the section-curves)))) ;note that section-curves itself is a hidden object
  )
  
  