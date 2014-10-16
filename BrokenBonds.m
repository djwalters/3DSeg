%Creates an array that stores the voxels of all broken bonds

function [brokbond]=BrokenBonds(CCbonds,cut,Area,From,To)

imdims=CCbonds.ImageSize; %Store dimensions of array
brokbond=uint8(zeros(imdims)); %Empty 8-bit integer array

for i=1:length(Area); %For all bonds
    
    j=From(i);
    k=To(i);
    if abs(cut(j)-cut(k))==2 %If top of bond is on opposite side of cut from bottom of bond
        
        brokbond(CCbonds.PixelIdxList{i})=1; %Labels each bond in 3D bond array
        %sprintf('Bond broken')
    end
end

end