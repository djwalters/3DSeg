function [a]=EucFromCent(size) %Calculates the euclidean distance of each voxel from the center of a size x size x size array. Size must be an odd number, otherwise there is no center voxel.

a=zeros(size,size,size);
center=size/2+0.5; %Position of center voxel

for i=1:size;
    for j=1:size;
        for k=1:size;
            a(i,j,k)=sqrt((i-center)^2+(j-center)^2+(k-center)^2);
        end
    end
end

end