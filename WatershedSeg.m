function [bonds,CCgrains,labelgrn,bw]=WatershedSeg(bw,figflag)

%% Watershed Segmentation of objects (borrowed heavily from MATLAB help/webpage)
% http://www.mathworks.com/help/images/ref/watershed.html

%bw=Cluster(18,[15,15,15],[15,30,15],[15,22.5,27],[27,22.5,20]);
%bw=CaFuSample
%bw=~bw; %For bw to work with this code, volume=1 and nonvolume=0 for input

% figure, isosurface(bw,0.5), axis equal, title('Snow Microstructure')
% xlabel x, ylabel y, zlabel z
% %xlim(lims), ylim(lims), zlim(lims)
% view(3), camlight, lighting gouraud

%% Distance transform (from matlab help/example)

D = bwdist(~bw);
% figure 
% isosurface(D)
% axis equal
% title('Isosurface of distance transform')
% xlabel x, ylabel y, zlabel z
% %xlim(lims), ylim(lims), zlim(lims)
% view(3), camlight, lighting gouraud

%% Complement distance transform, force nonobject pixels to be -Inf, 
% then compute watershed transform

D=-D;
%D(~bw) = -Inf; %All nonobject pixels go to -infinity, therefore
%This creates a layer of 0 values on non-bond areas around objects after
%watershed segmentation. Problematic. 

%% Perform Watershed Segmentation
% sprintf('Beginning Watershed Segmentation.')
L = watershed(imhmin(D,.5)); %Adjust number after D for segmentation limit
%L=watershed(D);
%% Plotting for segmented objects- multicolor grains

% isosurface(L>=2,0.5) %Matlab seems to make boundaries =0 and nonobject pix =1
% %Each watershed has its own unique integer label, 2 through number of
% %grains
% 
% axis equal
% title('Segmented objects')
% xlabel x, ylabel y, zlabel z
% %xlim(lims), ylim(lims), zlim(lims)
% view(3), camlight, lighting gouraud

%% Create bonds array- 1 where there is a bond voxel, 0 elsewhere
bonds=false(size(L));
% bonds=logical(bonds); %converts bonds array to binary, save space

for i=1:length(L(:,1,1)); %These 5 nested loops create an array of bonds in positions where L=0 and bw=1
    for j=1:length(L(1,:,1));
        for k=1:length(L(1,1,:));
            if L(i,j,k)==0;
                if bw(i,j,k)==1;
                bonds(i,j,k)=1; %Binary bond array: 
                end
            end
        end
    end
end

%% Plot bonds separately on their own array
% figure
% isosurface(bonds,0.5)
% axis equal
% title('Bonds')
% xlabel x, ylabel y, zlabel z
% xlim(lims), ylim(lims), zlim(lims)
% view(3), camlight, lighting gouraud

%% Create objects and grains arrays
%objects=bw+bonds; %Array of object voxels, where objects=1 is original objects, objects=2 is a bond This array may only be useful for graphical output.
grains=bw-bonds;

%% Plot bonds in 1 color and grains in another
if figflag == 1
figure %Figure to show all grains in 1 color and all bonds in another
isosurface(grains,0.5)
isosurface(bonds,0.2)
axis equal
title('Segmented Objects')
end


CCgrains=bwconncomp(grains);
labelgrn=zeros(CCgrains.ImageSize); %Initialize labelgrn as zeros
%labelgrn=single(labelgrn); %Convert to single precision...a good idea, but
%then can't convert to sparse in GraphBuild2
for i=1:length(CCgrains.PixelIdxList); %For Each grain
    for j=1:length(CCgrains.PixelIdxList{i}); %For each voxel of each grain
        labelgrn(CCgrains.PixelIdxList{i}(j))=i; %Label each grain's voxel with number i
    end
end

% assignin('base','bwDebug',bw)
% assignin('base','CCgrainsDebug',CCgrains)
%% Plot multicolor grains
% 
% isoval=0;
% for i=1:CCgrains.NumObjects
%     isosurface(labelgrn==i,isoval)
%     isoval=isoval+.015;
% end
%     
%     
% figure     
% % isosurface(objects==1,0.5)
% isosurface(CCgrains,0.5)
% isosurface(bonds,0.2)
% 
% axis equal
% title('Segmented objects')
% xlabel x, ylabel y, zlabel z
% %xlim(lims), ylim(lims), zlim(lims)
% view(3), camlight, lighting gouraud
% axis equal


