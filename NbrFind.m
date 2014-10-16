function [NbrGrains]=NbrFind(bondnum,labelgrn,Size,CCbonds) %Function nested in GraphBuild, reports a bond's neighbors

bondvox=CCbonds.PixelIdxList{bondnum}; %List of voxels in current bond
NbrGrains=[];
    for j=1:length(bondvox) %Goes through all voxels in bond to create array of coordinates
        [x,y,z]=ind2sub(Size,bondvox(j)); %Coords of current bond voxel
        Nbrd=labelgrn(x-1:x+1,y-1:y+1,z-1:z+1); %Neighborhood in labeled grain array
        NbrGrains=vertcat(NbrGrains,unique(nonzeros(Nbrd))); %Only unique values of neighbor grains are added to nbrs array
           
    end
    NbrGrains=unique(nonzeros(NbrGrains));
end