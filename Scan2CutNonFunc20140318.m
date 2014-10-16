%% Starts with raw binary CT data and end up with minimum fracture energy
clear
clc

Filepath='/home/tonyl/SimpleBIN/Im';
scale=1
firstim=1
imsize=[130,130,130] %Filepath for images, scale (meters per pixel), image size as [1x3] array
%% Import Images
cd('/home/tonyl/BatchRun')

bw=BinStackImprt(Filepath,'%04d','.tif',firstim,imsize); %Builds binary array from image stack
%bw=1;

sprintf('Image Import complete!')

%% Perform Watershed Segmentation
[bonds,CCgrains,labelgrn,bw]=WatershedSeg(bw); %Performs watershed segmentation, outputs bond and grain data
sprintf('Segmentation Complete!')

clear bw
%assignin('base','CCgrainsDebug',CCgrains)
%% Build Graph
[Graph,u,v,CCbonds,From,To,Area]=GraphBuild2(bonds,CCgrains,labelgrn); %Creates node-line graph from bond and grain data
sprintf('Graph complete!')

%Now have a current graph, but there are empty spaces in array where
%"floater" nodes (grains) existed. Graph should be cleaned up to eliminate 
%nodes with no connections

clear labelgrn
clear bonds
%% Calculate Max Flow/Min Cut
cd('/home/tonyl/RunCode/matlab_bgl') %Change directory to use Matlab Boost Graph Laboratory

[flowval,cut,R,F] = max_flow(Graph,u,v);
%[flowval,cut,R,F] = edmunds_karp_max_flow(Graph,u,v);

sprintf('Min Cut Calculated!')
cut;

%% Final Energy Calculations
cd('/home/tonyl/BatchRun')

SampleArea=((CCgrains.ImageSize(1)-4)*scale)*((CCgrains.ImageSize(2)-4)*scale);
IceGamma=75.7e-3; %J/m^2
%sprintf('Sample Energy Cost:')
flowval
Ecost=flowval*scale^2*IceGamma*2;
%sprintf('Critical Energy Release Rate')
Gc=Ecost/SampleArea;


sprintf('Creating cut graphics.')
CutGraphics(cut,CCgrains,Graph);

[brokbond]=BrokenBonds(CCbonds,cut,Area,From,To); %Array of broken bonds


