(in-package :gdl-user)

(define-object analysis-coordinate-writer (base-object) 
  
  :input-slots
  (curve-in 
   coords
   data-folder 
   input-file 
   (no-of-sample-points 120))
  
   :computed-slots
   ((LE-parameter (get-parameter-of (getf (the curve-in (minimum-distance-to-curve (the line-intersect))) :point-on-curve)))
    (coordinate-points  (if (eql (the curve-in) nil) 
					      (if (eql (the coords) nil) 
						  nil 
						(the coords))  
					    (mapcar #'(lambda (m) (list (get-x m) (get-y m)))
						    (concatenate 'list (reverse (the points-down-wind sample-points-list))
								 (cdr (the points-up-wind sample-points-list)  )))))				    
    (write-coordinate-file (the write-points))
    (data-path (merge-pathnames (the input-file) (the data-folder))) )
   
   :objects 
   ((line-intersect :type 'linear-curve
		    :hidden? nil
		    :start (make-point -0.5 0.5 0) 
		    :end   (make-point -0.5 -0.5 0))
   
    (trimmed-up :type 'trimmed-curve 
		:hidden? nil
		:built-from (the curve-in)
		:u1 (the curve-in u1)
		:u2 (the LE-parameter))
   
    (trimmed-down :type 'trimmed-curve 
		  :hidden? nil
		  :built-from (the curve-in)
		  :u1 (the LE-parameter)
		  :u2 (the curve-in u2))
   
    (points-down-wind :type 'my-airfoil-curve
		      :hidden? nil
		      :display-controls (list :color :red)
		      :curve-in (the trimmed-down)
		      :number-of-sample-points (/ (the no-of-sample-points) 2))
        
    (points-up-wind :type 'my-airfoil-curve
		    :hidden? nil
		    :display-controls (list :color :green)
		    :curve-in (the trimmed-up)
		    :number-of-sample-points (/ (the no-of-sample-points) 2)
		    :reverse? t))

   :functions
   ((write-points ()
		  (with-open-file (out (the data-path)
				   :direction :output
				   :if-exists :supersede
				   :if-does-not-exist :create)
		    (format out "STEADY FLOW TEST DATA~%")
		    (dolist (point (the coordinate-points))
		      (format out "    ~,6f    ~,6f~%" (first point) (second point)))))))


