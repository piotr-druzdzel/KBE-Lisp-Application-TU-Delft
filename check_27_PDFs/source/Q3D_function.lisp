(defun Q3D-function 

(
;data for the wing planform geometry, note that no wing-twist is included in KBE assignment, therefore its value will be 0:
					x_root-f
					y_root-f
					z_root-f
					
					x_kink-f
					y_kink-f
					z_kink-f
					
					x_tip-f
					y_tip-f
					z_tip-f
					
				c-root-f
				c-kink-f
				c-tip-f
		
;Wing incidence angle (degree)
				wing_AoA_deg-f
					
;Airfoil coefficients input matrix - convention: upper -> lower surface:
				cst-1-f
				cst-2-f
				cst-3-f
				cst-4-f
				cst-5-f
				cst-6-f
				
				cst-7-f
				cst-8-f
				cst-9-f
				cst-10-f
				cst-11-f
				cst-12-f
					
;Spanwise location of the airfoil sections:
				spanwise-position-kink-f

;Viscous(1) vs inviscid(0):
				inviscid_0_viscous_1-f

;Flight Conditions:				
				aircraft_speed-f
				density-f
				altitude-f
				reynolds-f
				Mach-f  
				C_L-f

;For saving to the right location:
				Q3D-file-path-f
)


(let
	(
	;data for the wing planform geometry, note that no wing-twist is included in KBE assignment, therefore its value will be 0:
					x_root
					y_root
					z_root
					
					x_kink
					y_kink
					z_kink
					
					x_tip
					y_tip
					z_tip
					
				c-root
				c-kink
				c-tip
		
;Wing incidence angle (degree)
				wing_AoA_deg
					
;Airfoil coefficients input matrix - convention: upper -> lower surface:
				cst-1
				cst-2
				cst-3
				cst-4
				cst-5
				cst-6
				
				cst-7
				cst-8
				cst-9
				cst-10
				cst-11
				cst-12
					
;Spanwise location of the airfoil sections:
				spanwise-position-kink

;Viscous(1) vs inviscid(0):
				inviscid_0_viscous_1

;Flight Conditions:				
				aircraft_speed
				density
				altitude
				reynolds
				Mach
				C_L

;string initiation for the syntax:
			   (Q3D_file_content "inicjalizacja stringu")
	)

	
	
	
;converting numbers to string so that the set of string can be appended:
(setq x_root (write-to-string x_root-f) )
(setq y_root (write-to-string y_root-f) )	
(setq z_root (write-to-string z_root-f) )	

(setq x_kink (write-to-string x_kink-f) )
(setq y_kink (write-to-string y_kink-f) )
(setq z_kink (write-to-string z_kink-f) )

(setq x_tip (write-to-string x_tip-f) )
(setq y_tip (write-to-string y_tip-f) )
(setq z_tip (write-to-string z_tip-f) )

(setq c-root (write-to-string c-root-f) )
(setq c-kink (write-to-string c-kink-f) )
(setq c-tip  (write-to-string c-tip-f ) )

(setq wing_AoA_deg  (write-to-string wing_AoA_deg-f ) )

(setq cst-1  (write-to-string cst-1-f ) )
(setq cst-2  (write-to-string cst-2-f ) )
(setq cst-3  (write-to-string cst-3-f ) )
(setq cst-4  (write-to-string cst-4-f ) )
(setq cst-5  (write-to-string cst-5-f ) )
(setq cst-6  (write-to-string cst-6-f ) )

(setq cst-7  (write-to-string cst-7-f ) )
(setq cst-8  (write-to-string cst-8-f ) )
(setq cst-9  (write-to-string cst-9-f ) )
(setq cst-10 (write-to-string cst-10-f ) )
(setq cst-11 (write-to-string cst-11-f ) )
(setq cst-12 (write-to-string cst-12-f ) )

(setq spanwise-position-kink (write-to-string spanwise-position-kink-f) )

(setq inviscid_0_viscous_1 (write-to-string inviscid_0_viscous_1-f) )

(setq aircraft_speed 	(write-to-string aircraft_speed-f ) )
(setq density  			(write-to-string density-f ) )
(setq altitude 			(write-to-string altitude-f ) )
(setq reynolds 			(write-to-string reynolds-f ) )
(setq Mach 				(write-to-string Mach-f ) )
(setq C_L  				(write-to-string C_L-f ) )



;the main data for the Q3D file - see: MDO tutorial 3 for the code structure:
(setq Q3D_file_content (concatenate 'string

"%% Aerodynamic solver setting

kink_perc= " spanwise-position-kink "; % Calculated from the drawing

% Wing planform geometry 
%                 x                       y                 z    		chord(m)               twist angle (deg) 
AC.Wing.Geom = [" x_root "              " y_root "        " z_root "    "c-root "               0; 
                " x_kink "              " y_kink "        " z_kink "    "c-kink "               0;  % at the beginning obtained from linear interpolation - then becomes a variable, one centimeter added at the trailing edge to avoid 0 value for the EMWET
                " x_tip "               " y_tip  "        " z_tip  "    "c-tip  "               0];

% Wing incidence angle (degree)
AC.Wing.inc  = " wing_AoA_deg ";   
                  
% Airfoil coefficients input matrix
%                  | ->                    upper curve coeff.                <-|   | ->                    lower curve coeff.                    <-| 
AC.Wing.Airfoils   = [" cst-1 " " cst-2 "  " cst-3 "   " cst-4 "  " cst-5 "  " cst-6 "           " cst-7 "   " cst-8 "  " cst-9 "   " cst-10 "  " cst-11 "   " cst-12 ";
                      " cst-1 " " cst-2 "  " cst-3 "   " cst-4 "  " cst-5 "  " cst-6 "           " cst-7 "   " cst-8 "  " cst-9 "   " cst-10 "  " cst-11 "   " cst-12 ";
                      " cst-1 " " cst-2 "  " cst-3 "   " cst-4 "  " cst-5 "  " cst-6 "           " cst-7 "   " cst-8 "  " cst-9 "   " cst-10 "  " cst-11 "   " cst-12 "];
                       
AC.Wing.eta = [0;kink_perc;1];  % Spanwise location of the airfoil sections

AC.Visc  = " inviscid_0_viscous_1 "; % 1 for viscous analysis and 0 for inviscid
    
% Flight Condition
AC.Aero.V     = " aircraft_speed ";   % flight speed (m/s)
AC.Aero.rho   = " density ";   % air density  (kg/m3)
AC.Aero.alt   = " altitude ";   % flight altitude (m)
AC.Aero.Re    = " reynolds ";   % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = " Mach ";   % flight Mach number 
AC.Aero.CL    = " C_L ";   % lift coefficient - comment this line to run the code for given alpha%

%% 

Res = Q3D_solver(AC);"

;end of concatenation:
)
;end of Q3D_file_content:
)



;writing to a file:
(with-open-file (stream Q3D-file-path-f 

					:direction :output
					:if-exists :supersede
					:if-does-not-exist :create
				)
				
				(format stream Q3D_file_content)
)



;end of let:
)

;end of Q3D function:
)


