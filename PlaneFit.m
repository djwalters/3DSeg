% Function to input bond voxels, output area of the best fit (least squares) plane

function [area,unorm]=PlaneFit(bondnum,CCbonds)
%bondnum=1;



Bond=false(CCbonds.ImageSize);  %Preallocate zeros, logical array to save memory
for i=1:length(CCbonds.PixelIdxList{bondnum}) %Plot bond of interest from PIxel Id List
    Bond(CCbonds.PixelIdxList{bondnum}(i))=1;
end

%% Create X,Y,Z arrays of bond points
%In future, should reduce size of Bond to save memory. OK for now.
n=0; %counter set to 0
% Due to the index relationships to the x, y, and z coordinates, the x and
% y indices need to be flipped.  When referencing a coordinate direction in
% an array, the location should be array(Y,X,Z).  For this reason, the for
% statements are also flipped.

% for x=1:CCbonds.ImageSize(1)
%     for y=1:CCbonds.ImageSize(2)

for y=1:CCbonds.ImageSize(1)
    for x=1:CCbonds.ImageSize(2)
        for z=1:CCbonds.ImageSize(3)
            if Bond(y,x,z)==1 %Creating X,Y,Z column arrays with coords of bond voxels
                n=n+1;
                X(n)=y;
                Y(n)=x;
                Z(n)=z;
            end
        end
    end
end

%% Find bond area based on geometry
if max(Y)==min(Y) %If plane is vertical, plane equation function doesn't work
    area=length(Y); %If plane vertical, area is # of voxels
    unorm=[0 1 0];
elseif max(Z)==min(Z) %If bond falls in constant z value, same
    area=length(Z);
    unorm=[0 0 1];
elseif max(X)==min(X) %If bond falls in constant X value, same
    area=length(X); 
    unorm=[1 0 0];
else  %If plane is not neatly vertical/horizontal, bring out the big guns...Best Fit it!
    %Find plane A,B,C for equation z=Ax+By+C
    ABC=[sum(X.*X),sum(X.*Y),sum(X);sum(X.*Y),sum(Y.*Y),sum(Y);sum(X),sum(Y),length(X)]\...
        [sum(X.*Z);sum(Y.*Z);sum(Z)]; %Least squares equation for a plane
    %Unit Normal
    normal=[-ABC(1)/sqrt(ABC(1)^2+ABC(2)^2+(-1)^2),...
        -ABC(2)/sqrt(ABC(1)^2+ABC(2)^2+(-1)^2),...
        1/sqrt(ABC(1)^2+ABC(2)^2+(-1)^2)]; %A normal to the plane
    %     normal = ABC; %Normal Vector
    %     unorm=normal/norm(normal); %Unit normal to the plane
    unorm = normal;
    
    %Thin the surface
      
    surface=Bond; %Surface array; some voxels will be eliminated
    for j=1:length(X)
        if max(abs(unorm))==abs(unorm(1)) %If max plane normal is in x direction
            %sprintf('Max Normal in X!')
            if surface(X(j)+1,Y(j),Z(j))==1 %If there is another bond in the x direction
                surface(X(j),Y(j),Z(j))=0; %Delete current voxel because it is redundant for projection
                continue %Go to next iteration of for loop
            end
            if surface(X(j)-1,Y(j),Z(j))==1
                surface(X(j),Y(j),Z(j))=0; %Delete current voxel because it is redundant for projection
                continue %Go to next iteration of for loop
            end
            continue
        end
        
        if max(abs(unorm))==abs(unorm(2)) %If max plane normal is in y direction
            %sprintf('Max Normal in Y!')
            if surface(X(j),Y(j)+1,Z(j))==1 %If there is another bond in the y direction
                surface(X(j),Y(j),Z(j))=0; %Delete current voxel because it is redundant for projection
                continue %Go to next iteration of for loop
            end
            if surface(X(j),Y(j)-1,Z(j))==1
                surface(X(j),Y(j),Z(j))=0; %Delete current voxel because it is redundant for projection
                continue %Go to next iteration of for loop
            end
            continue
        end
        
         if max(abs(unorm))==abs(unorm(3)) %If max plane normal is in z direction
             %sprintf('Max Normal in Z!')
            if surface(X(j),Y(j),Z(j)+1)==1 %If there is another bond in the z direction
                surface(X(j),Y(j),Z(j))=0; %Delete current voxel because it is redundant for projection
                continue %Go to next iteration of for loop
            end
            if surface(X(j),Y(j),Z(j)-1)==1
                surface(X(j),Y(j),Z(j))=0; %Delete current voxel because it is redundant for projection
                continue %Go to next iteration of for loop
            end
            continue
        end
        
    end
    
    %Now we have a 3D array of surface voxels (essentially a thinned
    %surface to work with Flin's algorithm)
    surfvox=nnz(surface); %# of surface voxels is equal to number of nonzero elements in surface array
    %In the future, could only count surface voxels rather than create
    %new array, but for now will keep array for visualization.
    ratio=1/max(abs(unorm)); %Ratio of "true" surface area to area projected onto functional plane (X,Y or Z)
    area=surfvox*ratio;
    
    
end


end %Associated with invoking function