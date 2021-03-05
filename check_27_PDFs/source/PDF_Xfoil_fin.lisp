(define-object PDF-xfoil-fin (base-drawing)

:input-slots 
(
	alpha-CL-max 
	CL-max
)

:computed-slots 
(
	(Generate-PDF-Xfoil-fin
						(the (pdf-xfoil-fin-gen!) )
	)
	
	(wartosci-1 (concatenate 'string 
	
"Maximum lift coefficient: "	(write-to-string (the CL-max) ) " [-]"
			    )
	)
	
	(wartosci-2 (concatenate 'string 	
	
"Stall angle:  "	(write-to-string (the alpha-CL-max) ) " [deg]"
			    )
	)
	
	(podpis "                             Top profile view")
		   
	(center-list 
				(list (the center) 
					  (translate (the center) 
							:front 3
					  )
				)
	)
	
)

:hidden-objects 
(
	(notatka_wartosci-1 
					:type 'general-note
					
					:center  (the center) 
					
					
					:strings (the wartosci-1)
	)
	
	(notatka_wartosci-2 
					:type 'general-note
					
					:center  (the center)
					
					:strings (the wartosci-2)
	)
	
	(notatka_tytul 
					:type 'general-note
					
					:center (translate (the center) 
									:rear  (* (the-child length) 0.85)
							)
							
					:length (/ (the length) 1.5)
					:character-size 25
					
					:strings (the podpis))
)		   


:objects
(
	(CL_Alpha_Plot
			:type 'base-view
			
			:projection-vector (getf *standard-views* :top)
			
			:object-roots (list (the PDF_fin_values xfoil-polar CL-alpha-plot))
			
			:length (/ (the length) 3)
			:width  (/ (the width) 1)
			
			:center (translate (the center) 
						:front  (* (the-child length) 0.25)
					)
	)

	(Airfoil_Curve
			:type 'base-view
			
			:projection-vector (getf *standard-views* :top)
			
			:object-roots (list (the PDF_fin_values airfoil-curve-object))
			
			:length (/ (the length) 3)
			:width  (/ (the width) 1)
			
			;:view-scale 60
			
			:center (translate (the center) 
						:rear  (* (the-child length) 0.85)
					)
	)
	
	(Note_with_Values-1
			:type 'base-view
			
			:projection-vector (getf *standard-views* :top)
			
			:object-roots (list (the notatka_wartosci-1))
			
			:view-scale 15
			
			:length (/ (the length) 3)
			:width  (/ (the width) 1)
			
			:center (translate (the center) 
						:front  (* (the-child length) 0.95)
					)
	)

	(Note_with_Values-2
			:type 'base-view
			
			:projection-vector (getf *standard-views* :top)
			
			:object-roots (list (the notatka_wartosci-2))
			
			:view-scale 15
			
			:length (/ (the length) 3)
			:width  (/ (the width) 1)
			
			:center (translate (the center) 
						:front  (* (the-child length) 1.15)
					)
	)
	
	(Note_with_title
			:type 'base-view
			
			:projection-vector (getf *standard-views* :top)
			
			:object-roots (list (the notatka_tytul))
			
			:length (/ (the length) 3)
			:width  (/ (the width) 1)
			
			:center (translate (the center) 
						:rear  (* (the-child length) 0.15)
					)
	)
	
)	   

  
:functions
(
	(pdf-xfoil-fin-gen! ()
			
			(let ((output-path "C:/Users/Simon/Desktop/check_27_PDFs/source/data/Xfoil_fin.pdf"))
			
				(with-format (pdf output-path
								:page-length (the page-length)
								:page-width (the page-width)
								
								:if-exists :supersede
								:if-does-not-exist :create
							 )
							 (write-the cad-output)
				)
				output-path
			)
	)
)   


;end of define object:
)