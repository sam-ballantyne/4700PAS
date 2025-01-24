% This example shows how to calculate and plot both the
% fundamental TE and TM eigenmodes of an example 3-layer ridge
% waveguide using the full-vector eigenmode solver.  

% Refractive indices:
n1 = 3.34;          % Lower cladding
n2 = 3.44;          % Core
n3 = 1.00;          % Upper cladding (air)

% Layer heights:
h1 = 2.0;           % Lower cladding
h2 = 1.3;           % Core thickness
h3 = 0.5;           % Upper cladding

% Horizontal dimensions:
rh = 1.1;           % Ridge height
rw = linspace(0.325,1,10);           % Ridge half-width
side = 1.5;         % Space on side

% Grid size:
dx = 8*0.0125;        % grid size (horizontal)
dy = 8*0.0125;        % grid size (vertical)

lambda = 1.55;      % vacuum wavelength
nmodes = 1;         % number of modes to compute

% First consider the fundamental TE mode:
for  i = 1:10

[x,y,xc,yc,nx,ny,eps,edges] = waveguidemesh([n1,n2,n3],[h1,h2,h3], ...
                                            rh,rw(i),side,dx,dy);     

[Hx,Hy,neffTE] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000A');

%for n = 1:nmodes %add the loop to plot each mode
fprintf(1,'neff = %.6f\n',neffTE);

figure(i);
subplot(121);
contourmode(x,y,Hx(:,:,1));
title('Hx (TE mode)'); xlabel('x'); ylabel('y'); 
%for v = edges, line(v{:}); end

subplot(122);
contourmode(x,y,Hy(:,:,1));
title('Hy (TE mode)'); xlabel('x'); ylabel('y'); 
%for v = edges, line(v{:}); end

%end
end




%% REMOVE TM Mode Calculations
% % Next consider the fundamental TM mode
% % (same calculation, but with opposite symmetry)
% 
% [Hx,Hy,neffTM] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000S');
% 
% for n = 1:nmodes
%     fprintf(1,'neff(%i) = %.6f\n',n,neffTM(n));
% 
%     figure(n+nmodes);
%     subplot(121);
%     contourmode(x,y,Hx(:,:,n));
%     title(['Hx (TM mode:' num2str(n) ')']); xlabel('x'); ylabel('y'); 
%     %for v = edges, line(v{:}); end
% 
%     subplot(122);
%     contourmode(x,y,Hy(:,:,n));
%     title(['Hx (TM mode:' num2str(n) ')']); xlabel('x'); ylabel('y'); 
%     %for v = edges, line(v{:}); end
% end