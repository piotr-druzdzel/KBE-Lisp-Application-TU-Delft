(define-object PDF_Trimetric_Views (base-drawing)

:computed-slots 
(
	(Generate-PDF-Views 
						(the (pdf-views-gen!) )
	)
)

;actual drawings are objects:

:objects
(
	(pdf-top-view 
			:type 'base-view
			
			:projection-vector (getf *standard-views* :top)
			
			:object-roots (list (the airplane))
			
			:length (/ (the length) 3)
			:width  (/ (the width) 3)
			
			:center (translate (the center) 
						:rear  (* (the-child length) 0.8)
						:right (* (the-child width)  0.6)
					)
	)

	(pdf-side-view 
			:type 'base-view
			
			:projection-vector (getf *standard-views* :right)
			
			:object-roots (list (the airplane))
			
			:length (/ (the length) 3)
			:width  (/ (the width) 3)
			
			:center (translate (the center) 
						:rear  (* (the-child length) 0.8)
						:left (* (the-child width)  0.6)
					)
	)
	
	(pdf-front-view 
			:type 'base-view
			
			:projection-vector (getf *standard-views* :front)
			
			:object-roots (list (the airplane))
			
			:length (/ (the length) 3)
			:width  (/ (the width) 3)
			
			:center (translate (the center) 
						:front  (* (the-child length) 0.0)
						:right (* (the-child width)  0.6)
					)
	)

	(pdf-trimetric-view 
			:type 'base-view
			
			:projection-vector (getf *standard-views* :trimetric)
			
			:object-roots (list (the airplane))
			
			:length (/ (the length) 3)
			:width  (/ (the width) 3)
				
			:center (translate (the center) 
						:front  (* (the-child length) 0.0)
						:left (* (the-child width)  0.6)
					)
	)		
)


:functions
(
	(pdf-views-gen! ()
			
			(let ((output-path "C:/Users/Simon/Desktop/check_27_PDFs/source/data/3D_Views.pdf"))
			
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