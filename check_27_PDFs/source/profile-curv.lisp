;----------------------------------------
; -  Delft University of Technology     -
; -  Teodor-Gelu CHICIUDEAN             -
; -  PhD researcher                     -
; -  Design, Integration and Operation  -
; -  of Aircraft and Rotorcraft (DAR)   -
; -  Faculty of Aerospace Engineering   -
; -  Delft University of Technology     -
; -  Kluyverweg 1 2629 HS Delft         -
; -  Tel. : +31 (0)15 278 7158          -
; -  Mob. : +31 (0) 618892495           -
; -  e-mail : T.G.chiciudean@tudelft.nl -
;----------------------------------------
(in-package :gdl-user)

(define-object my-airfoil-curve (curve)
	  
  :input-slots 
  ((points nil)
   (curve-in nil)
   (number-of-sample-points)
   (fit? t)
   (reverse? nil)
   (phase-offset (* pi 0.0))
   (angle-interval-length  (* pi 1))
    )
	 
  :computed-slots 
  ((built-from (the fitted))
   
   (%curve-in (cond ((the curve-in) (the curve-in))
		    ((the points) (the fitted-in))
		    (t (error "In profile-curve, you must specify either curve-in or points"))))
   
   (total-length (the %curve-in total-length))
   
   (interval (/ (the total-length) (the number-of-sample-points)))
   
   (pi-factor (/ (the angle-interval-length) (the number-of-sample-points)))
   
   (sample-points-list (remove-duplicates (list-elements (the sample-points) (the-element center)) :test #'coincident-point?))
   )

  :objects 
  ((fitted-in :type (if (the points) 'curve_fitcae 'null-part)
	      :hidden? t
	      :tolerance 0.000001
	      :points (the points))
  
   (fitted :type 'b-spline-curve
	   :hidden? t
	   :control-points (the sample-points-list)
	   :degree 1
	   :tolerance 0.000001)
	   

   (sample-points :type 'sample-point
		  :hidden? nil
		  :sequence (:size (the number-of-sample-points))
		  :distance			
		  
		  (if (eq (the reverse?) t)
		      
		      (if (the-child first?) 
			  (the total-length)
			(if (the-child last?) 0 
			  (let ((increment
				 (* (the interval)
				    (- 1 (cos (+ (* (the pi-factor) (the-child index)) (the phase-offset)))))))
			    (- (the-child previous distance) increment))))
		      
		    (if (the-child first?) 0
		      (if (the-child last?) (the total-length) 
			(let ((increment
			       (* (the interval)
				  (- 1 (cos (+ (* (the pi-factor) (the-child index)) (the phase-offset)))))))
			  (+ increment (the-child previous distance))))))
		  
		  :center (the %curve-in
			    (point (the %curve-in (parameter-at-length (the-child distance))))))))



#+nil
( :center (let* ((reverse (the %curve-in reverse))
		 (parameter (the-object reverse (parameter-at-length (the-child distance)))))
	    (print-variables parameter)
	    (the-object reverse (point parameter))))


(define-object sample-point (point)
  :input-slots (distance))
