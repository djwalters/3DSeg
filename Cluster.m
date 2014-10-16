function D = Cluster(diam,Center1,Center2,Center3,Center4);
%Creates 3 spheres to test skeletonization algorithms
%diam is a scalar, Center1 and Center2 must be row matrices giving
%coordinates of sphere centers


D=ones(50,100,100); %Blank space (ones are empty space in this binarization)

    for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 1st sphere
        for j = 1:length(D(1,:,1))
            for k = 1:length(D(1,1,:))
                if sqrt((i-Center1(1))^2+(j-Center1(2))^2+(k-Center1(3))^2)<=(diam/2)
                    D(i,j,k)=0;
                end
            end
        end
    end
    
    for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 2nd sphere
        for j = 1:length(D(1,:,1))
            for k = 1:length(D(1,1,:))
                if sqrt((i-Center2(1))^2+(j-Center2(2))^2+(k-Center2(3))^2)<=(diam/2)
                    D(i,j,k)=0;
                end
            end
        end
    end
    
     for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 3rd sphere
        for j = 1:length(D(1,:,1))
            for k = 1:length(D(1,1,:))
                if sqrt((i-Center3(1))^2+(j-Center3(2))^2+(k-Center3(3))^2)<=(diam/2)
                    D(i,j,k)=0;
                end
            end
        end
     end
    
      for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 4th sphere
        for j = 1:length(D(1,:,1))
            for k = 1:length(D(1,1,:))
                if sqrt((i-Center4(1))^2+(j-Center4(2))^2+(k-Center4(3))^2)<=(diam/2)
                    D(i,j,k)=0;
                end
            end
        end
    end
    
     
 figure
        isosurface(D,0), axis equal,
        camlight, lighting gouraud, title('3D Object')
return
        

end

