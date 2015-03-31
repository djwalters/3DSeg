% Code to create an image stack of simple overlapping spheres where
% the solution is known. For testing code.

%Creates 3 spheres to test skeletonization algorithms
%diam is a scalar, Center1 and Center2 must be row matrices giving
%coordinates of sphere centers. All dimensions in voxels.

diam=40;  %Enter sphere diameter
Center{1}=[25,25,25]; %Center of sphere 1 as an array [x1, y1, z1]
Center{2}=[25,25,60]; %Center of sphere 2 as an array [x2, y2, z2]
Center{3}=[60,25,25]; %And so on
Center{4}=[60,25,60]; %And so forth
Center{5}=[25,60,25]; 
Center{6}=[25,60,60]; 
Center{7}=[60,60,25]; 
Center{8}=[60,60,60];

D=logical(zeros(130,130,130)); %Blank space (ones are empty space in this binarization)

for m = 1:length(Center)
for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 1st sphere
    for j = 1:length(D(1,:,1))
        for k = 1:length(D(1,1,:))
            if sqrt((i-Center{m}(1))^2+(j-Center{m}(2))^2+(k-Center{m}(3))^2)<=(diam/2)
                D(i,j,k)=1;
            end
        end
    end
end
% 
% for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 2nd sphere
%     for j = 1:length(D(1,:,1))
%         for k = 1:length(D(1,1,:))
%             if sqrt((i-Center2(1))^2+(j-Center2(2))^2+(k-Center2(3))^2)<=(diam/2)
%                 D(i,j,k)=1;
%             end
%         end
%     end
% end
% 
% for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 3rd sphere
%     for j = 1:length(D(1,:,1))
%         for k = 1:length(D(1,1,:))
%             if sqrt((i-Center3(1))^2+(j-Center3(2))^2+(k-Center3(3))^2)<=(diam/2)
%                 D(i,j,k)=1;
%             end
%         end
%     end
% end
% 
% for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 4th sphere
%     for j = 1:length(D(1,:,1))
%         for k = 1:length(D(1,1,:))
%             if sqrt((i-Center4(1))^2+(j-Center4(2))^2+(k-Center4(3))^2)<=(diam/2)
%                 D(i,j,k)=1;
%             end
%         end
%     end
% end

end
 figure
        isosurface(D,0.99), axis equal,
        camlight, lighting gouraud, title('3D Object')
        
 for i=1:length(D(1,1,:)) %For all layers in stack
     Filename=strcat('C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\Images\',sprintf('%04d',i),'.tif');
     imwrite(D(:,:,i),Filename)
 end
