(define-object KBE-ASSIGNMENT (base-object)

:input-slots
(
;inputs for the airplane object:
	(c-root 						(the airplane c-root) )
	(total-span 					(the airplane total-span ) )
	(taper 							(the airplane taper ) )
	(spanwise-position-kink			(the airplane spanwise-position-kink) )
	(sweep							(the airplane sweep) )

;affecting aft fuselage cone:
	(landing_gear_height			(the airplane landing_gear_height) )
	(fuselage_diameter				(the airplane fuselage_diameter) )
	(divergence_angle				(the airplane divergence_angle) )
 	(rotation_angle					(the airplane rotation_angle) )

;affecting nose:
	(slenderness_ratio_fuselage		(the airplane slenderness_ratio_fuselage) )
	(slenderness_ratio_nose			(the airplane slenderness_ratio_nose) )


;affecting wing position:
	(engines_podded_0_mounted_1		(the airplane engines_podded_0_mounted_1) )
	(wings_bottom_0_top_1			(the airplane wings_bottom_0_top_1) )

;others:
	(dihedral						(the airplane dihedral) )
	(thickness						(the airplane thickness) )

;engines:
	(engine_diameter				(the airplane engine_diameter) )
	(engine_length					(the airplane engine_length) )
	(number_of_engines				(the airplane number_of_engines) )

;possible engine conf.: 2, 3 or 4:
	(engine_number					(the airplane engine_number) )

	(type-of-tail					(the airplane type-of-tail) )
	(tail-type						(the airplane tail-type) )

	(cruciform						(the airplane cruciform) )

;planform of the Horizontal Tail (HT):
	(tail-taper						(the airplane tail-taper) )
	(tail-ar						(the airplane tail-ar) )

	(tail-dihedral 					(the airplane tail-dihedral) )

;planform of the Vertical Tail (VT):
	(stagger_VT						(the airplane stagger_VT) )
	(stagger						(the airplane stagger) )

	(fin-taper						(the airplane fin-taper) )
	(fin-ar							(the airplane fin-ar) )
	(fin-sweep						(the airplane fin-sweep) )
	(fin-thickness					(the airplane fin-thickness) )

;flight conditions:
	(Mach							(the airplane Mach) )
	(altitude						(the airplane altitude) )
	(W_dg_lb						(the airplane W_dg_lb) )
	
;------------------------------------------------------------------

	(tail-root-center 				(the airplane tail-root-center) )
	(root-center 					(the airplane wing-assembly root-center) )
	
	(tail-sweep 					(the airplane tail-sweep) )
	(MAC_HT_distance_from_center 	(the airplane MAC_HT_distance_from_center) )
	(MAC_HT 						(the airplane MAC_HT) )
	(total-tail-span 				(the airplane total-tail-span) )
	(S-h 							(the airplane S-h) )
	(l-h 							(the airplane l-h) )
	
	(fin-span 						(the airplane fin-span) )
	(fin-c-root 					(the airplane fin-c-root) )
	(MAC_VT 						(the airplane MAC_VT) )
	(MAC_VT_distance_from_center 	(the airplane MAC_VT_distance_from_center) )
	(S-v 							(the airplane S-v) )
	(l-v 							(the airplane l-v) )
	
	(total_wing_surface 			(the airplane total_wing_surface) )
	(semi-span 						(the airplane semi-span) )
	(fuselage_radius 				(the airplane fuselage_radius) )

	(c-MAC 							(the airplane c-MAC) )
	(tail-thickness 				(the airplane tail-thickness) )

	(tail-c-root 					(the airplane tail-c-root) )
	(MAC_distance_from_root 		(the airplane MAC_distance_from_root) )

	(fuselage_cylinder_length		(the airplane fuselage_cylinder_length) )
	(wing_position					(the airplane wing_position) )
	
	(3_rd_engine					(the airplane 3_rd_engine) )
	(Thrust_lb						(the airplane Thrust_lb) )
	(boolean_top_or_bottom_wing		(the airplane boolean_top_or_bottom_wing) )
	(aircraft_speed					(the airplane aircraft_speed) )
	(sound_speed					(the airplane sound_speed) )

;Xfoil-wing:
	(xfoil_wing_3D_points 			(the cutting-wing-x-foil xfoil_wing_3D_points))
	(c-tip							(the airplane c-tip) )
	(xfoil-spanwisely 				(the airplane xfoil-spanwisely))
	(loft-outer 					(the airplane wing-assembly (:wings 0) loft-outer) )
	(loft-inner 					(the airplane wing-assembly (:wings 0) loft-inner) )
	
;Xfoil-tail:
	(loft-tail						(the airplane tail-assembly (:wings 0) tail-loft) )
	(xfoil_tail_3D_points 			(the cutting-tail-x-foil xfoil_tail_3D_points))
	(xfoil-tail-spanwisely 			(the airplane xfoil-spanwisely) )
	(tail-semi-span					(the airplane tail-semi-span) )
	(xfoil_wing_tail_fin			(the airplane xfoil_wing_tail_fin) )
	
;Xfoil-fin:
	(xfoil_fin_3D_points 			(the cutting-fin-x-foil xfoil_fin_3D_points) )
	(xfoil-fin-spanwisely 			(the airplane xfoil-spanwisely) )
	
	(fin-root-center				(the airplane fin-root-center) )

;PDF generation:
	(CL-max-wing					(the PDF_wing_values CL-max-value) )
	(alpha-CL-max-wing				(the PDF_wing_values alpha-CL-max-value) )	
	
	(CL-max-tail					(the PDF_tail_values CL-max-value) )
	(alpha-CL-max-tail				(the PDF_tail_values alpha-CL-max-value) )	
	
	(CL-max-fin						(the PDF_fin_values CL-max-value) )
	(alpha-CL-max-fin				(the PDF_fin_values alpha-CL-max-value) )
	
;end of input-slots:	
)



	:computed-slots
(
;distinguishing between conventional fin and one fin (on the left side) in case of H/C configuration:
	(loft-fin	(if (or (eql (the airplane tail-type) 4) (eql (the airplane tail-type) 5))
		
					(the airplane tail-assembly (:fin 1) fin-loft)
					(the airplane tail-assembly fin fin-loft)
				) 
	)

)



	:hidden-objects
(

;for the purpose of retrieving 3D points:

	(cutting-wing-x-foil
	
		:type 'cutting-wing-x-foil
		
		:fuselage_radius 				(the fuselage_radius)
		:wing_position 					(the wing_position)
		:boolean_top_or_bottom_wing 	(the boolean_top_or_bottom_wing)

		:c-root 						(the c-root)
		:c-tip 							(the c-tip)
		:sweep 							(the sweep)
		:semi-span 						(the semi-span)
		:dihedral 						(the dihedral)

		:xfoil-spanwisely 				(the xfoil-spanwisely)
		:thickness 						(the thickness)
		:spanwise-position-kink 		(the spanwise-position-kink)

		:loft-outer 					(the loft-outer)
		:loft-inner 					(the loft-inner) 
	
	)
	
	(cutting-tail-x-foil
	
		:type 'cutting-tail-x-foil	
	
		:tail-root-center			(the tail-root-center)

		:tail-c-root				(the tail-c-root)
		:tail-c-tip 				(the tail-c-tip)

		:tail-sweep 				(the tail-sweep)
		:tail-semi-span				(the tail-semi-span)
		:tail-dihedral				(the tail-dihedral)
		:tail-thickness				(the tail-thickness)

		:xfoil-tail-spanwisely 		(the xfoil-tail-spanwisely)

		:loft-tail					(the loft-tail)
	)
	
	(cutting-fin-x-foil
	
		:type 'cutting-fin-x-foil	
	
		:fin-root-center			(the fin-root-center)

		:fin-c-root					(the fin-c-root)
		:fin-c-tip					(the fin-c-tip) 

		:fin-sweep					(the fin-sweep) 
		:fin-span					(the fin-span)

		:fin-thickness				(the fin-thickness)

		:xfoil-fin-spanwisely		(the xfoil-fin-spanwisely)

		:loft-fin					(the loft-fin)						;;;;;loft of fin here !
  
		:fuselage_radius			(the fuselage_radius)
		:tail-type					(the tail-type)
		:tail-semi-span				(the tail-semi-span)
		:tail-dihedral				(the tail-dihedral)
		:tail-sweep					(the tail-sweep)
	
	)
	
	
	
;PDF stuff - for the purpose of retrieving CL-max and alpha stall values:

	(PDF_wing_values
		
		:type 'example-xfoil
		
		:xfoil_wing_3D_points	(the xfoil_wing_3D_points)
		:xfoil_tail_3D_points	(the xfoil_tail_3D_points)
		:xfoil_fin_3D_points	(the xfoil_fin_3D_points)

		:xfoil_wing_tail_fin	(the xfoil_wing_tail_fin)	
	)

	(PDF_tail_values
		
		:type 'example-xfoil
		
		:xfoil_wing_3D_points	(the xfoil_wing_3D_points)
		:xfoil_tail_3D_points	(the xfoil_tail_3D_points)
		:xfoil_fin_3D_points	(the xfoil_fin_3D_points)

		:xfoil_wing_tail_fin	(the xfoil_wing_tail_fin)	
	)
	
	(PDF_fin_values
		
		:type 'example-xfoil
		
		:xfoil_wing_3D_points	(the xfoil_wing_3D_points)
		:xfoil_tail_3D_points	(the xfoil_tail_3D_points)
		:xfoil_fin_3D_points	(the xfoil_fin_3D_points)

		:xfoil_wing_tail_fin	(the xfoil_wing_tail_fin)	
	)	
	
)


  :objects 
( 
	(airplane :type 'airplane)
	
	(computations 
	
		:type 'parameter-computation
	
		:tail-sweep 					(the tail-sweep)
		:MAC_HT_distance_from_center 	(the MAC_HT_distance_from_center)
		:MAC_HT 						(the MAC_HT)

		:fuselage_diameter 				(the fuselage_diameter)
		:total-tail-span 				(the total-tail-span)
		:S-h 							(the S-h)
		:l-h 							(the l-h)
		:tail-ar 						(the tail-ar)
	
		:tail-type 						(the tail-type)

		:fin-span 						(the fin-span)
		:fin-ar 						(the fin-ar)
		:fin-thickness 					(the fin-thickness)
		:fin-c-root 					(the fin-c-root)
		:fin-sweep 						(the fin-sweep)
		:MAC_VT 						(the MAC_VT)
		:MAC_VT_distance_from_center 	(the MAC_VT_distance_from_center)
		:S-v 							(the S-v)
		:l-v 							(the l-v)
	
;reference areas:
		:total_wing_surface 			(the total_wing_surface)
		:semi-span 						(the semi-span)
		:fuselage_radius 				(the fuselage_radius)
		:thickness 						(the thickness)
		:c-MAC 							(the c-MAC)
		:tail-thickness 				(the tail-thickness)
		:c-root 						(the c-root)
		:sweep 							(the sweep)
	
		:total-span 					(the total-span)
		:tail-c-root 					(the tail-c-root)
		:MAC_distance_from_root 		(the MAC_distance_from_root)

		:W_dg_lb 						(the W_dg_lb)
		:Mach 							(the Mach)
		:altitude 						(the altitude)

		:tail-root-center 				(the tail-root-center)
		:root-center 					(the root-center)
		
		:tail-dihedral					(the tail-dihedral)
		
		:taper							(the taper)
		:slenderness_ratio_nose			(the slenderness_ratio_fuselage)
		:fuselage_cylinder_length		(the fuselage_cylinder_length)
		:wing_position					(the wing_position)
	
		:engine_number					(the engine_number)
		:engine_length					(the engine_length)
		:3_rd_engine					(the 3_rd_engine)
		:engine_diameter				(the engine_diameter)
		:engines_podded_0_mounted_1		(the engines_podded_0_mounted_1)
		:Thrust_lb						(the Thrust_lb)
		:dihedral						(the dihedral)
		:boolean_top_or_bottom_wing		(the boolean_top_or_bottom_wing)
		:aircraft_speed					(the aircraft_speed)
		:sound_speed					(the sound_speed)
		
		:cruciform						(the cruciform)
	)


	

;Xfoil:	
	
	(X-foil-wing
	
		:type 'example-xfoil
	
		:xfoil_wing_3D_points (the xfoil_wing_3D_points)
	
		:xfoil_wing_tail_fin (the xfoil_wing_tail_fin)
	)
	
	(X-foil-tail
	
		:type 'example-xfoil
	
		:xfoil_tail_3D_points (the xfoil_tail_3D_points)
	
		:xfoil_wing_tail_fin (the xfoil_wing_tail_fin)
	)
	
	(X-foil-fin
	
		:type 'example-xfoil
	
		:xfoil_fin_3D_points (the xfoil_fin_3D_points)
	
		:xfoil_wing_tail_fin (the xfoil_wing_tail_fin)
	)
	

	
	
	
;PDF stuff:	
	
	(PDF_views
		:type 'PDF_Trimetric_Views
	)
		
	(PDF_wing_plots
	
		:type 'PDF-xfoil-wing
		
		:CL-max 		(the CL-max-wing)
		:alpha-CL-max 	(the alpha-CL-max-wing)
	)

	(PDF_tail_plots
	
		:type 'PDF-xfoil-tail
		
		:CL-max 		(the CL-max-tail)
		:alpha-CL-max 	(the alpha-CL-max-tail)
	)
	
	(PDF_fin_plots
	
		:type 'PDF-xfoil-fin
		
		:CL-max 		(the CL-max-fin)
		:alpha-CL-max 	(the alpha-CL-max-fin)
	)
	

	
	

;end of objects:	
)
;end of define-object:
)