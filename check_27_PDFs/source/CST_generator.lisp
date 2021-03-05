(in-package :gdl-user)

(define-object CST_generator (base-object)

:input-slots
(  
	CST
	(N1 0.5)
	(N2 1.0)
	(x-coordinates (list-of-numbers 0 1 0.01))
)

:computed-slots
(
	(CST_Coefficients
					(list 
;Coefficients representing UPPER curvature of the profile:
						(nth 0 (the CST))				;first coefficient
						(nth 1 (the CST))				;second
						(nth 2 (the CST))				;third
						(nth 3 (the CST))				;fourth
						(nth 4 (the CST))				;fifth
						(nth 5 (the CST))				;sixth
;Coefficients representing LOWER curvature of the profile:
						(nth 6  (the CST))			;seventh coefficient
						(nth 7  (the CST))			;eighth
						(nth 8  (the CST))			;nineth
						(nth 9  (the CST))			;tenth
						(nth 10 (the CST))			;eleventh
						(nth 11 (the CST))			;twelveth
					)
	)
	
;Bernstein polynomials calculated by means formula from slide 28 - MDO Lecture 1 Part2 - Parametrization-1.pptx:
;(see detailed calculation of the polynomials for grade 5 - notebook)

;S_i (n):

(B_0_5 (mapcar #'(lambda (x) (expt (- 1 x) 5) ) 
							 (the x-coordinates)) )	

(B_1_5 (mapcar #'(lambda (x) (* 5 x (expt (- 1 x) 4)) ) 
							 (the x-coordinates)) )

(B_2_5 (mapcar #'(lambda (x) (* 10 (expt x 2) (expt (- 1 x) 3)) ) 
							 (the x-coordinates)) )	

(B_3_5 (mapcar #'(lambda (x) (* 10 (expt x 3) (expt (- 1 x) 2)) ) 
							 (the x-coordinates)) )

(B_4_5 (mapcar #'(lambda (x) (* 5 (expt x 4) (- 1 x)) ) 
							 (the x-coordinates)) )	

(B_5_5 (mapcar #'(lambda (x) (expt x 5) ) 
							 (the x-coordinates)) )	

							
;Shape function

;S (n) = summation over ( S_i (n) * respective CST coefficients):							

;Upper surface:					
(Shape_F_up_0 (mapcar #'(lambda (x)
									(* (nth 0 (the CST_Coefficients)) x))
									(the B_0_5)))							
(Shape_F_up_1 (mapcar #'(lambda (x)
									(* (nth 1 (the CST_Coefficients)) x))
									(the B_1_5)))							
(Shape_F_up_2 (mapcar #'(lambda (x)
									(* (nth 2 (the CST_Coefficients)) x))
									(the B_2_5)))							
(Shape_F_up_3 (mapcar #'(lambda (x)
									(* (nth 3 (the CST_Coefficients)) x))
									(the B_3_5)))							
(Shape_F_up_4 (mapcar #'(lambda (x)
									(* (nth 4 (the CST_Coefficients)) x))
									(the B_4_5)))
(Shape_F_up_5 (mapcar #'(lambda (x)
									(* (nth 5 (the CST_Coefficients)) x))
									(the B_5_5)))									

;Lower surface:
(Shape_F_low_0 (mapcar #'(lambda (x)
									(* (nth 6 (the CST_Coefficients)) x))
									(the B_0_5)))							
(Shape_F_low_1 (mapcar #'(lambda (x)
									(* (nth 7 (the CST_Coefficients)) x))
									(the B_1_5)))							
(Shape_F_low_2 (mapcar #'(lambda (x)
									(* (nth 8 (the CST_Coefficients)) x))
									(the B_2_5)))							
(Shape_F_low_3 (mapcar #'(lambda (x)
									(* (nth 9 (the CST_Coefficients)) x))
									(the B_3_5)))							
(Shape_F_low_4 (mapcar #'(lambda (x)
									(* (nth 10 (the CST_Coefficients)) x))
									(the B_4_5)))
(Shape_F_low_5 (mapcar #'(lambda (x)
									(* (nth 11 (the CST_Coefficients)) x))
									(the B_5_5)))

(Shape_F_up (mapcar #'(lambda   (A1 A2 A3 A4 A5 A6) 
							  (+ A1 A2 A3 A4 A5 A6))
													(the Shape_F_up_0)
													(the Shape_F_up_1)
													(the Shape_F_up_2)
													(the Shape_F_up_3)
													(the Shape_F_up_4)
													(the Shape_F_up_5)))

(Shape_F_low (mapcar #'(lambda  (A1 A2 A3 A4 A5 A6) 
							  (+ A1 A2 A3 A4 A5 A6))
													(the Shape_F_low_0)
													(the Shape_F_low_1)
													(the Shape_F_low_2)
													(the Shape_F_low_3)
													(the Shape_F_low_4)
													(the Shape_F_low_5)))

;Class function:

(Class_Function (mapcar #'(lambda (x)
										(* (expt x (the N1)) (expt (- 1 x) (the N2))))
										(the x-coordinates)))


;Output function:
(y-coordinates_up (mapcar #' (lambda (x y) (* x y))
													(the Class_Function) 
													(the Shape_F_up)))
(y-coordinates_low (mapcar #' (lambda (x y) (* x y))
													(the Class_Function) 
													(the Shape_F_low)))

;butlast to avoid dividing by 0 in scaling, reverse to impose counter-clokwise direction and consistency:
(points-up (butlast (reverse (mapcar #'(lambda (x y) (make-point x y 0))
																		(the x-coordinates)
																		(the y-coordinates_up)))))
(points-low (mapcar #'(lambda (x y) (make-point x y 0))
														(the x-coordinates)
														(the y-coordinates_low)))

;Finally, the cartesian interpretation is:
(output-points (append (the points-up) 
					   (the points-low)
				)
)
					 
									
;bracket closing computed slots:	
)

;bracket closing the CST_generator object:
)