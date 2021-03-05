
(defun l-h-function
( 
	tailsweep 
	fuselagecylinderlength 	;fuselage cylinder length
	fuselageaftconelength	;fuselage aft cone length
	
	totalwingsurface		;total wing surface
	
	cMAC 
	tailar 
	tailtaper 
	
	Vh 
	
	enginespodded0mounted1
	tailtype
	Sv				;for the V-tail
	
	finsweep		;for the T- tail and Cruciform
	finspan			;for the T- tail and Cruciform
	
	cruciform		;for the cruciform only

)


(let 
	(
		(discrepancy 							10) 
		(MAC_HT_distance_from_center-initial 	10)
		(MAC_HT-initial 						10) 
		(l-h 									10)
	)

(loop 
   
    with S-h				;for every tail including V-tail thereby making use of S-h-normal (conventional one)
	with S-h-normal			;for every tail except V-tail
	
    with total-tail-span
	with tail-semi-span
    with tail-c-root  = 10
    with tail-c-tip
    with MAC_HT_distance_from_center 				
    with MAC_HT 

while (> discrepancy 0.0001)  do


(setq l-h 

(ecase tailtype

(0 ;conventional

(ecase enginespodded0mounted1

	(0
			(+  
				(* 0.50 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
			)
	)
;end of podded or mounted engines ecase:	
)
;end of conventional ecase:
)


(1 ;T-tail

(ecase enginespodded0mounted1

	(0
			(+  
				(* 0.50 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
				
				(*  1 (* (tan (* (/ pi 180) finsweep))  0.90 finspan ))
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
				
				(*  1 (* (tan (* (/ pi 180) finsweep))  0.90 finspan ))
			)
	)
;end of podded or mounted engines ecase:	
)
;end of T-tail ecase:
)



(2 ;cruciform

(ecase enginespodded0mounted1

	(0
			(+  
				(* 0.50 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
				
				(*  1 (* (tan (* (/ pi 180) finsweep))  cruciform finspan ))
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
				
				(*  1 (* (tan (* (/ pi 180) finsweep))  cruciform finspan ))
			)
	)
;end of podded or mounted engines ecase:	
)
;end of cruciform ecase:
)


(3 ;V-tail

(ecase enginespodded0mounted1

	(0
			(+  
				(* 0.50 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
			)
	)
;end of podded or mounted engines ecase:	
)
;end of V-tail ecase:
)



(4 ;C-tail

(ecase enginespodded0mounted1

	(0
			(+  
				(* 0.50 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
			)
	)
;end of podded or mounted engines ecase:	
)
;end of C-tail ecase:
)

(5 ;H-tail

(ecase enginespodded0mounted1

	(0
			(+  
				(* 0.50 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -1.0 tail-c-root)
				
				(*  1 (* 0.25 MAC_HT-initial))
			    (*  1 (* (tan (* (/ pi 180) tailsweep)) MAC_HT_distance_from_center-initial))
			)
	)
;end of podded or mounted engines ecase:	
)
;end of H-tail ecase:
)


;end of tailtype ecase:
)
;end of setg l-h:
)
	

	
	
	
(setq S-h-normal (/ (* Vh totalwingsurface cMAC) l-h))

(setq S-h (if (eql tailtype 3)
								(* 0.5 (+ S-h-normal Sv) )
								S-h-normal
		  )
)


(setq total-tail-span (sqrt (* S-h tailar)) )
(setq tail-semi-span  (/ total-tail-span 2) )

(setq tail-c-root (/ S-h (* tail-semi-span (+ 1 tailtaper)) ) ) ;correct, careful - onyl half of S_HT is included so we take tail-semi-span, NOT tail-total-span!
(setq tail-c-tip  (* tail-c-root tailtaper ) )




(setq MAC_HT_distance_from_center (/ (* 2 tail-semi-span (+ (* 1/2 tail-c-root) tail-c-tip)) 
								     (* 3 (+ tail-c-root tail-c-tip)) ) )
								

(setq MAC_HT (- tail-c-root (/ (* 2 (- tail-c-root tail-c-tip) (+ (* 1/2 tail-c-root) tail-c-tip)) 
							   (* 3 (+ tail-c-root tail-c-tip)) )))

							   
							   
							   
;CHECK !!!
(setq discrepancy ( abs(/ (- MAC_HT_distance_from_center-initial     MAC_HT_distance_from_center) 
							 MAC_HT_distance_from_center-initial ))) 

;ascribe updated value: 
(setq MAC_HT_distance_from_center-initial  MAC_HT_distance_from_center)
(setq MAC_HT-initial  					   MAC_HT)

collect l-h

;end of loop:
)

(return-from l-h-function l-h)

;end of let:
)

;end of function:
)