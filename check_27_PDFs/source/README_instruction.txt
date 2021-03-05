
	Piotr Druzdzel

	Faculty of Aerospace Engineering 
	Flight Performance and Propulsion	
	Delft University of technilology
	
	KBE Assignment, 2015 - Horizontail Tail Sizing Tool


1. The code can be evaluated by compiling the whole diredctory by means 'cl-lite' command or by compiling all the *.lisp files separately.

(cl-lite "C:/Users/Simon/Desktop/check_27_PDFs/source")

2. Note that the order of compilation plays a role.
3. The main file to run in TASTY is called 'KBE-ASSIGNMENT.lisp' - it contains all the relevant data including the main geometry - airplane.

4. Generation of the Q3d file can be done by clicking on the proper slot in TASTY - here, the one called 'Generate-Q3D-input'.
5. Wakes can be found within the 'airplane.lisp' file and can be displayed by a simple settable switches available.
6. Aerodynamic center and the Center of gravity can be cound within the 'computations'.

7. Please note that for the 'cl-lite' command the directory must include forward slashes ('/') rather than backward ones ('\').

