(in-package :gdl-user)

(define-object xfoil-analysis-pointBL ()
  
  ;;Intended for analysis and output single operating point (w.r.t. Re, M, alpha -> outputs Cp and Boundary Layer parameters
  
  :input-slots
  (curve-in
   data-folder
   (input-file "coord.dat")
   (mach-number 0)
   (reynolds-number 6000000)
   (alfa-in 7 :settable)
   (no-panels 200))
  
  :computed-slots
  ((clear-folder (ignore-errors (progn
		   (delete-file (merge-pathnames (the data-folder) (the input-file))) 
		   (delete-file (merge-pathnames (the data-folder) (the output-file1)))
		   (delete-file (merge-pathnames (the data-folder) (the output-file2)))
		   (delete-file (merge-pathnames (the data-folder) (the output-file-BL)))
		   (delete-file (merge-pathnames (the data-folder) (the output-file-Cp)))
		   (delete-file (merge-pathnames (the data-folder) (the output-file-H)))
		   (delete-file (merge-pathnames (the data-folder) (the output-file-Cf)))
		   (delete-file (merge-pathnames (the data-folder) (the output-file-N))))))
				   
   
   (xfoil-results 
    (progn
      #+nil(the clear-folder)
      #+nil(the write-coord-file)
      (excl.osi:command-output (format nil "~axfoil.exe" (the data-folder))
			       :directory (the data-folder)
			       :input (format nil "load
~a
gdes
unit
dero

ppar
N
~a



oper
visc
~a
mach
~a
iter
100
seqp
pacc
~a
~a
alfa
~a
dump
~a
cpwr
~a
vplo
H
dump
~a
CF
dump
~a
N
dump
~a



quit

" (the input-file) (the no-panels) (the reynolds-number) (the mach-number) (the output-file1) (the output-file2) (the alfa-in) (the output-file-BL)  (the output-file-Cp) (the output-file-H) (the output-file-Cf) (the output-file-N) ))))
   
   (write-coord-file (the coord-points write-coordinate-file))
   
   (output-file1 (format nil "out1-~a" (the input-file)))
   (output-file2 (format nil "out2-~a" (the input-file)))
   (output-file-Cf (format nil "out-Cf-~a" (the input-file)))
   (output-file-Cp (format nil "out-Cp-~a" (the input-file)))
   (output-file-H (format nil "out-H-~a" (the input-file)))
   (output-file-N (format nil "out-N-~a" (the input-file)))
   (output-file-BL (format nil "out-BL-~a" (the input-file)))
   
   (output-data-1 (progn (the xfoil-results) (the (read-points-1 (merge-pathnames (the data-folder) (the output-file1))))))
   (output-data-Cf-up (progn (the xfoil-results) (the (read-points-Cf (merge-pathnames (the data-folder) (the output-file-Cf)) :up))))
   (output-data-Cf-low (progn (the xfoil-results) (the (read-points-Cf (merge-pathnames (the data-folder) (the output-file-Cf)) :low))))
   (output-data-Cp (progn (the xfoil-results) (the (read-points-Cp (merge-pathnames (the data-folder) (the output-file-Cp))))))
   
   (output-data-H-up (progn (the xfoil-results) (the (read-points-H (merge-pathnames (the data-folder) (the output-file-H)) :up  ))))
   (output-data-H-low (progn (the xfoil-results) (the (read-points-H (merge-pathnames (the data-folder) (the output-file-H)) :low ))))
   
   (output-data-N-up (progn (the xfoil-results) (the (read-points-N (merge-pathnames (the data-folder) (the output-file-N)) :up ))))
   (output-data-N-low (progn (the xfoil-results) (the (read-points-N (merge-pathnames (the data-folder) (the output-file-N)) :low ))))
   
   (output-data-BL-up (progn (the xfoil-results) (the (read-points-BL (merge-pathnames (the data-folder) (the output-file-BL)) :up))))
   (output-data-BL-low (progn (the xfoil-results) (the (read-points-BL (merge-pathnames (the data-folder) (the output-file-BL)) :low))))
   
   (x-BL-up (mapcar #'(lambda (line) (nth 1 line)) (the output-data-BL-up)))
   (y-BL-up (mapcar #'(lambda (line) (nth 2 line)) (the output-data-BL-up)))
   (s-BL-up (mapcar #'(lambda (line) (nth 0 line)) (the output-data-BL-up)))
   (Ue_Vinf-BL-up (mapcar #'(lambda (line) (nth 3 line)) (the output-data-BL-up)))
   (delta*-BL-up (mapcar #'(lambda (line) (nth 4 line)) (the output-data-BL-up)))
   (theta-BL-up (mapcar #'(lambda (line) (nth 5 line)) (the output-data-BL-up)))
   (H-BL-up (mapcar #'(lambda (line) (nth 7 line)) (the output-data-BL-up)))
   (Cf-BL-up (mapcar #'(lambda (line) (nth 6 line)) (the output-data-BL-up)))
      
   (x-BL-low (mapcar #'(lambda (line) (nth 1 line)) (the output-data-BL-low)))
   (y-BL-low (mapcar #'(lambda (line) (nth 2 line)) (the output-data-BL-low)))
   (s-BL-low (mapcar #'(lambda (line) (nth 0 line)) (the output-data-BL-low)))
   (Ue_Vinf-BL-low (mapcar #'(lambda (line) (nth 3 line)) (the output-data-BL-low)))
   (delta*-BL-low (mapcar #'(lambda (line) (nth 4 line)) (the output-data-BL-low)))
   (theta-BL-low (mapcar #'(lambda (line) (nth 5 line)) (the output-data-BL-low)))
   (H-BL-low (mapcar #'(lambda (line) (nth 7 line)) (the output-data-BL-low)))
   (Cf-BL-low (mapcar #'(lambda (line) (nth 6 line)) (the output-data-BL-low)))

   (x-Ue_Vinf-up (list (mapcar #'(lambda (m n) (list m n)) (the x-BL-up) (the Ue_Vinf-BL-up))))
   (x-delta*-up (list (mapcar #'(lambda (m n) (list m n)) (the x-BL-up) (the delta*-BL-up))))
   (x-theta-up (list (mapcar #'(lambda (m n) (list m n)) (the x-BL-up) (the theta-BL-up))))
   (x-H-up (list (mapcar #'(lambda (m n) (list m n)) (the x-BL-up) (the H-BL-up))))
   (x-Cf-up (list (mapcar #'(lambda (m n) (list m n)) (the x-BL-up) (the Cf-BL-up))))
      
   (x-Ue_Vinf-low (list (mapcar #'(lambda (m n) (list m n)) (the x-BL-low) (the Ue_Vinf-BL-low))))
   (x-delta*-low (list (mapcar #'(lambda (m n) (list m n)) (the x-BL-low) (the delta*-BL-low))))
   (x-theta-low (list (mapcar #'(lambda (m n) (list m n)) (the x-BL-low) (the theta-BL-low))))
   (x-H-low (list (mapcar #'(lambda (m n) (list m n)) (the x-BL-low) (the H-BL-low))))
   (x-Cf-low (list (mapcar #'(lambda (m n) (list m n)) (the x-BL-low) (the Cf-BL-low))))
   
   
   #+nil(alfa (mapcar #'(lambda (line) (nth 0 line)) (the output-data-1)))
   #+nil(cl (mapcar #'(lambda (line) (nth 1 line)) (the output-data-1)))
   #+nil(cd (mapcar #'(lambda (line) (nth 2 line)) (the output-data-1)))
   #+nil(cdp (mapcar #'(lambda (line) (nth 3 line)) (the output-data-1)))
   #+nil(cm (mapcar #'(lambda (line) (nth 4 line)) (the output-data-1)))
   #+nil(x-tr-top (car (last (mapcar #'(lambda (line) (nth 5 line)) (the output-data-1))))) ;;alternate name: x-tr-top-test
   #+nil(x-tr-bot (car (last (mapcar #'(lambda (line) (nth 6 line)) (the output-data-1))))) ;;alternate name: x-tr-bot-test
  
      
   (cp-values (mapcar  #'(lambda (Cf-list) (second Cf-list)) (the output-data-Cp)))
   (cp-min (the (listmin (the cp-values))))
    )
  
  :objects
  ((coord-points :type 'analysis-coordinate-writer
		 :curve-in (the curve-in)
		 :data-folder (the data-folder)
		 :input-file (the input-file)
		 :no-of-sample-points 100)  
   
   #+nil(x-Cp-plot :type '2D-aero-plot
	      :input-polars (list (the output-data-Cp))
	      :var-list (list "x" "Cp")
	      :mach-number (the mach-number)
	      :reynolds-number (the reynolds-number)
	      :var-1-line-scale-ratio 30
	      :var-2-line-scale-ratio 20
	      :var-1-line-step 0.1
	      :var-2-line-step 0.1)
   
   (x-Cp-plot :type 'gdl-user::diagram
	      :input (list (the output-data-Cp))
	      :x-label "x"
	      :y-label "Cp")
	      
   
   #+nil(x-Cf-plot :type '2D-aero-plot
	      :input-polars (append (list (the output-data-Cf-up)) (list (the output-data-Cf-up)))
	      :var-list (list "x" "Cf")
	      :mach-number (the mach-number)
	      :reynolds-number (the reynolds-number)
	      :var-1-line-scale-ratio 30
	      :var-2-line-scale-ratio 3000
	      :var-1-line-step 0.1
	      :var-2-line-step 0.0005)
   
   (x-Cf-plot :type 'gdl-user::diagram
	      :input (append (list (the output-data-Cf-up)) (list (the output-data-Cf-up)))
	      :x-label "x"
	      :y-label "Cf")
   
   #+nil(x-delta*-plot :type '2D-aero-plot
		  :input-polars (append (the x-delta*-up) (the x-delta*-low))
		  :var-list (list "x" "delta*")
		  :mach-number (the mach-number)
		  :reynolds-number (the reynolds-number)
		  :var-1-line-scale-ratio 30
		  :var-2-line-scale-ratio 2000
		  :var-1-line-step 0.1 
		  :var-2-line-step 0.001)
   
   (x-delta*-plot :type 'gdl-user::diagram
		  :input (append (the x-delta*-up) (the x-delta*-low))
		  :x-label "x"
		  :y-label "delta*")
   
   #+nil(x-theta-plot :type '2D-aero-plot
		 :input-polars (append (the x-theta-up) (the x-theta-low))
		 :var-list (list "x" "theta")
		 :mach-number (the mach-number)
		 :reynolds-number (the reynolds-number)
		 :var-1-line-scale-ratio 30
		 :var-2-line-scale-ratio 4000
		 :var-1-line-step 0.1
		 :var-2-line-step 0.001)
   
   (x-theta-plot :type 'gdl-user::diagram
		 :input (append (the x-theta-up) (the x-theta-low))
		 :x-label "x"
		 :y-label "theta")
   
   #+nil(x-H-plot :type '2D-aero-plot
	     :input-polars (append (the x-H-up) (the x-H-low))
	     :var-list (list "s" "H")
	     :mach-number (the mach-number)
	     :reynolds-number (the reynolds-number)
	     :var-1-line-scale-ratio 30
	     :var-2-line-scale-ratio 9
	     :var-1-line-step 0.1
	     :var-2-line-step 0.5)
   
   (x-H-plot :type 'gdl-user::diagram
		 :input (append (the x-H-up) (the x-H-low))
		 :x-label "x"
		 :y-label "H")
   
   #+nil(x-Ue_Vinf-plot :type '2D-aero-plot
		   :input-polars (append (the x-Ue_Vinf-up) (the x-Ue_Vinf-low))
		   :var-list (list "x" "Ue_Vinf")
		   :mach-number (the mach-number)
		   :reynolds-number (the reynolds-number)
		   :var-1-line-scale-ratio 30
		   :var-2-line-scale-ratio 15
		   :var-1-line-step 0.1 
		   :var-2-line-step 0.1)
   
   (x-Ue_Vinf-plot :type 'gdl-user::diagram
		   :input (append (the x-Ue_Vinf-up) (the x-Ue_Vinf-low))
		   :x-label "x"
		   :y-label "Ue_Vinf")
   
   
   #+nil(x-N-plot :type '2D-aero-plot
		   :input-polars (append (list (the output-data-N-up)) (list (the output-data-N-low)))
		   :var-list (list "x" "N")
		   :mach-number (the mach-number)
		   :reynolds-number (the reynolds-number)
		   :var-1-line-scale-ratio 30
		   :var-2-line-scale-ratio 1.5
		   :var-1-line-step 0.1 
		   :var-2-line-step 1)
   
   (x-N-plot :type 'gdl-user::diagram
		   :input (append (list (the output-data-N-up)) (list (the output-data-N-low)))
		   :x-label "x"
		   :y-label "N")
   )
        
  :functions
  ((read-points-1 (file-name)
		  (with-open-file (in file-name)
		    (let (result)
		      (do ((count 1 (1+ count))
			   (line (read-line in nil nil)
				 (read-line in nil nil)))
			  ((or (null line) (string-equal line "")) (nreverse result))
			(let ((xyz-list (if (< count 5) nil (read-from-string (string-append "(" line ")")))    ))
			  (when (and (= (length xyz-list) 7)
				     (every #'numberp xyz-list))
			    (push xyz-list result)))))))
   
   (read-points-Cf (file-name side)
		   (with-open-file (in file-name)
		     (let (result)
		       (do ((count 1 (1+ count))
			    (line (read-line in nil nil)
				  (read-line in nil nil))
			    (UL-check 0 (if (or (null line) (string-equal line "")) (+ 1 UL-check) UL-check)))
			   ((and (or (null line) (string-equal line "")) (= UL-check 2)) (nreverse result))
			 (let ((xyz-list (if (< count 8) nil (read-from-string (string-append "(" line ")"))) ))
			   (when (and (= (length xyz-list) 2)
				      (every #'numberp xyz-list)
				      (<= (first xyz-list) 1)
				      (eq UL-check (case side (:up 0)
							(:low 1))))
			     (push xyz-list result)))))))
   
   (read-points-Cp (file-name)
		  (with-open-file (in file-name)
		    (let (result)
		      (do ((count 1 (1+ count))
			   (line (read-line in nil nil)
				 (read-line in nil nil) ))
			  ((or (null line) (string-equal line "")) (nreverse result))
			(let ((xyz-list (if (< count 2) nil (read-from-string (string-append "(" line ")")))    ))
			  (when (and (= (length xyz-list) 2)
				     (every #'numberp xyz-list))
			    (push xyz-list result)))))))
   
   (read-points-H (file-name side)
		  (with-open-file (in file-name)
		    (let (result)
		      (do ((count 1 (1+ count))
			   (line (read-line in nil nil)
				 (read-line in nil nil))
			  (UL-check 0 (if (or (null line) (string-equal line "")) (+ 1 UL-check) UL-check)))
			   ((and (or (null line) (string-equal line "")) (= UL-check 2)) (nreverse result))
			 (let ((xyz-list (if (< count 8) nil (read-from-string (string-append "(" line ")"))) ))
			   (when (and (= (length xyz-list) 2)
				      (every #'numberp xyz-list)
				      (<= (first xyz-list) 1)
				      (eq UL-check (case side (:up 0)
							(:low 1))))
			     (push xyz-list result)))))))
   
   (read-points-N (file-name side)
		  (with-open-file (in file-name)
		    (let (result)
		      (do ((count 1 (1+ count))
			   (line (read-line in nil nil)
				 (read-line in nil nil))
			   (UL-check 0 (if (or (null line) (string-equal line "")) (+ 1 UL-check) UL-check)))
			   ((and (or (null line) (string-equal line "")) (= UL-check 2)) (nreverse result))
			 (let ((xyz-list (if (< count 8) nil (read-from-string (string-append "(" line ")"))) ))
			   (when (and (= (length xyz-list) 2)
				      (every #'numberp xyz-list)
				      (<= (first xyz-list) 1)
				      (eq UL-check (case side (:up 0)
							(:low 1))))
			     (push xyz-list result)))))))
			  
   
 (read-points-BL (file-name side)
		      (with-open-file (in file-name)
			(let (result)
			  (do ((count 1 (1+ count))
			       (line (read-line in nil nil)
				     (read-line in nil nil) )
			       )						      
			      ((or (null line) (string-equal line "")) (nreverse result))
			    
			    (let* ((xyz-list (if (< count 2) (list 1 1 1) (read-from-string (string-append "(" line ")"))) )
				  (UL-check (if (< (third xyz-list) 0) 1 0)))
				  (when (and (= (length xyz-list) 8)
					 (every #'numberp xyz-list)
					 (eq UL-check (case side (:up 0)
							    (:low 1))))
				(push xyz-list result))
				  ))))) ) 
  
  :functions
  ((listmin (list)
  (let ((min (nth 0 list)))
    (dolist (elem list min)
      (if (< elem min)
	  (setq min elem))))))
  
  )
