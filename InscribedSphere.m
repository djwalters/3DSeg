function GrainRadius = InscribedSphere(CCgrains)
GrainRadius = zeros(CCgrains.NumObjects,5);
parfor i = 1:CCgrains.NumObjects
    % Preallocate array so linear indexing has proper mapping
    Object = false(CCgrains.ImageSize);
    %Populate 3-D Array "Object" with only 1 seperate object at a time
    Object(CCgrains.PixelIdxList{i}) = 1;
%     figure, isosurface(Object,0.5);
%     axis equal

    % Perform the distance transform on the singular object
    DObject = bwdist(~Object);
    
    %Calculate the value and position of the max distance transform
    [C1,I1] = max(DObject);
    [C2,I2] = max(C1);
    [C3,I3] = max(C2);
    I1small=squeeze(I1);
    Z = I3;
    X = I2(I3);
    Y = I1small(X,Z);
 
    % GrainRadius organizes data into neat data array
    % Format:
    % Grain #--Max Distance Transform(grain radius)--X--Y--Z (grain radius
    % center)
    GrainRadius(i,:) = [i,C3,X,Y,Z];
end
end