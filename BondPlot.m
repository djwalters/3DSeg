%Routine to plot unique bonds. For debugging/visualizing only. Not part of
%final routine.

labelbnd=zeros(CCbondsDebug.ImageSize); %Zeros for plotting labeled bond array

%% Build labeled grain array. 3D array with values 1=bond #1, 2=bond #2, etc
for i=1:CCbondsDebug.NumObjects
    for j=1:length(CCbondsDebug.PixelIdxList{i});
    labelbnd(CCbondsDebug.PixelIdxList{i}(j))=i;
    end
end

%% Create figure of colored bonds

figure
isoval=0;
for i=[296] %CCbonds.NumObjects. Input bond numbers here.
    isosurface(labelbnd==i,isoval)
    isoval=isoval+.05;
end
axis equal
xlabel x, ylabel y, zlabel z

%% Create figure of colored grains

% figure
% isoval=0;
% for i=1:CCgrains.NumObjects
%     isosurface(labelgrn==i,isoval)
%     isoval=isoval+.05;
% end
% axis equal
% xlabel x, ylabel y, zlabel z

