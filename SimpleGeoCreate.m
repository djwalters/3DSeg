% Code to create an image stack of simple overlapping spheres where
% the solution is known. For testing code.

%Creates 3 spheres to test skeletonization algorithms
%diam is a scalar, Center1 and Center2 must be row matrices giving
%coordinates of sphere centers. All dimensions in voxels.

diam=100  %Enter sphere diameter
Center1=[40,40,40] %Center of sphere 1 as an array [x1, y1, z1]
Center2=[90,40,90] %Center of sphere 2 as an array [x2, y2, z2]
Center3=[90,40,90] %And so on
Center4=[90,40,90] %And so forth

D=logical(zeros(130,130,130)); %Blank space (ones are empty space in this binarization)

    for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 1st sphere
        for j = 1:length(D(1,:,1))
            for k = 1:length(D(1,1,:))
                if sqrt((i-Center1(1))^2+(j-Center1(2))^2+(k-Center1(3))^2)<=(diam/2)
                    D(i,j,k)=1;
                end
            end
        end
    end
    
    for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 2nd sphere
        for j = 1:length(D(1,:,1))
            for k = 1:length(D(1,1,:))
                if sqrt((i-Center2(1))^2+(j-Center2(2))^2+(k-Center2(3))^2)<=(diam/2)
                    D(i,j,k)=1;
                end
            end
        end
    end
    
     for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 3rd sphere
        for j = 1:length(D(1,:,1))
            for k = 1:length(D(1,1,:))
                if sqrt((i-Center3(1))^2+(j-Center3(2))^2+(k-Center3(3))^2)<=(diam/2)
                    D(i,j,k)=1;
                end
            end
        end
     end
    
      for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 4th sphere
        for j = 1:length(D(1,:,1))
            for k = 1:length(D(1,1,:))
                if sqrt((i-Center4(1))^2+(j-Center4(2))^2+(k-Center4(3))^2)<=(diam/2)
                    D(i,j,k)=1;
                end
            end
        end
    end
    
     
 figure
        isosurface(D,0.99), axis equal,
        camlight, lighting gouraud, title('3D Object')
        
 for i=1:length(D(1,1,:)) %For all layers in stack
     Filename=strcat('/home/tonyl/SimpleBIN/Im',sprintf('%04d',i),'.tif');
     imwrite(D(:,:,i),Filename)
 end
