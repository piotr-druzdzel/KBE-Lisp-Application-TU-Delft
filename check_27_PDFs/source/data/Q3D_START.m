%% Aerodynamic solver setting

kink_perc= 0.25; % Calculated from the drawing

% Wing planform geometry 
%                 x                       y                 z    		chord(m)               twist angle (deg) 
AC.Wing.Geom = [0              0        0    3.5               0; 
                1.5071081002055884              1.992389396183491        0.17431148549531633    1.9928918997944116               0;  % at the beginning obtained from linear interpolation - then becomes a variable, one centimeter added at the trailing edge to avoid 0 value for the EMWET
                6.0284324008223535               7.969557584733964        0.6972459419812653    0.35000000000000003               0];

% Wing incidence angle (degree)
AC.Wing.inc  = 3;   
                  
% Airfoil coefficients input matrix
%                  | ->                    upper curve coeff.                <-|   | ->                    lower curve coeff.                    <-| 
AC.Wing.Airfoils   = [0.168418510137478 0.262029639366784  0.119186995817168   0.33001232226113  0.167373235439637  0.23588380239239           -0.0798383150127733   -0.124321381229136  0.0176190017377482   -0.141567821706797  0.0846152633951693   -0.0149992553853016;
                      0.168418510137478 0.262029639366784  0.119186995817168   0.33001232226113  0.167373235439637  0.23588380239239           -0.0798383150127733   -0.124321381229136  0.0176190017377482   -0.141567821706797  0.0846152633951693   -0.0149992553853016;
                      0.168418510137478 0.262029639366784  0.119186995817168   0.33001232226113  0.167373235439637  0.23588380239239           -0.0798383150127733   -0.124321381229136  0.0176190017377482   -0.141567821706797  0.0846152633951693   -0.0149992553853016];
                       
AC.Wing.eta = [0;kink_perc;1];  % Spanwise location of the airfoil sections

AC.Visc  = 0; % 1 for viscous analysis and 0 for inviscid
    
% Flight Condition
AC.Aero.V     = 221.28173924885897;   % flight speed (m/s)
AC.Aero.rho   = 0.35545276423815375;   % air density  (kg/m3)
AC.Aero.alt   = 11200;   % flight altitude (m)
AC.Aero.Re    = 1.1067668544761257e+7;   % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = 0.75;   % flight Mach number 
AC.Aero.CL    = 0.8998001215626569;   % lift coefficient - comment this line to run the code for given alpha%

%% 

Res = Q3D_solver(AC);