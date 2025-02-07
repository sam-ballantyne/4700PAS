set(0,'DefaultFigureWindowStyle','docked') ;

%% ELEC4700 PA4: Finite Difference of 2D Laplace Equation

% Number of nodes
nx = 100;
ny = 100;

% Number of Iterations
ni = 10000 ;

% Initialize Matrix of Voltages (V)
V = zeros(nx, ny) ;

% Boundary Conditions
% V(1,:) = 1 ; % Left Boundary
% V(nx,:) = 0 ; % Right Boundary
% V(:,1) = V(:,2) ; % Bottom Boundary
% V(:,ny) = V(:,ny-1) ; % Top Boundary

for k = 1:ni
    for m = 1:nx
        for n = 1:ny 
            %% Set Boundary Conditions
            % Left Side
            if m == 1
                V(m,n) = 1 ;
            % Right Side
            elseif m == nx
                V(m,n) = 1 ;
            % Bottom Side    
            elseif n == 1
                % V(m,n) = V(m,n+1) ;
                V(m,n) = 0 ;
            % Top Side
            elseif n == ny
                % V(m,n) = V(m,n-1) ;
                V(m,n) = 0 ;
            else
            V(m,n) = 1/4*(V(m-1,n)+V(m,n-1)+V(m+1,n)+V(m,n+1)) ;
            end
        end
    end

    % MOVIE
    if mod(k,50) == 0
        surf(V)
        pause(0.05)
    end
end

[Ex,Ey] = gradient(V) ;

figure(2)
quiver(-Ey',-Ex',10) ;
xlabel('Ex') ;
ylabel('Ey') ;

%Use IMBOXFILT function to solve V
figure(3)
B = imboxfilt(V,3) ;
surf(B);