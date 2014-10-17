function D = Squares(diam,Center1)
%Creates 3 spheres to test skeletonization algorithms
%diam is a scalar, Center1 and Center2 must be row matrices giving
%coordinates of sphere centers


D=ones(100,100,100); %Blank space (ones are empty space in this binarization)

    for i = 1:length(D(:,1,1)) %This for statement encapsulates creation of 1st sphere
        for j = 1:length(D(1,:,1))
            for k = 1:length(D(1,1,:))
                if (abs(i-Center1)<=diam/2) 
                    if (abs(j-Center1)<=diam/2)
                        if (abs(k-Center1)<=diam/2)
                            D(i,j,k)=0;
                        end
                    end
                end
            end
        end
    end
    
    
 figure
        isosurface(D,0), axis equal,
        camlight, lighting gouraud, title('3D Object')
return
        

end

