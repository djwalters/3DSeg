% Function to input bond voxels, output area of the best fit (least squares) plane

%function [Area,X,Y,Z,Bond]=PlaneFit(bondnum,CCbonds)
bondnum=1;



Bond=logical(zeros(CCbonds.ImageSize));  %Preallocate zeros, logical array to save memory
for i=1:length(CCbonds.PixelIdxList{bondnum}) %Plot bond of interest from PIxel Id List
    Bond(CCbonds.PixelIdxList{bondnum}(i))=1;
end

%% Create X,Y,Z arrays of bond points
%In future, should reduce size of Bond to save memory. OK for now.
n=0; %counter set to 0
for x=1:CCbonds.ImageSize(1)
    for y=1:CCbonds.ImageSize(2)
        for z=1:CCbonds.ImageSize(3)
            if Bond(x,y,z)==1 %Creating X,Y,Z column arrays with coords of bond voxels
                n=n+1;
                X(n)=x;
                Y(n)=y;
                Z(n)=z;
            end
        end
    end
end

%% Find bond area based on geometry
if max(Y)==min(Y) %If plane is vertical, plane equation function doesn't work
    Area=length(Y); %If plane vertical, area is # of voxels
elseif max(Z)==min(Z) %If bond falls in constant z value, same
    Area=length(Z);
elseif max(X)==min(X) %If bond falls in constant X value, same
    Area=length(X); 
else  %If plane is not neatly vertical/horizontal, bring out the big guns...Best Fit it!
    %Find plane A,B,C for equation z=Ax+By+C
    ABC=[sum(X.*X),sum(X.*Y),sum(X);sum(X.*Y),sum(Y.*Y),sum(Y);sum(X),sum(Y),length(X)]\...
        [sum(X.*Z);sum(Y.*Z);sum(Z)]; %Least squares equation for a plane
    %Unit Normal
    normal=[ABC(1),ABC(2),-1]; %A normal to the plane
    unorm=normal/norm(normal); %Unit normal to the plane
    
    %Thin the surface
      
[QQQ,maxdir]=max(abs(unorm)); %Stores whether the max unit normal is X,Y, or Z (1, 2 or 3)
    
    %Now we have an array of nonzero voxel positions (essentially a
    %compressed surface to work with Flin's algorithm)
    surfvox=nnz(surface); %# of surface voxels is equal to number of nonzero elements in surface array
    %In the future, could only count surface voxels rather than create
    %new array, but for now will keep array for visualization.
    ratio=1/max(abs(unorm)); %Ratio of "true" surface area to area projected onto functional plane (X,Y or Z)
    Area=surfvox*ratio;
    
    
end


%end %Associated with invoking function