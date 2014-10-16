%If one continuous bond, as identified by watershed segmentation, touches
%more than 2 grains, this script identifies which bond voxels belong to 
%which grains

function [GrainPair,CCbonds]=multigrain(bondnum,CCbonds,labelgrn) %Function to separate bond areas in the case of >2 grains per continuous bond.
Separated=[0 0 0]; %Separated is a three column, multi-row array that will store bond voxel index, 1st neighbor grain, and 2nd neighbor grain.

%% Go through every voxel in the current bond, determine what each voxel's closest neighbors are

for i=1:length(CCbonds.PixelIdxList{1,bondnum}) %For each bond voxel
    %bondnum %Display bond # for troubleshooting
    %i %Display bond voxel # in pixelidxlist
    dists=EucFromCent(5); %Euclidean distance of every voxel from center in a 5x5x5 neighborhood. This can be customized to search a closer or further neighborhood if necessary.
    uniques=unique(dists); %List of unique distances in dists. Allows us to search closest voxels first later on.
    [x,y,z]=ind2sub(CCbonds.ImageSize,CCbonds.PixelIdxList{1,bondnum}(i)); %Voxel location x,y,z
    nbrd=labelgrn(x-2:x+2,y-2:y+2,z-2:z+2); %nbrd is the labeled grains surrounding the current bond voxel
    
    Closest=0; %Empty array to store grains closest to current voxel
    Closest=nonzeros(Closest); %Make Closest a nonzero array
        
    for j=2:length(uniques) %For all nonzero distances from current bond voxel (uniques(1)=0, so we start with j=2)
        
        Closest=unique(Closest); %Eliminates repeats from closest array
        
        Closest=unique(vertcat(Closest,unique(nonzeros(nbrd(dists==uniques(j)))))); %Find all unique grains where distance from voxel is current value, add to current list of closests
        
        if length(Closest)>=2 %If >=2 closest neighbors have been found, this loop will assign 2 neighbors to that voxel. In the event of a three way tie, the bonds assigned are arbitrary.
            Separated=vertcat(Separated,[CCbonds.PixelIdxList{1,bondnum}(i),Closest(1),Closest(2)]); %The first two neighbor grains are assigned to this voxel
            break %And we can stop going through neighbors of this voxel
        end
    end
end

%% Now, we should have an array with one bond voxel index per row and its
% 2 closest grains. Column 1 is voxel index, column 2 is a closest
% neighbor grain, and column three is a closest neighbor grain

%Sort columns 2 and 3 in ascending order 

for i=1:length(Separated(:,1)) %For all bond voxels
    Grain1=min(Separated(i,2:3));
    Grain2=max(Separated(i,2:3));
    Separated(i,2)=Grain1;
    Separated(i,3)=Grain2; %Sort all neighbor grains in ascending order
end

Separated(1,:)=[]; %Eliminates 1st row of zeros that was initially put in to enable the vertcat command. Is there a better way to do this?

%% Now there is a Separated array where each row looks like [bond vox
% index,Grain 1,Grain2. Sort by matching Grain1 and Grain2 values

Separated=sortrows(Separated,[2,3]); %Sort by 2nd then 3rd column

%The first NEW BOND voxels will replace bondnum in CCbonds
done=0; %Trigger to end function if done==1

newbond=Separated(1,1); %First voxel in Separated is assigned to array newbond
%assignin('base','SepDebug',Separated)
for i=1:length(Separated) %For all voxels in Separated
    
    if Separated(i,2:3)==Separated(1,2:3) %If voxel in row i of separated belongs to new bond #1
        newbond=nonzeros(vertcat(newbond,Separated(i,1))); %newbond array is supplemented with a new voxel
        if i==length(Separated(:,1))
            %sprintf('Only 1 bond existed, but multigrain was initiated...')
            done=1; %Trigger to break out of function
            break
        end
    else
        CCbonds.PixelIdxList{1,bondnum}=newbond; %Replace the current bond in CCbonds with this first new bond
        GrainPair=Separated(1,2:3);
        lastpos=i; %Stores the last row in Separated that belongs to first bond
        %sprintf('1st new bond has been created')
        break %Exit for loop
    end
end

if done==1
    GrainPair=Separated(1,2:3);
    return
end

newbonds=0; %A counter to track the number of new entries to CCbonds
anustart=1; %A binary indicator to tell the for loop if it's starting a new bond. 1=yes, 0=no

for i=lastpos+1:length(Separated(:,1)) %For all remaining voxels in Separated
    
    
        if anustart==1 %If we are starting a new bond. This should trigger only after the first bond from the previous for loop
            newbond=Separated(i,1); %The voxel in row i belongs to the new bond
            anustart=0;
            continue
        elseif Separated(i,2:3)==Separated(i-1,2:3) %If anustart!=1 and we're in the same bond, then supplement the newbond array
            newbond=nonzeros(vertcat(newbond,Separated(i,1))); %newbond array is supplemented with a new voxel
            if i==length(Separated(:,1))
            %sprintf('Final bond being written to CCbonds')
            newbonds=newbonds+1;
            CCbonds.PixelIdxList{1,CCbonds.NumObjects+1}=newbond; %Create a new bond in CCbonds
            CCbonds.NumObjects= CCbonds.NumObjects+1; %Append the number of objects in CCbonds
            %mulgrndone=1; %Not sure what this was all about
            end


        else %If anustart==0 and this row does not match the last row,
            %sprintf('New bond being written to CCbonds')
            newbonds=newbonds+1;
            CCbonds.PixelIdxList{1,CCbonds.NumObjects+1}=newbond; %Create a new bond in CCbonds
            CCbonds.NumObjects= CCbonds.NumObjects+1; %Append the number of objects in CCbonds
            newbond=Separated(i,1); %Start new bond
            
            
        end
    
end

end
    
   
        
        