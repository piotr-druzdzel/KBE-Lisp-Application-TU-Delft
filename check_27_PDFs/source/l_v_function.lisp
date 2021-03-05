(defun l-v-function

;inputs:
(
	 
	fuselagecylinderlength 	;fuselage cylinder length
	fuselageaftconelength	;fuselage aft cone length 
	
	totalwingsurface		;total wing surface
	totalspan 
	
	finar 
	fintaper
	finsweep
	
	Vv
	
	enginespodded0mounted1
	
	tailtype
	
	tailsweep
	
	;tailsemispan
	; tailar
	; Vh
	; lh
	; cMAC
	
)

(let
	(
		(MAC_VT_distance_from_center-initial  10)
		(MAC_VT-initial						  10)
		(discrepancy						  10)
		(l-v								  10)
	)

(loop 
 
	with S-v
	with fin-span		= 10
	with fin-c-root 	= 10 ;for the sake of being able to substract a part of it to position it rigtly in the aftt cone of the fuselage
	with fin-c-tip
	
	with MAC_VT_distance_from_center 				
    with MAC_VT 
	
	; with S-h = 10
	; with total-tail-span = 10
	; with tail-semi-span = 10
	

while (> discrepancy 0.0001)  do

;stuff from HT loop:

; (setq S-h (/ (* Vh totalwingsurface cMAC) lh))

; (setq total-tail-span (sqrt (* S-h tailar)) )
; (setq tail-semi-span  (/ total-tail-span 2) )

; (setq tail-c-root (/ S-h (* tail-semi-span (+ 1 tailtaper)) ) ) ;correct, careful - onyl half of S_HT is included so we take tail-semi-span, NOT tail-total-span!
; (setq tail-c-tip  (* tail-c-root tailtaper ) )

; (setq MAC_HT_distance_from_center (/ (* 2 tail-semi-span (+ (* 1/2 tail-c-root) tail-c-tip)) 
								     ; (* 3 (+ tail-c-root tail-c-tip)) ) )
								
; (setq MAC_HT (- tail-c-root (* (/  MAC_HT_distance_from_center  tail-semi-span) (- tail-c-root  tail-c-tip))))



(setq l-v 

(ecase tailtype

(0 ;conventional

(ecase enginespodded0mounted1

	(0
			(+  
				(* 0.50 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
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
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
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
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
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
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
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
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
				
				(* (tan (* (/ pi 180) tailsweep)) fin-span )		;;?????? temporarily ??????
			   ;(* (tan (* (/ pi 180) tailsweep)) tail-semi-span )	;; desirably
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
				
				(* (tan (* (/ pi 180) tailsweep)) fin-span )		;;?????? temporarily ??????
			   ;(* (tan (* (/ pi 180) tailsweep)) tail-semi-span )	;; desirably
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
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
				
				(* (tan (* (/ pi 180) tailsweep)) fin-span )		;;?????? temporarily ??????
			   ;(* (tan (* (/ pi 180) tailsweep)) tail-semi-span )	;; desirably
			)
	)

	(1
			(+  
				(* 0.40 fuselagecylinderlength)
				(*  1 fuselageaftconelength)
				(* -0.75 fin-c-root)			;for conventional taper is smaller -> 0.25 MAC ends up closer to the wing -> fin root can be further aft
				
				(*  1 (* 0.25 MAC_VT-initial))
			    (*  1 (* (tan (* (/ pi 180) finsweep)) MAC_VT_distance_from_center-initial))
				
				(* (tan (* (/ pi 180) tailsweep)) fin-span )		;;?????? temporarily ??????
			   ;(* (tan (* (/ pi 180) tailsweep)) tail-semi-span )	;; desirably
			)
	)
;end of podded or mounted engines ecase:	
)
;end of H-tail ecase:
)



;end of tailtype ecase:
)
;end of setq l-v:
)


;to avoid implicit equation and stack overflow:
(setq S-v 

(ecase tailtype

	(0 (/ (*  Vv  totalwingsurface  totalspan)  l-v)) 		 ;conventional
	(1 (/ (*  Vv  totalwingsurface  totalspan)  l-v)) 		 ;T-tail
	(2 (/ (*  Vv  totalwingsurface  totalspan)  l-v)) 		 ;cruciform
	
	(3 (/ (*  Vv  totalwingsurface  totalspan)  l-v)) 		 ;V-tail

	(4 (/ (/ (*  Vv  totalwingsurface  totalspan)  l-v) 2) ) ;C-tail
	(5 (/ (/ (*  Vv  totalwingsurface  totalspan)  l-v) 4) ) ;H-tail
)

)




(setq fin-span (sqrt (*  S-v  finar)))

(setq fin-c-root (/ (* 2 S-v) (*  fin-span (+ 1 fintaper))))
(setq fin-c-tip  (*   fin-c-root  fintaper))
			  
(setq MAC_VT_distance_from_center (/ (* 2 fin-span (+ (* 1/2 fin-c-root) fin-c-tip)) 
									 (* 3 (+ fin-c-root fin-c-tip)) ))
								

(setq MAC_VT (- fin-c-root (/ (* 2 (- fin-c-root fin-c-tip) (+ (* 1/2 fin-c-root) fin-c-tip)) 
							  (* 3 (+ fin-c-root fin-c-tip)) )))

							   
;CHECK!!!
(setq discrepancy ( abs(/ (- MAC_VT_distance_from_center-initial 
							 MAC_VT_distance_from_center) 
						MAC_VT_distance_from_center-initial )))
	 
(setq MAC_VT_distance_from_center-initial  MAC_VT_distance_from_center)
(setq MAC_VT-initial  					   MAC_VT)
       
collect l-v

;end of loop:
)


(return-from l-v-function l-v)
	

;end of let:
)

;end of defun:
)