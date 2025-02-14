set(0,'DefaultFigureWindowStyle','docked');
set(0,'defaultaxesfontsize',10);
set(0,'defaultaxesfontname','Times New Roman') ;
set(0,'DefaultLineLineWidth',2);

nx = 50 ;
ny = 100 ;
V = zeros(nx,ny);
G = sparse(nx*ny,nx*ny);

dx = 1 ; % division of x
dy = 1 ; % division of y

for i = 1:nx
    for j = 1:ny
        n = j + (i-1) * ny; %Node Mapping Equation
        
        % Material Properties
        if (i > 10 && i < 20 && j > 10 && j < 20)
            mat_material = 2 ; % change to 2 for part (ix)
        else
            mat_material = 4 ;
        end
        
        % Set Boundary Conditions
        if (i == 1 || i == nx || j == 1 || j == ny)
            G(n,:) = 0 ; % Set the entire row to zero
            G(n,n) = 1 ; % Set the node point to one so that E(i,j) = E (from eqn)

        % Set Interior Equations 
        else
            nxm = j + (i-2) * ny ; % i - 1
            nxp = j + i * ny ; % i + 1
            nym = (j-1) + (i-1) * ny ; % j - 1
            nyp = (j+1) + (i-1) * ny ; % j + 1
            
            G(n,n) = -mat_material/(dx^2) ; % Diagonal value
            G(n,nxm) = 1/(dx^2) ; % Left value E(i-1,j)
            G(n,nxp) = 1/(dx^2) ; % Right value E(i+1,j)
            G(n,nym) = 1/(dy^2) ; % Below value E(i,j-1)
            G(n,nyp) = 1/(dy^2) ; % Upper value E(i,j+1)

            %G(n,n) = -4 ; % Diagonal value
            %G(n,n+1) = 1 ; % Left value E(i-1,j)
            %G(n,n-1) = 1 ; % Right value E(i+1,j)
            %G(n-1,n) = 1 ; % Below value E(i,j-1)
            %G(n+1,n) = 1 ; % Upper value E(i,j+1)
        end
    end
end

figure('Name','Matrix');
spy(G);

nmodes = 20;
[E,D] = eigs(G, nmodes, 'SM');

figure('Name','EigenValues');
plot(diag(D),'*');

np = ceil(sqrt(nmodes)) ;
figure('Name','Modes') ;
for k = 1:nmodes
    M = E(:,k);
    for i = 1:nx
        for j = 1:ny
            n = i + (j-1)*nx ;
            V(i,j) = M(n) ;
        end
        subplot(np,np,k), surf(V,'LineStyle','none')
        title(['EV=' num2str(D(k,k))])
    end
end

