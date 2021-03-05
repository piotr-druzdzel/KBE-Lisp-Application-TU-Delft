(in-package :gdl-user)

(define-object xfoil-analysis-polar ()
  
  ;;Intended for analysis and output of polar -> calculates range of alpha's
  
  :input-slots
  (curve-in
   data-folder
   (input-file "coord.dat")
   (mach-number 0.7)
   (reynolds-number 6000000)
   (no-panels 200)
   (lower-alfa -4)
   (upper-alfa 14)
   (alfa-increment 0.5)
   )
  
  :computed-slots
  ((clear-folder (ignore-errors (progn
				  (delete-file (merge-pathnames (the data-folder) (the input-file))) 
				  (delete-file (merge-pathnames (the data-folder) (the output-file1)))
				  (delete-file (merge-pathnames (the data-folder) (the output-file2))))))
   
   (xfoil-results 
    
    (progn
      (the clear-folder)
      (the write-coord-file)
      (excl.osi:command-output (format nil "~axfoil.exe" (the data-folder))
			       :directory (the data-folder)
			       :input (format nil "load~%~a~%gdes~%unit~%dero~%~%ppar~%N~%~a~%~%~%~%oper~%visc~%~a~%mach~%~a~%iter~%100~%seqp~%pacc~%~a~%~a~%aseq~%~a~%~a~%~a~%quit~%" 
					      (the input-file) 
					      (the no-panels)
					      (the reynolds-number)
					      (the mach-number)
					      (the output-file1)
					      (the output-file2)
					      (the lower-alfa)
					      (the upper-alfa)
					      (the alfa-increment)
					      ))))
   
   (write-coord-file (the coord-points write-coordinate-file))
   (output-file1 (format nil "out1-~a" (the input-file)))
   (output-file2 (format nil "out2-~a" (the input-file)))
   (output-data (progn (the xfoil-results) (the (read-points (merge-pathnames (the data-folder) (the output-file1))))))
   (alfa (mapcar #'(lambda (line) (nth 0 line)) (the output-data)))
   (cl (mapcar #'(lambda (line) (nth 1 line)) (the output-data)))
   (cd (mapcar #'(lambda (line) (nth 2 line)) (the output-data)))
   (cdp (mapcar #'(lambda (line) (nth 3 line)) (the output-data)))
   (cm (mapcar #'(lambda (line) (nth 4 line)) (the output-data)))
   (x-tr-top (mapcar #'(lambda (line) (nth 5 line)) (the output-data)))
   (x-tr-bot (mapcar #'(lambda (line) (nth 6 line)) (the output-data)))
   
   (CL-alfa (list (mapcar #'(lambda (m n) (list m n)) (the alfa) (the cl))))
   (CL-CD (list (mapcar #'(lambda (m n) (list m n)) (the cd) (the cl))))
   (CL-CM (list (mapcar #'(lambda (m n) (list m n)) (the cl) (the cm))))
   (Xtr-t-alfa (list (mapcar #'(lambda (m n) (list m n)) (the alfa) (the x-tr-top))))
   (Xtr-b-alfa (list (mapcar #'(lambda (m n) (list m n)) (the alfa) (the x-tr-bot))))
   )
  
  :functions
  ((read-points (file-name)
		(with-open-file (in file-name)
		  (let (result)
		    (do ((count 1 (1+ count))
			 (line (read-line in nil nil)
			       (read-line in nil nil) ))
			((or (null line) (string-equal line "")) (nreverse result))
		      (let ((xyz-list (if (< count 5) nil (read-from-string (string-append "(" line ")")))    ))
			(when (and (= (length xyz-list) 7)
				   (every #'numberp xyz-list))
			  (push xyz-list result))))))))
   

  
  :objects
  ((coord-points :type 'analysis-coordinate-writer
		 :curve-in (the curve-in)
		 :data-folder (the data-folder)
		 :input-file (the input-file)
		 :no-of-sample-points 100)
   
   #+nil(CL-alpha-plot :type '2D-aero-plot
		  :input-polars (the CL-alfa) 
		  :var-list (list "alpha" "CL")
		  :mach-number (the mach-number)
		  :reynolds-number (the reynolds-number)
		  :var-1-line-scale-ratio 3
		  :var-2-line-scale-ratio 30
		  :var-1-line-step 2 
		  :var-2-line-step 0.1)
   
   (CL-alpha-plot :type 'gdl-user::diagram
		  :input (the CL-alfa) 
		  :x-label "alpha"
		  :y-label "Cl")
   
   #+nil(CL-CD-plot :type '2D-aero-plot
	       :input-polars (the CL-CD) 
	       :var-list (list "CD" "CL")
	       :mach-number (the mach-number)
	       :reynolds-number (the reynolds-number)
	       :var-1-line-scale-ratio 2500
	       :var-2-line-scale-ratio 30
	       :var-1-line-step 0.002
	       :var-2-line-step 0.1)
   
   (CL-CD-plot :type 'gdl-user::diagram
		  :input (the CL-CD) 
		  :x-label "Cd"
		  :y-label "Cl")
   
   #+nil(CL-CM-plot :type '2D-aero-plot
               :input-polars (the CL-CM)
               :var-list (list "CL" "CM")
               :mach-number (the mach-number)
               :reynolds-number (the reynolds-number)
               :var-1-line-scale-ratio 10
               :var-2-line-scale-ratio 75
	       :var-1-line-step 2 
	       :var-2-line-step 0.1)
   
   (CL-CM-plot :type 'gdl-user::diagram
		  :input (the CL-CM) 
		  :x-label "Cl"
		  :y-label "Cm")
   
   #+nil(Xtr-alfa-plot :type '2D-aero-plot
		  :input-polars (append (the Xtr-t-alfa) (the Xtr-b-alfa))
		  :var-list (list "alpha" "Xtrans")
		  :mach-number (the mach-number)
		  :reynolds-number (the reynolds-number)
		  :var-1-line-scale-ratio 3
		  :var-2-line-scale-ratio 30
		  :var-1-line-step 2 
		  :var-2-line-step 0.1)
   
   (Xtr-alfa-plot :type 'gdl-user::diagram
		  :input (append (the Xtr-t-alfa) (the Xtr-b-alfa))
		  :x-label "alpha"
		  :y-label "Xtr")
   
  
  #+nil(Cl-alpha :type 'fitted-curve
	    :points (mapcar  #'(lambda (param-list) (make-point (first param-list) (* 10 (second param-list)) 0)) (the output-data))
	    :degree 1)

   #+nil(Cd-Cl :type 'fitted-curve
	  :points (mapcar  #'(lambda (param-list) (make-point (* 10 (third param-list)) (second param-list) 0)) (the output-data))
	  :degree 1)
   
   #+nil(Cm-alpha :type 'fitted-curve
	    :points (mapcar  #'(lambda (param-list) (make-point (first param-list) (* 10 (fifth param-list)) 0)) (the output-data))
	    :degree 1)
   
   #+nil(Xtr-top-alpha :type 'fitted-curve
		 :points (mapcar  #'(lambda (param-list) (make-point (first param-list) (* 10 (sixth param-list)) 0)) (the output-data))
		 :degree 1)
   
   #+nil(Xtr-bot-alpha :type 'fitted-curve
		 :points (mapcar  #'(lambda (param-list) (make-point (first param-list) (* 10 (seventh param-list)) 0)) (the output-data))
		 :degree 1) ))
