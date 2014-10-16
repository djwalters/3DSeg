%% Script to build graph from segmented images
function [Area,normal,GrainBondSets,CCbonds]=GraphBuild2(bonds,CCgrains,labelgrn)
% [Graph,u,v,CCbonds,From,To,Area,normal,GrainBondSets]=GraphBuild2(bonds,CCgrains,labelgrn)
%% Identify and label Discrete grains and bonds. Commented out b/c this is now done externally

Size=size(bonds); %Size of array 

bonds(1:2,:,:)=0; %Six planes to erase bond voxels on edge of image. Prevents edge problems when analyzing neighborhoods. Could be improved?
bonds(:,1:2,:)=0;
bonds(:,:,1:2)=0;
bonds(Size(1)-1:Size(1),:,:)=0;
bonds(:,Size(2)-1:Size(2),:)=0;
bonds(:,:,Size(3)-1:Size(3))=0;

CCbonds=bwconncomp(bonds);%Lists voxels in each bond, 
GrnStat=regionprops(CCgrains,'Centroid'); %Stores centroids of each grain
% assignin('base','GrnStatDebug',GrnStat)
% assignin('base','CCbondsDebug',CCbonds) %Writes a copy of CCbonds to workspace in case function doesn't finish
%% Identify neighbor grains of each bond and top/bottom relationship for flow directions
bondnum=1; %start a counter for the while loop

while bondnum<=CCbonds.NumObjects %For all bonds
    if rem(bondnum,1000) == 0;
        fprintf('Calculated %d bonds\n',bondnum)
        fprintf('%s\n\n',datestr(now,'mmmm dd, yyyy HH:MM:SS AM'))
    end
%     bondnum;
    [NbrGrains]=NbrFind(bondnum,labelgrn,Size,CCbonds);
       %Output displays grain idx number (from CCgrains) associated with 
       %bond idx number (from CCbonds)
    %At this point, we have the numerical "names" of each grain touching
    %bond i. We assume flow from high z to low z.
    
    if length(NbrGrains)>2 %If a bond touches 3 or 4 grains, there is more work to be done!
        %sprintf('multigrain routine triggered')
%         bondnum;
        [NbrGrains,CCbonds]=multigrain(bondnum,CCbonds,labelgrn);
        %NbrGrains=NbrGrains(1:2); %Temporary patch- not the best idea
    end
    
    if length(NbrGrains)<2 %If a bond has 1 or 0 neighbors, it is a floater and should be eliminated...WHY WOULD THIS HAPPEN?!?!?! Probably due to trimming...
        fprintf('Bond detected with 0 or 1 neighbors\n')
        bondnum=bondnum+1
        continue
    end
    
    GrainPair = NbrGrains; %Grain Neighbors must be whittled down to pairs...add later
% GrainBondSets is an array where each column is a grain pair and
% associated bond.  The grain numbers are in rows 1 and 2 with the bond
% number in row 3.  The grain and bond numbers refer to the idx number
% associated with CCgrains and CCbonds.  From here, centroid dimensions can
% be extraceted.
    GrainBondSet(2:3,bondnum) = GrainPair;
    GrainBondSet(1,bondnum) = bondnum;
    
%     [Fromi,Toi]=FromTo(GrainPair,GrnStat); %Decides which grain is the "from" and which is the "to"
    

    
%     From(bondnum)=Fromi; %Adds value to directed graph array
%     To(bondnum)=Toi; %Adds value to directed graph array
    [Area(bondnum),normal(bondnum,:)]=PlaneFit(bondnum,CCbonds);
    %Area(bondnum)=length(CCbonds.PixelIdxList{bondnum}); %Values for bond area, set to # of voxels for testing/debugging. Refine later.
    bondnum=bondnum+1;
end
GrainBondSets = GrainBondSet';

% Run routine that effectively deletes "floaters" from data array.  If left
% in the array, the bond number never gets removed from zero and could
% cause indexing issues later on.
b = 1;
while b <= size(GrainBondSets,1)
    if GrainBondSets(b,1) == 0
        GrainBondSets(b,:) = [];
        Area(b) = [];
        normal(b,:) = [];
        b = b;
    else
        b = b+1;
    end
end
Area = Area';
% %% Add Top and Bottom Master Nodes
% u=CCgrains.NumObjects+1; %Label of master start node
% v=CCgrains.NumObjects+2; %Label of master end node
% 
% %% Determine which grains are "From" but not "To," these connect to the top
% %master node
% Tops=setdiff(From,To); %Array of all grains that are in "From" but not "To"
% To=[To,Tops];
% 
% for i=length(From)+1: length(To); 
%     From(i)=u; %Creates a new node labeled as 1 more than # of grains
%     Area(i)=100000; %Arbitrarily high number that won't limit flow
% end
% 
% %% Determine which grains are in "To" but not in "From," these connect to
% %bottom master node
% 
% Bottoms=setdiff(To,From); %Array of nodes that are in "to" but not "from"
% From=[From,Bottoms]; %Append From to include bottom nodes
% for i=length(To)+1:length(From)
%     To(i)=v; %Creates a new node labeled as 2 more than # of grains
%     Area(i)=100000;
% end
% 
% %Sometimes zeros end up in From, To, and Area, remove them.
% From(From==0)=[];
% To(To==0)=[];
% Area(Area==0)=[];
% 
% %% Assemble sparse graph matrix
% Graph=sparse(From,To,Area,v,v);