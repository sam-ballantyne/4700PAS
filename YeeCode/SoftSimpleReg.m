winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


tSim = 200e-15 ; %setting up the simulation time
f = 230e12;
lambda = c_c/f;

xMax{1} = 20e-6;
nx{1} = 200; %number of divisions of dx
ny{1} = 0.75*nx{1};


Reg.n = 1;

%Material Parameters
mu{1} = ones(nx{1},ny{1})*c_mu_0; % permeability of material

epi{1} = ones(nx{1},ny{1})*c_eps_0; % permittivity of vacuum matrix
epi{1}(125:150,55:95)= c_eps_0*11.3; %creates the inclusion of a material
epi{1}(75:100,55:95)= c_eps_0*11.3; 
epi{1}(175:200,55:95)= c_eps_0*11.3; 
epi{1}(75:200,70:80)= c_eps_0*11.3; 

sigma{1} = zeros(nx{1},ny{1}); %conductivity of material
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1};
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2) ;
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx ;

movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 3.5;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];

%% Boundary Conditions
% The bc's are not technically a boundary (misnomer) --> it creates the
% soft source of the wave at the intersection of the denoted scattering
% field and the total field

% Source 1
bc{1}.NumS = 1;
bc{1}.s(1).xpos = floor(nx{1}/(10) + 1); % source at this position
bc{1}.s(1).type = 'ss'; % ss = steady state
bc{1}.s(1).fct = @PlaneWaveBC; 

% Source 2
%bc{1}.s(2).xpos = floor(nx{1}/(4) + 1); % source at this position
%bc{1}.s(2).type = 'ss'; % ss = steady state
%bc{1}.s(2).fct = @PlaneWaveBC; 

% pass the boundary condition -- this function that creates a pulse
% mag = -1/c_eta_0;
mag = 1;
phi = 0;
omega = f*2*pi;
betap = 0;
t0 = 30e-15;
st = -0.05 ; %15e-15;
s = 0;
y0 = yMax/2;
sty = 1.5*lambda;
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};
%bc{1}.s(2).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};
Plot.y0 = round(y0/dx);

% 'a' = absorbing boundary conditions (PML all around)
% implemented as a graded (exp) complex material
bc{1}.xm.type = 'a'; 
bc{1}.xp.type = 'a';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';

% PML sizing
pml.width = 20 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg % Function that runs the propagation






