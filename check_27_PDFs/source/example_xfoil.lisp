(in-package :gdl-user)


;;---------------------Attention! Read this first----------------------------------------------------------------------------------------------------------

;; In order to make this example work, you should specify the exact path of the supplied xfoil-program.
;; This program is located in the supplied set of files, with the relative path ~\Xfoil GDL Capability Module\source\Xfoil. You are free to place this code at any place on your hard-drive, as long as you make sure that the parameter *xfoil-folder*, defined below, matches this path.

;; Please update the parameter *xfoil-folder* below as required

(defparameter *xfoil-folder* "C:/Users/Simon/Desktop/check_27_PDFs/source/Xfoil/")  ;; defines a parameter in global memory that describes the path (location on computer) of where the xfoil.exe file is located (NB: don't forget the "/" at the end)

;;----------------------------------------------------------------------------------------------------------------------------------------


(define-object example-xfoil (base-object)

;; example class to demonstrate the usage of the xfoil capaility module


:input-slots
(
xfoil_wing_3D_points
xfoil_tail_3D_points
xfoil_fin_3D_points

xfoil_wing_tail_fin

)

:computed-slots
(

(x_foil_points (if (eql (the xfoil_wing_tail_fin) 0)
					(the xfoil_wing_3D_points)
					
					(if (eql (the xfoil_wing_tail_fin) 1)
						(the xfoil_tail_3D_points)
						
						(when (eql (the xfoil_wing_tail_fin) 2)
							(the xfoil_fin_3D_points)
						)
					)	
				)
)

;Retrieving CL-max and Alpha stall:

(cl-plot	(the xfoil-polar cl)) 		;;; retrieving the cl from the polar - an array
(alfa-plot	(the xfoil-polar alfa))		;;; retrieving the AoA

	(CL-max-value-init (mapcar #'(lambda (x)
											(make-point x 0 0)
								 )
									(the cl-plot)
					    )
	)
						  
	(CL-max-value (get-x (most 'get-x (the CL-max-value-init) ))) 		;;;value of clmax
		  
	(position-clmax (position (the CL-max-value) (the cl-plot)))		;;;  (position #\a "baobab" :from-end t) =>  4
		  
	(alpha-CL-max-value (nth (the position-clmax) (the alfa-plot))) 	;;;value of alpha for clmax


;end of computed-slots:
)


:objects
(;; a generic example curve is constructed here from a set of b-spline control-points. For the xfoil capability module, any curve object that represents an airfoil can be used as input (-> :curve-in )
 (airfoil-curve-object 	:type 'b-spline-curve
		       
						:control-points 
										(the x_foil_points)
 )

 
;; xfoil class to obtain a set of polars for one airfoil for a given range of alpha's (Cl-alpha, Cd-alpha, Cm-alpha, Xtr-alpha)
 (xfoil-polar :type 'xfoil-analysis-polar         
	      :curve-in (the airfoil-curve-object) ;; specify the 2D airfoil curve object that you want to analyze: should be defined in x-y plane, 
	                                           ;; chord parallel to x-axis, LE pointing to the negative x-direction
	      
	      :data-folder *xfoil-folder*  ;;specify the location of the xfoil.exe program file
	      :mach-number 0
	      :reynolds-number 10E6
	      :lower-alfa -10                ;; starting alpha of requested polar, [deg]
	      :upper-alfa 30                 ;; final alpha of requested polar, [deg]
	      :alfa-increment 0.5)           ;; alpha increment of requested polar, [deg]


;; xfoil class to analyse a single operating point of an airfoil at a given alpha (Cl, Cd, Cm, boundary layer properties)
 (xfoil-point :type 'xfoil-analysis-pointBL
	      :curve-in (the airfoil-curve-object)  ;;see above
	      :data-folder *xfoil-folder*           ;;specify the location of the xfoil.exe program file
	      :mach-number 0
	      :reynolds-number 10E6
	      :alfa-in 3)   ;; angle-of-attack for which to analyse airfoil, [deg]
))


