function [Data]=Segmentation3D(runtype,imsize,FileOutFlag,figflag,FileIO) 
% Function FabricTensor.m takes an image stack with cross sections parallel
% to the snow surface and performs 3-D segmentation finding bonds and grain
% pairs.  
%
% INPUTS:
%   Code requires input of an image stack with sequential numbering of
%   binarized images exported from a CT Scan.  First and last images in the
%   sequence will be selected by the GUI.  The starting filepath is custom
%   and needs to be modified by the specfic user (see line 49: uigetfile)
%       
%       runtype: specify either 'desktop' or 'terminal' to determine whether
%       graphical picking is enabled or not.  When running from a terminal
%       in a batch job, graphical picking and figures do not display.  This
%       also supresses all figures, regardless of the figflag input.
%
%       imsize: Specifies number of pixels in the [Y X] directions to analyze
%       on each cross section.  If the full cross section of the image is
%       desired, enter 0 here.
%
%       FileOutFlag: This specifies whether a .csv output file is created.
%       The output path of the file is customized.  See line 99 to change
%       file path to your specific needs (var = OutFilePath).
%               Specify 0 for no output (can omit if figflag is omitted)
%               Specify 1 for output
%
%       figflag: This specifies whether graphics of bond segmentation is
%       displayed or not.  When running on remote Linux server, graphics
%       generation can severely impact code performance
%               Specify 0 for no graphics (or omit all together)
%               Specify 1 for graphics
%
%       FileIO: This is a 4 element cell vector of strings containing the
%       required input and output file paths and names.  Format is as
%       specified below:
%               {'Binary image stack file path';
%                   'First binary image file name.ext';
%                   'Last binary image file name.ext';
%                   'Output file name' (no extension)}
%
%   OUTPUT:
%       Data is an array containing pertinent bond and grain information
%       for generating a contact tensor derived from 3-D volume
%       segmentation.  Column headers are as follows:
%       header=['Bond (ID), Bond X (pix), Bond Y (pix), Bond Z (pix)'...
%         ',Grain 1 (ID),Grain 1 X (pix), Grain 1 Y (pix), Grain 1 Z (pix)'...
%         ',Grain 2 (ID),Grain 2 X (pix), Grain 2 Y (pix), Grain 2 Z (pix)'...
%         ',Bond Area (pix^2),Bond Norm X (pix), Bond Norm Y (pix), Bond Norm Z (pix)'];
%
% Author: Anthony Lebaron, Montana State University
%   Edited by: David J. Walters, Montana State University
matlabpool open 8
if exist('figflag','var') == 0
    figflag = 0;
end
if exist('FileOutFlag','var') == 0
    FileOutFlag = 0;
end
%% Starts with raw binary CT data and end up with minimum fracture energy
%Inputs: Filepath for images, scale (meters per pixel), image size as [1x3]
%array [x y z], figflag(1 for figures, 0 for no figures)
%Outputs:[Data,normal,Area,GrainBondSets]

switch runtype
    case 'desktop'
        % Linux File Path
        [FirstFileName,FirstPathName] = uigetfile('/home/david.walters/PhD Work/MicroMechanics/CT Images/*.*'...
            ,'Select First Image in Stack');
        
        % Windows File Path
        % [FirstFileName,FirstPathName] = uigetfile('C:\Doctoral Researach\Linux FTP Mirror\PhD Work\MicroMechanics\CT Images\*.*'...
        %     ,'Select First Image in Stack');
        
        [LastFileName] = uigetfile([FirstPathName,'*.*'],'Select Last Image in Stack');
        [~,FirstInName,ext] = fileparts(FirstFileName);
        [~,LastImageName,~] = fileparts(LastFileName);
        FirstImageNum = str2num(FirstInName(end-3:end));
        LastImageNum = str2num(LastImageName(end-3:end));
        
        if FileOutFlag == 1
            OutFileName = input('Enter output file name (without suffix)\n','s');
        end
    case 'terminal'
        FirstPathName = FileIO{1}
        FirstFileName = FileIO{2}
        LastFileName = FileIO{3}
        [~,FirstInName,ext] = fileparts(FirstFileName);
        [~,LastImageName,~] = fileparts(LastFileName);
        FirstImageNum = str2num(FirstInName(end-3:end));
        LastImageNum = str2num(LastImageName(end-3:end));
        
        if FileOutFlag == 1
            OutFileName = FileIO{4}
        end
end
%% Import Images
% cd('F:\MSU PhD Research\Snow Stereology\2013-12-13 Shear NEW Series\0930\Trans')
fprintf('Begin image import.\n')
bw=BinStackImprt(FirstPathName,FirstInName(1:end-4),'%04d',ext,FirstImageNum,imsize,LastImageNum); %Builds binary array from image stack
bw = logical(bw);
%bw=1;

fprintf('Image Import complete!\n')
fprintf('%s\n\n',datestr(now,'mmmm dd, yyyy HH:MM:SS AM'))

%% Perform Watershed Segmentation
fprintf('Begin watershed segmentation.\n')
[bonds,CCgrains,labelgrn,bw]=WatershedSeg(bw,figflag); %Performs watershed segmentation, outputs bond and grain data
fprintf('Segmentation Complete!\n')
fprintf('%s\n\n',datestr(now,'mmmm dd, yyyy HH:MM:SS AM'))

clear bw

%% Calculate Effective Grain Radius for Individual Grains
fprintf('Begin grain radius calculation.\n')
GrainRadius = InscribedSphere(CCgrains)
fprintf('Grain radius calculation complete!\n')
fprintf('%s\n\n',datestr(now,'mmmm dd, yyyy HH:MM:SS AM'))

%% Build Graph
fprintf('Begin analyzing bond and grain sets.\n')
% [Graph,u,v,CCbonds,From,To,Area,normal,GrainBondSets]=GraphBuild2(bonds,CCgrains,labelgrn); %Creates node-line graph from bond and grain data
[Area,normal,GrainBondSets,CCbonds]=GraphBuild2(bonds,CCgrains,labelgrn);
fprintf('Bond grain sets complete!\n')
fprintf('%s\n\n',datestr(now,'mmmm dd, yyyy HH:MM:SS AM'))
%Now have a current graph, but there are empty spaces in array where
%"floater" nodes (grains) existed. Graph should be cleaned up to eliminate 
%nodes with no connections
% normal;
% Area;
% clear labelgrn
% clear bonds
fprintf('Create Data Array.\n')
[Data] = FinalDataArray(CCgrains,CCbonds,GrainBondSets,Area,normal,GrainRadius);
fprintf('Create Data Array Complete!\n')
fprintf('%s\n\n',datestr(now,'mmmm dd, yyyy HH:MM:SS AM'))

% Generates .csv output to specified folder in OutFilePath
if FileOutFlag == 1
%     Linux File Path
    OutFilePath = '/home/david.walters/PhD Work/MicroMechanics/Matlab 3D Segmentation Results/';
%     Windows File Path
%     OutFilePath = 'C:\Doctoral Researach\Linux FTP Mirror\PhD Work\MicroMechanics\Matlab 3D Segmentation Results\';
    header = ['Bond(Idx),BCx(pix),BCy(pix),BCz(pix)'...
        ',BA(pix^2),BNx(pix),BNy(pix),BNz(pix)'...
        ',G1(Idx),G1Cx(pix),G1Cy(pix),G1Cz(pix),G1Rad(pix)'...
        ',G1RCx(pix),G1RCy(pix),G1RCz(pix),G2(Idx),G2Cx(pix)'...
        ',G2Cy(pix),G2Cz(pix),G2Rad(pix),G2RCx(pix)'...
        ',G2RCy(pix),G2RCz(pix)'];
    outid = fopen([OutFilePath,OutFileName,'.csv'], 'w');
    fprintf(outid, '%s\n', header);
    fclose(outid);
    dlmwrite ([OutFilePath,OutFileName,'.csv'],Data,'delimiter',',','-append');
    fprintf('Data successfully output to %s\n\n',[OutFilePath,OutFileName,'.csv'])
else
    fprintf('No data written to external file.  If desired, set FileOutFlag = 1\n\n')
end
% Data = [GrainBondSets,Area,normal];
% csvwrite('/home/david.walters/PhD Work/MicroMechanics/Edited Code/Output/BondGrainData.csv',Data)
%% Construct Fabric Tensor

matlabpool close
end
